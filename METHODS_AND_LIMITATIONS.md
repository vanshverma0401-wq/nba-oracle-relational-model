# Methods and limitations

## Source and reconstruction

- **Original source:** [final DDL](coursework/final_schema.sql) generated in
  December 2024 for Oracle 21c, recovered from the author's project folder in
  November 2026. It contains seven business tables and one audit-log table.
- **Public demonstration:** the root SQL files are a five-table reconstruction
  of the same general modeling and SQL concepts, using fictional records and
  different grains. They are not the original final implementation.
- **Runtime evidence:** no fresh execution of either version was performed for
  publication. Static inspection does not prove Oracle compilation, privileges,
  query correctness on every input, execution plans or performance.

## Demonstration modeling choices

- Positions, teams, players and games are separate entities.
- `player_stats` is unique per game and player.
- Home and away team relationships are distinct foreign keys to teams.
- Checks reject several invalid values; indexes expose common access paths.
- The summary view aggregates recorded player lines; ranking uses player ID as
  its final tie-breaker for reproducibility.

## Demonstration limits

- Sample rows are small, fictional and incomplete. Team scores are not required
  to equal the sum of these partial player lines.
- Current player-team membership is used for attribution. A transfer would
  reattribute past statistics; historical roster membership is not modeled.
- Independent foreign keys do not enforce that a player's current team was
  either participant in the referenced game. The supplied fixtures satisfy that
  rule, but the database schema does not enforce it.
- Statistics cover a limited box-score subset; there is no play-by-play,
  period-level, injury, officiating or postseason model.
- The Oracle dialect has not been ported or benchmarked on other systems.
- No performance, scale, real NBA findings or production deployment is claimed.

## Original source limits

The historical final DDL is retained for provenance, including its original
issues. In particular, the contract view matches players by team and position
rather than a stable player-contract key, so it can attach the same salary to
multiple players. Games lack a primary key; seasonal statistics lack an explicit
season key. See [coursework notes](coursework/README.md).

The trigger `track_win_loss_updates` and its sequence are present as executable
source. Their successful compilation and behavior have not been verified here.
The demonstration does not implement a trigger.

## Next verification step

Run the three demonstration files in a disposable Oracle schema. Record the
Oracle version, constraint checks, fixture row counts and view outputs, then add
that evidence with any necessary corrections. Until then, execution in Oracle
remains `Needs Evidence`.
