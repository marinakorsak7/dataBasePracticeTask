CREATE TABLE league_data.teams (
    team_id SERIAL PRIMARY KEY,
    team_name VARCHAR(255) NOT NULL,
    foundation_year DATE NOT NULL CHECK (foundation_year > '1900-01-01'),
    city VARCHAR(100) NOT NULL
);

CREATE TABLE league_data.players (
    player_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    date_of_birth DATE CHECK (date_of_birth > '1980-01-01'),
    team_id INTEGER REFERENCES league_data.teams(team_id)
);

CREATE TABLE league_data.matches (
    match_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    location VARCHAR(255) NOT NULL,
    team_a_id INTEGER NOT NULL,
    team_b_id INTEGER NOT NULL,
    FOREIGN KEY (team_a_id) REFERENCES league_data.teams(team_id),
    FOREIGN KEY (team_b_id) REFERENCES league_data.teams(team_id),
    match_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE league_data.results (
    match_id INTEGER PRIMARY KEY REFERENCES league_data.matches(match_id),
    team_a_goals INTEGER NOT NULL CHECK (team_a_goals >= 0),
    team_b_goals INTEGER NOT NULL CHECK (team_b_goals >= 0),
    result_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE league_data.teams
ADD CONSTRAINT unique_team_name UNIQUE (team_name);

ALTER TABLE league_data.matches
ADD CHECK (date > '2000-01-01');

INSERT INTO league_data.teams (team_name, foundation_year, city)
VALUES 
    ('Real Madrid', '1902-03-06', 'Madrid'),
    ('FC Barcelona', '1900-11-29', 'Barcelona'),
    ('Atletico Madrid', '1903-04-26', 'Madrid'),
    ('Sevilla FC', '1901-01-25', 'Sevilla'),
    ('Valencia CF', '1919-03-18', 'Valencia');

INSERT INTO league_data.players (first_name, last_name, position, date_of_birth, team_id)
VALUES 
    ('Karim', 'Benzema', 'Forward', '1987-12-19', 3),
    ('Vinicius', 'Junior', 'Forward', '2000-07-12', 3),
    ('Lionel', 'Messi', 'Forward', '1987-06-24', 4),
    ('Gerard', 'Pique', 'Defender', '1987-02-02', 4),
    ('Jan', 'Oblak', 'Goalkeeper', '1993-01-07', 5),
    ('Joao', 'Felix', 'Forward', '1999-11-10', 5),
    ('Jesus', 'Navas', 'Defender', '1985-11-21', 6),
    ('Youssef', 'En-Nesyri', 'Forward', '1997-06-01', 6),
    ('Jose', 'Gaya', 'Defender', '1995-05-25', 7),
    ('Carlos', 'Soler', 'Midfielder', '1997-01-02', 7);

INSERT INTO league_data.matches (date, location, team_a_id, team_b_id)
VALUES 
    ('2023-10-01', 'Estadio Santiago Bernabeu, Madrid', 3, 4),
    ('2023-10-08', 'Estadio Wanda Metropolitano, Madrid', 5, 6),
    ('2023-10-15', 'Estadio Mestalla, Valencia', 7, 3),
    ('2023-10-22', 'Camp Nou, Barcelona', 4, 7),
    ('2023-10-29', 'Estadio Ramon Sanchez Pizjuan, Sevilla', 6, 5);

INSERT INTO league_data.results (match_id, team_a_goals, team_b_goals)
VALUES 
    (1, 2, 3),
    (2, 1, 1),
    (3, 0, 1),
    (4, 4, 2),
    (5, 2, 2);


ALTER TABLE league_data.teams ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;
ALTER TABLE league_data.players ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;
ALTER TABLE league_data.matches ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;
ALTER TABLE league_data.results ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;