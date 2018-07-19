# Monsters API
A guide on how to create an API using node.js and postgresql

## Prerequisites
1. Basic understanding of JavaScript, Node.js, and SQL
2. Have the following installed on your computer
  1. A Command Line Application
  2. [Node](https://nodejs.org/en/) Version 8 or higher
  2. [Postman](https://www.getpostman.com/apps)
  3. [Postgresql](https://gist.github.com/15Dkatz/321e83c4bdd7b78c36884ce92db26d38)
  4. Any Code Editor

## Setting Up
1. Create a directory to hold all files for the monsters API. Call it whatever you'd like
2. In your terminal, change into that directory and run `npm init -y`
  1. This initializes a node project and skips the node questionnaire
3. Install the dependencies with the following commands:
  1. `npm i nodemon --save-dev`
  2. `npm i express body-parser pg --save` (*Note that these are three different dependencies being installed simultaneously*)
4. Run the command `touch monsters.sql` to set up the starter sql for the project.
5. In the **monsters.sql** file, add the following code:
  ```sql
  CREATE TABLE monsters(
    id serial,
    name character varying(50),
    personality character varying(50)
  );
  
  CREATE TABLE habitats(
    id serial,
    name character varying(50),
    climate character varying(50),
    temperatue int
  );
  
  CREATE TABLE lives(
    id serial,
    monster character varying(50),
    habitat character varying(50)
  );
  
  INSERT INTO monsters(name, personality)
  VALUES
  ('Dracula', 'Thirsty'),
  ('Big Foot', 'Lazy'),
  ('Zombie', 'Dumb');
  
  INSERT INTO habitats(name, climate, temperatue)
  VALUES
  ('Cofin', 'Cold', '32',),
  ('Forrest', 'Haunted', '70',),
  ('Basement', 'Cool', '50',);
  
  INSERT INTO lives(monster, habitat)
  VALUES
  ('Dracula', 'Cofin'),
  ('Big Foot', 'Forrest'),
  ('Zombie', 'Basement');
  ```
