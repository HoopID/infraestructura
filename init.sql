-- Esquema de HoopID. Se ejecuta solo la primera vez que se crea el volumen.
-- Para bases ya creadas, ver migrations/.

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR NOT NULL UNIQUE,
    password VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR,
    last_name VARCHAR,
    height_cm INT,
    weight_kg DECIMAL,
    wingspan_cm INT,
    position VARCHAR,
    dominant_hand VARCHAR,
    vertical_leap_cm INT,
    current_club VARCHAR,
    selection_team VARCHAR
);

-- Una sesión de tiro = una fecha; el detalle por zona está en shooting_session_zones.
CREATE TABLE shooting_sessions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_date DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE shooting_session_zones (
    id SERIAL PRIMARY KEY,
    session_id INT NOT NULL REFERENCES shooting_sessions(id) ON DELETE CASCADE,
    zone VARCHAR NOT NULL,
    attempts INT NOT NULL CHECK (attempts > 0),
    made INT NOT NULL CHECK (made >= 0 AND made <= attempts),
    UNIQUE (session_id, zone)
);

CREATE TABLE match_boxscores (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    match_date DATE NOT NULL,
    opponent VARCHAR NOT NULL,
    minutes_played INT NOT NULL DEFAULT 0,
    points INT NOT NULL DEFAULT 0,
    rebounds INT NOT NULL DEFAULT 0,
    assists INT NOT NULL DEFAULT 0,
    steals INT NOT NULL DEFAULT 0,
    blocks INT NOT NULL DEFAULT 0,
    turnovers INT NOT NULL DEFAULT 0,
    fouls INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_shooting_sessions_user_date ON shooting_sessions (user_id, session_date);
CREATE INDEX idx_match_boxscores_user_date ON match_boxscores (user_id, match_date);
