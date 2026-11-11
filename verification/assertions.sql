-- Expected demonstration results and negative constraint cases.
-- Original eight-table coursework and its trigger are NOT executed by this file.
DECLARE
    PROCEDURE assert_num(p_label VARCHAR2, p_sql VARCHAR2, p_expected NUMBER) IS
        v_actual NUMBER;
    BEGIN
        EXECUTE IMMEDIATE p_sql INTO v_actual;
        IF v_actual IS NULL OR v_actual <> p_expected THEN
            RAISE_APPLICATION_ERROR(-20001, p_label || ': expected ' || p_expected || ', got ' || NVL(TO_CHAR(v_actual), 'NULL'));
        END IF;
        DBMS_OUTPUT.PUT_LINE('PASS ' || p_label || ' = ' || v_actual);
    END;

    PROCEDURE expect_constraint(p_label VARCHAR2, p_sql VARCHAR2, p_code NUMBER, p_detail VARCHAR2) IS
        v_code NUMBER := 0;
        v_message VARCHAR2(4000);
    BEGIN
        SAVEPOINT negative_case;
        BEGIN
            EXECUTE IMMEDIATE p_sql;
        EXCEPTION
            WHEN OTHERS THEN
                v_code := SQLCODE;
                v_message := SQLERRM;
        END;
        ROLLBACK TO negative_case;
        IF v_code <> p_code OR INSTR(UPPER(NVL(v_message, '')), UPPER(p_detail)) = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, p_label || ': expected error ' || p_code || ' containing ' || p_detail || '; got ' || v_code || ' ' || v_message);
        END IF;
        DBMS_OUTPUT.PUT_LINE('PASS rejection ' || p_label || ': ' || v_message);
    END;
BEGIN
    assert_num('positions', 'SELECT COUNT(*) FROM positions', 5);
    assert_num('teams', 'SELECT COUNT(*) FROM teams', 4);
    assert_num('players', 'SELECT COUNT(*) FROM players', 8);
    assert_num('games', 'SELECT COUNT(*) FROM games', 4);
    assert_num('player_stats', 'SELECT COUNT(*) FROM player_stats', 8);
    assert_num('summary_rows', 'SELECT COUNT(*) FROM player_team_summary', 8);
    assert_num('partial_player_line_points', 'SELECT SUM(total_points) FROM player_team_summary', 189);
    assert_num('comets_points', 'SELECT SUM(total_points) FROM player_team_summary WHERE team_id = 101', 51);
    assert_num('orbit_points', 'SELECT SUM(total_points) FROM player_team_summary WHERE team_id = 102', 41);
    assert_num('forge_points', 'SELECT SUM(total_points) FROM player_team_summary WHERE team_id = 103', 46);
    assert_num('pulse_points', 'SELECT SUM(total_points) FROM player_team_summary WHERE team_id = 104', 51);

    expect_constraint('duplicate_position_pk',
        'INSERT INTO positions (position_id, position_code, position_name) VALUES (1, ''XX'', ''Test only'')',
        -1, 'POSITIONS_PK');
    expect_constraint('duplicate_roster_jersey',
        'INSERT INTO players (player_id, player_name, jersey_number, position_id, team_id) VALUES (1099, ''Test only'', 4, 1, 101)',
        -1, 'PLAYERS_ROSTER_UQ');
    expect_constraint('unknown_team',
        'INSERT INTO players (player_id, player_name, jersey_number, position_id, team_id) VALUES (1099, ''Test only'', 99, 1, 999)',
        -2291, 'PLAYERS_TEAM_FK');
    expect_constraint('missing_player_name',
        'INSERT INTO players (player_id, player_name, jersey_number, position_id, team_id) VALUES (1099, NULL, 99, 1, 101)',
        -1400, 'PLAYER_NAME');
    expect_constraint('same_home_away_team',
        'INSERT INTO games (game_id, played_on, season_label, home_team_id, away_team_id) VALUES (6000, DATE ''2026-01-20'', ''2025-26'', 101, 101)',
        -2290, 'GAMES_DISTINCT_TEAMS_CK');
    expect_constraint('negative_points',
        'INSERT INTO player_stats (stat_id, game_id, player_id, points) VALUES (9900, 5003, 1001, -1)',
        -2290, 'PLAYER_STATS_POINTS_CK');
    expect_constraint('invalid_minutes',
        'INSERT INTO player_stats (stat_id, game_id, player_id, minutes_played) VALUES (9900, 5003, 1001, 61)',
        -2290, 'PLAYER_STATS_MINUTES_CK');
    assert_num('rows_unchanged_after_rejections', 'SELECT COUNT(*) FROM player_stats', 8);
    DBMS_OUTPUT.PUT_LINE('ALL DEMONSTRATION ASSERTIONS PASSED');
END;
/
