-- Run from this repository's root in a connected EMPTY disposable Oracle schema.
-- This runner is supplied for future execution; it has not been run in Oracle.
WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 100
SPOOL verification/oracle_run.log
SELECT banner_full FROM v$version;
@schema.sql
@sample_data.sql
@analysis_queries.sql
@verification/assertions.sql
SPOOL OFF
EXIT SUCCESS
