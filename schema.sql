-- NBA Analytics Relational Model
-- Targets Oracle 21c; this exact reconstruction is not runtime-verified.

CREATE TABLE positions (
    position_id   NUMBER(1)     CONSTRAINT positions_pk PRIMARY KEY,
    position_code VARCHAR2(2)   CONSTRAINT positions_code_nn NOT NULL,
    position_name VARCHAR2(30)  CONSTRAINT positions_name_nn NOT NULL,
    CONSTRAINT positions_code_uq UNIQUE (position_code),
    CONSTRAINT positions_id_ck CHECK (position_id BETWEEN 1 AND 5)
);

CREATE TABLE teams (
    team_id   NUMBER(4)     CONSTRAINT teams_pk PRIMARY KEY,
    team_name VARCHAR2(60)  CONSTRAINT teams_name_nn NOT NULL,
    home_city VARCHAR2(60)  CONSTRAINT teams_city_nn NOT NULL,
    coach     VARCHAR2(80),
    CONSTRAINT teams_name_uq UNIQUE (team_name)
);

CREATE TABLE players (
    player_id     NUMBER(6)      CONSTRAINT players_pk PRIMARY KEY,
    player_name   VARCHAR2(80)   CONSTRAINT players_name_nn NOT NULL,
    birth_date    DATE,
    height_cm     NUMBER(5, 2),
    weight_kg     NUMBER(5, 2),
    jersey_number NUMBER(2),
    position_id   NUMBER(1)      CONSTRAINT players_position_nn NOT NULL,
    team_id       NUMBER(4)      CONSTRAINT players_team_nn NOT NULL,
    CONSTRAINT players_jersey_ck CHECK (jersey_number BETWEEN 0 AND 99),
    CONSTRAINT players_height_ck CHECK (height_cm IS NULL OR height_cm > 0),
    CONSTRAINT players_weight_ck CHECK (weight_kg IS NULL OR weight_kg > 0),
    CONSTRAINT players_roster_uq UNIQUE (team_id, jersey_number),
    CONSTRAINT players_position_fk FOREIGN KEY (position_id)
        REFERENCES positions (position_id),
    CONSTRAINT players_team_fk FOREIGN KEY (team_id)
        REFERENCES teams (team_id)
);

CREATE TABLE games (
    game_id      NUMBER(8)     CONSTRAINT games_pk PRIMARY KEY,
    played_on    DATE          CONSTRAINT games_date_nn NOT NULL,
    season_label VARCHAR2(9)   CONSTRAINT games_season_nn NOT NULL,
    venue        VARCHAR2(100),
    home_team_id NUMBER(4)     CONSTRAINT games_home_nn NOT NULL,
    away_team_id NUMBER(4)     CONSTRAINT games_away_nn NOT NULL,
    home_score   NUMBER(3),
    away_score   NUMBER(3),
    CONSTRAINT games_distinct_teams_ck CHECK (home_team_id <> away_team_id),
    CONSTRAINT games_home_score_ck CHECK (home_score IS NULL OR home_score >= 0),
    CONSTRAINT games_away_score_ck CHECK (away_score IS NULL OR away_score >= 0),
    CONSTRAINT games_home_team_fk FOREIGN KEY (home_team_id)
        REFERENCES teams (team_id),
    CONSTRAINT games_away_team_fk FOREIGN KEY (away_team_id)
        REFERENCES teams (team_id)
);

CREATE TABLE player_stats (
    stat_id        NUMBER(10)    CONSTRAINT player_stats_pk PRIMARY KEY,
    game_id        NUMBER(8)     CONSTRAINT player_stats_game_nn NOT NULL,
    player_id      NUMBER(6)     CONSTRAINT player_stats_player_nn NOT NULL,
    minutes_played NUMBER(4, 1)  DEFAULT 0 CONSTRAINT player_stats_minutes_nn NOT NULL,
    points         NUMBER(3)     DEFAULT 0 CONSTRAINT player_stats_points_nn NOT NULL,
    rebounds       NUMBER(3)     DEFAULT 0 CONSTRAINT player_stats_rebounds_nn NOT NULL,
    assists        NUMBER(3)     DEFAULT 0 CONSTRAINT player_stats_assists_nn NOT NULL,
    turnovers      NUMBER(3)     DEFAULT 0 CONSTRAINT player_stats_turnovers_nn NOT NULL,
    CONSTRAINT player_stats_game_player_uq UNIQUE (game_id, player_id),
    CONSTRAINT player_stats_minutes_ck CHECK (minutes_played BETWEEN 0 AND 60),
    CONSTRAINT player_stats_points_ck CHECK (points >= 0),
    CONSTRAINT player_stats_rebounds_ck CHECK (rebounds >= 0),
    CONSTRAINT player_stats_assists_ck CHECK (assists >= 0),
    CONSTRAINT player_stats_turnovers_ck CHECK (turnovers >= 0),
    CONSTRAINT player_stats_game_fk FOREIGN KEY (game_id)
        REFERENCES games (game_id),
    CONSTRAINT player_stats_player_fk FOREIGN KEY (player_id)
        REFERENCES players (player_id)
);

CREATE INDEX players_team_idx ON players (team_id);
CREATE INDEX players_position_idx ON players (position_id);
CREATE INDEX games_home_team_idx ON games (home_team_id);
CREATE INDEX games_away_team_idx ON games (away_team_id);
CREATE INDEX games_played_on_idx ON games (played_on);
CREATE INDEX player_stats_game_idx ON player_stats (game_id);
CREATE INDEX player_stats_player_idx ON player_stats (player_id);

