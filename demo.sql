USE ROLE ACCOUNTADMIN;

use warehouse git_demo_wh;

USE DATABASE git_demo_db;

CREATE SCHEMA IF NOT EXISTS DATA;

USE SCHEMA DATA;

CREATE FILE FORMAT IF NOT EXISTS  csv_ff
    SKIP_HEADER=1;

CREATE OR REPLACE TABLE TODOS (
    TITLE STRING,
    DESCRIPTION STRING,
    CATEGORY STRING,
    STATUS BOOLEAN
);

-- List files
LS @git_integration_demo/branches/main/;

-- Create  the stage to copy all files from git stage to current data stage
CREATE STAGE IF NOT EXISTS git_data
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Copy fies from git into local stage
COPY FILES
  INTO @git_data
  FROM git_integration_demo/branches/main/todos.csv;

-- Load the CSV into the table
COPY INTO TODOS FROM @git_data/todos.csv 
  FILE_FORMAT = csv_ff;

-- check the data
SELECT * FROM TODOS;
