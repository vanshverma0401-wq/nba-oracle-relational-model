-- All rows below are original fictional demonstration data.
-- They do not reproduce an NBA roster, team, venue, schedule, or source dataset.

INSERT INTO positions (position_id, position_code, position_name)
VALUES (1, 'PG', 'Point Guard');
INSERT INTO positions (position_id, position_code, position_name)
VALUES (2, 'SG', 'Shooting Guard');
INSERT INTO positions (position_id, position_code, position_name)
VALUES (3, 'SF', 'Small Forward');
INSERT INTO positions (position_id, position_code, position_name)
VALUES (4, 'PF', 'Power Forward');
INSERT INTO positions (position_id, position_code, position_name)
VALUES (5, 'C', 'Center');

INSERT INTO teams (team_id, team_name, home_city, coach)
VALUES (101, 'North City Comets', 'North City', 'Mira Cole');
INSERT INTO teams (team_id, team_name, home_city, coach)
VALUES (102, 'Lakeview Orbit', 'Lakeview', 'Dev Patel');
INSERT INTO teams (team_id, team_name, home_city, coach)
VALUES (103, 'Harbor Forge', 'Harbor Point', 'Elena Ward');
INSERT INTO teams (team_id, team_name, home_city, coach)
VALUES (104, 'Prairie Pulse', 'Prairie Junction', 'Marcus Bell');

INSERT INTO players (
    player_id, player_name, birth_date, height_cm, weight_kg,
    jersey_number, position_id, team_id
) VALUES (
    1001, 'Arin Shah', TO_DATE('1998-04-11', 'YYYY-MM-DD'), 190.5, 84.0,
    4, 1, 101
);
INSERT INTO players (
    player_id, player_name, birth_date, height_cm, weight_kg,
    jersey_number, position_id, team_id
) VALUES (
    1002, 'Jonah Brooks', TO_DATE('1997-09-22', 'YYYY-MM-DD'), 201.0, 96.5,
    18, 3, 101
);
INSERT INTO players (
    player_id, player_name, birth_date, height_cm, weight_kg,
    jersey_number, position_id, team_id
) VALUES (
    1003, 'Leo Martin', TO_DATE('1999-02-03', 'YYYY-MM-DD'), 194.0, 88.0,
    7, 2, 102
);
INSERT INTO players (
    player_id, player_name, birth_date, height_cm, weight_kg,
    jersey_number, position_id, team_id
) VALUES (
    1004, 'Owen Rivera', TO_DATE('1996-12-19', 'YYYY-MM-DD'), 211.0, 111.0,
    31, 5, 102
);
INSERT INTO players (
    player_id, player_name, birth_date, height_cm, weight_kg,
    jersey_number, position_id, team_id
) VALUES (
    1005, 'Nikhil Sen', TO_DATE('1998-07-08', 'YYYY-MM-DD'), 198.0, 92.0,
    12, 3, 103
);
INSERT INTO players (
    player_id, player_name, birth_date, height_cm, weight_kg,
    jersey_number, position_id, team_id
) VALUES (
    1006, 'Caleb Stone', TO_DATE('1995-05-14', 'YYYY-MM-DD'), 207.0, 105.0,
    24, 4, 103
);
INSERT INTO players (
    player_id, player_name, birth_date, height_cm, weight_kg,
    jersey_number, position_id, team_id
) VALUES (
    1007, 'Ravi Mehta', TO_DATE('2000-01-27', 'YYYY-MM-DD'), 188.0, 80.0,
    2, 1, 104
);
INSERT INTO players (
    player_id, player_name, birth_date, height_cm, weight_kg,
    jersey_number, position_id, team_id
) VALUES (
    1008, 'Miles Turnerfield', TO_DATE('1997-10-06', 'YYYY-MM-DD'), 204.0, 101.0,
    15, 4, 104
);

INSERT INTO games (
    game_id, played_on, season_label, venue,
    home_team_id, away_team_id, home_score, away_score
) VALUES (
    5001, TO_DATE('2026-01-08', 'YYYY-MM-DD'), '2025-26',
    'Comet Hall', 101, 102, 108, 102
);
INSERT INTO games (
    game_id, played_on, season_label, venue,
    home_team_id, away_team_id, home_score, away_score
) VALUES (
    5002, TO_DATE('2026-01-10', 'YYYY-MM-DD'), '2025-26',
    'Forge Center', 103, 104, 99, 105
);
INSERT INTO games (
    game_id, played_on, season_label, venue,
    home_team_id, away_team_id, home_score, away_score
) VALUES (
    5003, TO_DATE('2026-01-15', 'YYYY-MM-DD'), '2025-26',
    'Orbit Pavilion', 102, 103, 111, 106
);
INSERT INTO games (
    game_id, played_on, season_label, venue,
    home_team_id, away_team_id, home_score, away_score
) VALUES (
    5004, TO_DATE('2026-01-18', 'YYYY-MM-DD'), '2025-26',
    'Pulse Arena', 104, 101, 104, 109
);

INSERT INTO player_stats (
    stat_id, game_id, player_id, minutes_played, points, rebounds, assists, turnovers
) VALUES (9001, 5001, 1001, 34.5, 24, 4, 9, 2);
INSERT INTO player_stats (
    stat_id, game_id, player_id, minutes_played, points, rebounds, assists, turnovers
) VALUES (9002, 5001, 1002, 36.0, 27, 8, 4, 3);
INSERT INTO player_stats (
    stat_id, game_id, player_id, minutes_played, points, rebounds, assists, turnovers
) VALUES (9003, 5001, 1003, 35.0, 22, 5, 6, 2);
INSERT INTO player_stats (
    stat_id, game_id, player_id, minutes_played, points, rebounds, assists, turnovers
) VALUES (9004, 5001, 1004, 33.0, 19, 12, 2, 1);
INSERT INTO player_stats (
    stat_id, game_id, player_id, minutes_played, points, rebounds, assists, turnovers
) VALUES (9005, 5002, 1005, 34.0, 21, 7, 5, 2);
INSERT INTO player_stats (
    stat_id, game_id, player_id, minutes_played, points, rebounds, assists, turnovers
) VALUES (9006, 5002, 1006, 37.5, 25, 11, 3, 4);
INSERT INTO player_stats (
    stat_id, game_id, player_id, minutes_played, points, rebounds, assists, turnovers
) VALUES (9007, 5002, 1007, 36.5, 28, 3, 8, 2);
INSERT INTO player_stats (
    stat_id, game_id, player_id, minutes_played, points, rebounds, assists, turnovers
) VALUES (9008, 5002, 1008, 35.0, 23, 9, 4, 3);

COMMIT;

