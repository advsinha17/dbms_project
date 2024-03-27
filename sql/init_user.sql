-- Create User
CREATE USER 'project_dba'@'localhost' IDENTIFIED BY '07_project';

-- Grant Privileges
GRANT ALL PRIVILEGES ON *.* TO 'project_dba'@'localhost';

-- Flush Privileges
FLUSH PRIVILEGES;

-- Create Database
CREATE DATABASE IF NOT EXISTS proj_database1;
