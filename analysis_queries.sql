-- 1. Roster with team and position context.
SELECT
    p.player_id,
    p.player_name,
    t.team_name,
    pos.position_code,
    p.jersey_number
FROM players p
JOIN teams t
    ON t.team_id = p.team_id
JOIN positions pos
    ON pos.position_id = p.position_id
ORDER BY t.team_name, p.player_name;

-- 2. Game-level player line with home and away team names.
SELECT
    g.game_id,
    g.played_on,
    home.team_name AS home_team,
    away.team_name AS away_team,
    p.player_name,
    ps.points,
    ps.rebounds,
    ps.assists,
    ps.turnovers
FROM player_stats ps
JOIN players p
    ON p.player_id = ps.player_id
JOIN games g
    ON g.game_id = ps.game_id
JOIN teams home
    ON home.team_id = g.home_team_id
JOIN teams away
    ON away.team_id = g.away_team_id
ORDER BY g.played_on, ps.points DESC;

-- 3. Reusable player/team summary.
CREATE OR REPLACE VIEW player_team_summary AS
SELECT
    p.player_id,
    p.player_name,
    t.team_id,
    t.team_name,
    pos.position_code,
    COUNT(DISTINCT ps.game_id) AS games_logged,
    SUM(ps.points) AS total_points,
    SUM(ps.rebounds) AS total_rebounds,
    SUM(ps.assists) AS total_assists,
    SUM(ps.turnovers) AS total_turnovers,
    ROUND(AVG(ps.minutes_played), 1) AS avg_minutes
FROM players p
JOIN teams t
    ON t.team_id = p.team_id
JOIN positions pos
    ON pos.position_id = p.position_id
LEFT JOIN player_stats ps
    ON ps.player_id = p.player_id
GROUP BY
    p.player_id,
    p.player_name,
    t.team_id,
    t.team_name,
    pos.position_code;

-- 4. Rank players within each team by total points in the loaded sample.
SELECT
    team_name,
    player_name,
    total_points,
    ROW_NUMBER() OVER (
        PARTITION BY team_id
        ORDER BY total_points DESC NULLS LAST, player_name, player_id
    ) AS team_scoring_rank
FROM player_team_summary
ORDER BY team_name, team_scoring_rank;

-- 5. Team totals from player lines, including turnover context.
SELECT
    t.team_name,
    COUNT(DISTINCT ps.game_id) AS games_with_player_lines,
    SUM(ps.points) AS player_line_points,
    SUM(ps.assists) AS assists,
    SUM(ps.turnovers) AS turnovers
FROM teams t
JOIN players p
    ON p.team_id = t.team_id
JOIN player_stats ps
    ON ps.player_id = p.player_id
GROUP BY t.team_name
ORDER BY player_line_points DESC;

