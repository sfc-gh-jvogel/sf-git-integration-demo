-- Use role that has permissions to create API Integration
USE ROLE ACCOUNTADMIN;

-- Create and use the warehouse that your session
CREATE WAREHOUSE IF NOT EXISTS KAMESH_DEMOS_S;
USE WAREHOUSE KAMESH_DEMOS_S;

-- Database to hold all the objects
CREATE OR REPLACE DATABASE KAMESH_GIT_REPOS;
-- Use the created database
USE DATABASE KAMESH_GIT_REPOS;

-- Create schema to hold all github repositories
CREATE OR REPLACE SCHEMA GITHUB;
USE SCHEMA GITHUB;

-- Create the API Integration
CREATE API INTEGRATION IF NOT EXISTS  kameshsampath_git
    API_PROVIDER = git_https_api
    -- allowed orgs and repositories
    API_ALLOWED_PREFIXES = ('https://github.com/kameshsampath')
    ENABLED = TRUE;

-- CREATE OR REPLACE SECRET my_gh_token
--   TYPE = password
--   USERNAME = 'kameshsampath'
--   PASSWORD = 'ghp_token';

-- Create Repository - this will be a stage in Snowflake
CREATE GIT REPOSITORY IF NOT EXISTS git_integration_demo
    API_INTEGRATION = kameshsampath_git
    -- ADD secret to use private repositories
    -- GIT_CREDENTIALS = my_gh_token
    ORIGIN = 'https://github.com/kameshsampath/sf-git-integration-demo.git';

-- Refresh repoistory
ALTER GIT REPOSITORY git_integration_demo FETCH;

-- List branches or tags or commit hash
LIST @git_integration_demo/branches/main;

-- Run the sql `demo.sql` from main branch root
EXECUTE IMMEDIATE FROM @git_integration_demo/branches/main/demo.sql;


-- Run the sql `cleaup.sql` from main branch root to clean demo objects
-- EXECUTE IMMEDIATE FROM @git_integration_demo/branches/main/demo.sql;