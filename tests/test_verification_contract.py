"""Static checks of an unexecuted Oracle verification package, not Oracle tests."""
from __future__ import annotations

import ast
import hashlib
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class VerificationContractTests(unittest.TestCase):
    def test_expected_outputs_match_independent_fixture_arithmetic(self):
        expected_path = ROOT / "verification" / "expected_results.json"
        self.assertTrue(expected_path.exists(), "Expected-result contract is missing")
        expected = json.loads(expected_path.read_text())
        sample = (ROOT / "sample_data.sql").read_text()
        stats = [ast.literal_eval("(" + match + ")") for match in re.findall(
            r"INSERT INTO player_stats\s*\([^;]+?\)\s*VALUES\s*\(([^;]+)\);", sample, re.I)]
        self.assertEqual(len(stats), expected["row_counts"]["player_stats"])
        self.assertEqual(sum(row[4] for row in stats), expected["total_player_line_points"])
        self.assertEqual({str(row[2]): row[4] for row in stats}, expected["player_points"])

    def test_runner_stops_on_error_and_loads_assertions(self):
        path = ROOT / "verify.sql"
        self.assertTrue(path.exists(), "Oracle verification runner is missing")
        sql = path.read_text().lower()
        for fragment in ["whenever sqlerror exit", "whenever oserror exit", "@schema.sql", "@sample_data.sql", "@analysis_queries.sql", "@verification/assertions.sql"]:
            self.assertIn(fragment, sql)
        self.assertNotIn("drop table", sql)

    def test_negative_checks_are_rollback_safe_and_check_exact_errors(self):
        path = ROOT / "verification" / "assertions.sql"
        self.assertTrue(path.exists(), "Constraint assertions are missing")
        sql = path.read_text().lower()
        for fragment in ["savepoint negative_case", "rollback to negative_case", "sqlcode", "sqlerrm", "-2291", "-2290", "-1400", "players_roster_uq", "games_distinct_teams_ck"]:
            self.assertIn(fragment, sql)
        self.assertNotIn("when others then null", sql)

    def test_original_ddl_remains_byte_exact(self):
        digest = hashlib.sha256((ROOT / "coursework" / "final_schema.sql").read_bytes()).hexdigest()
        self.assertEqual(digest, "93622eb80dec4627632181a6e17af23f951c9d6a0ec0cda2265e7abed74b275c")


if __name__ == "__main__":
    unittest.main()
