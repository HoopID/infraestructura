CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR UNIQUE,
    password VARCHAR,
    created_at TIMESTAMP
);

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
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

CREATE TABLE shooting_sessions (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    session_date DATE,
    shot_zone VARCHAR,
    attempts INT,
    made INT,
    created_at TIMESTAMP
);

CREATE TABLE match_boxscores (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    match_date DATE,
    opponent VARCHAR,
    minutes_played INT,
    points INT,
    rebounds INT,
    assists INT,z
    steals INT,
    blocks INT,
    turnovers INT,
    fouls INT,
    created_at TIMESTAMP
);
