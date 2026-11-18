-- Migra una base creada con el esquema viejo (shot_type / shots_attempted / shots_made)
-- al esquema por zonas que usa el backend. Conserva los datos existentes.
-- Uso: docker exec -i infraestructura-db-1 psql -U postgres -d hoopid_db < migrations/001_shooting_zones.sql
BEGIN;

ALTER TABLE shooting_sessions ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP NOT NULL DEFAULT NOW();

CREATE TABLE IF NOT EXISTS shooting_session_zones (
    id SERIAL PRIMARY KEY,
    session_id INT NOT NULL REFERENCES shooting_sessions(id) ON DELETE CASCADE,
    zone VARCHAR NOT NULL,
    attempts INT NOT NULL CHECK (attempts > 0),
    made INT NOT NULL CHECK (made >= 0 AND made <= attempts),
    UNIQUE (session_id, zone)
);

-- Filas viejas: no existe equivalente exacto de "Triple", se las asigna a la zona 'top'.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_name = 'shooting_sessions' AND column_name = 'shots_attempted') THEN
    INSERT INTO shooting_session_zones (session_id, zone, attempts, made)
    SELECT id, 'top', shots_attempted, LEAST(shots_made, shots_attempted)
    FROM shooting_sessions
    WHERE shots_attempted > 0
    ON CONFLICT (session_id, zone) DO NOTHING;
  END IF;
END $$;

ALTER TABLE shooting_sessions
  DROP COLUMN IF EXISTS shot_type,
  DROP COLUMN IF EXISTS shots_attempted,
  DROP COLUMN IF EXISTS shots_made,
  DROP COLUMN IF EXISTS notes;

-- Defaults y restricciones que el esquema original no tenía.
ALTER TABLE users ALTER COLUMN created_at SET DEFAULT NOW();
ALTER TABLE shooting_sessions ALTER COLUMN created_at SET DEFAULT NOW();
ALTER TABLE shooting_sessions ALTER COLUMN updated_at SET DEFAULT NOW();
ALTER TABLE match_boxscores ALTER COLUMN created_at SET DEFAULT NOW();
CREATE UNIQUE INDEX IF NOT EXISTS profiles_user_id_key ON profiles (user_id);
CREATE INDEX IF NOT EXISTS idx_shooting_sessions_user_date ON shooting_sessions (user_id, session_date);
CREATE INDEX IF NOT EXISTS idx_match_boxscores_user_date ON match_boxscores (user_id, match_date);

COMMIT;
