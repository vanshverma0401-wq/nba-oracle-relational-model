# Original final-project DDL

`final_schema.sql` is the unchanged generated DDL recovered from the author's
2024 final-project folder on November 8, 2026. Its header identifies Oracle SQL
Developer Data Modeler and a December 2, 2024 Oracle 21c export. It is historical
source evidence, not a newly executed or production-ready migration.

## Contents

- Seven business tables: `contracts`, `games`, `player`, `player_stats`,
  `positions`, `team`, `team_stats`.
- One audit table: `team_stats_log`.
- Ten foreign keys and two explicit check constraints.
- Three views: `player_season_averages`, `team_season_summary`,
  `player_contract_summary`.
- Three explicit indexes, one sequence and `track_win_loss_updates`.

## Known original design issues

1. `player_contract_summary` joins contracts to players using team and position.
   Multiple teammates can share a position, so a salary can be assigned to the
   wrong player. A production design needs a player key and dated contracts.
2. `games` has no primary key. Player/team statistics have no explicit season
   identifier or enforceable season/entity uniqueness.
3. `player.position_id` is not a foreign key, and player/team/position fields
   repeated in statistics are not guaranteed to agree with their parent rows.
4. Views do not aggregate or isolate stat categories despite their season names;
   basketball winner consistency and missing-value rules are partly unconstrained.
5. Audit rows do not retain the source statistic ID or category.

No source data, administrative project records or original scratch commands are
included. The scratch file contained destructive/trial statements and malformed
SQL, so it is not offered as a runnable workflow. No SQL was executed during
recovery or publication.

Do not run this DDL in the same schema as the root demonstration; several object
names overlap and represent different designs. Use a separate disposable schema
if independently validating this historical version.
