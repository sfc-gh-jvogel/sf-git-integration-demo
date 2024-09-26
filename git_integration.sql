USE ROLE ACCOUNTADMIN;

USE WAREHOUSE KAMESH_DEMOS_S;

CREATE OR REPLACE DATABASE KAMESH_GIT_REPOS;

-- Create the API Integration
CREATE API INTEGRATION IF NOT EXISTS  kameshsampath_git
    API_PROVIDER = git_https_api
    -- allowed orgs and repositories
    API_ALLOWED_PREFIXES = ('https://github.com/kameshsampath')
    -- ADD secret to use private repositories
    ENABLED = TRUE;

-- Create Repository - this will be a stage in Snowflake
CREATE GIT REPOSITORY IF NOT EXISTS git_integration_demo
    API_INTEGRATION = kameshsampath_git
    ORIGIN = 'https://github.com/kameshsampath/git-integration-demo.git';

-- Refresh repoistory
ALTER GIT REPOSITORY git_integration_demo FETCH;

-- List branches or tags or commit hash
LIST @git_integration_demo/branches/main;

-- Run the sql `demo.sql` from main branch root
EXECUTE IMMEDIATE FROM @git_integration_demo/branches/main/demo.sql;

