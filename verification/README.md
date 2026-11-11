# Oracle execution checklist

**Status: execution in Oracle remains `Needs Evidence`.** The November 2026
extension adds a reproducible runner and hand-calculated assertions. It does
not establish that an Oracle engine compiled or executed them successfully.

## Run in an empty disposable schema

Use an existing authorized Oracle environment and a connected SQL*Plus or SQLcl
session with permission to create tables, indexes and views. Keep credentials
out of source files, command history and public logs. From the repository root:

```sql
@verify.sql
```

The runner loads [schema](../schema.sql), [fictional data](../sample_data.sql)
and [queries/view](../analysis_queries.sql), then checks
[counts, totals and constraint failures](assertions.sql). It stops on unexpected
SQL/OS errors and writes an ignored `oracle_run.log`. It does not drop existing
objects; an occupied schema should fail rather than be reset automatically.

Expected values are [explicitly labeled hand calculations](expected_results.json).
Negative cases require the expected Oracle error code **and** constraint/column
name, then roll back their own changes. A successful real run must end with
`ALL DEMONSTRATION ASSERTIONS PASSED` and a successful client exit code.

Before adding runtime evidence, review the log for credentials, connection
identifiers and environment details. Retain only sanitized version, assertion
outcomes, counts and outputs. Record the actual date and engine/client versions.
The Python tests check package structure and independent fixture arithmetic;
they do not run Oracle.

## Scope

This verifies only the five-table demonstration. The byte-preserved
[historical final DDL](../coursework/final_schema.sql) has a different eight-table
design and an audit trigger. Its compilation, trigger behavior and documented
design issues require a separate disposable-schema run. Do not infer their
success from demonstration results.
