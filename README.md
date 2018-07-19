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
*Please note that the following terminal commands are for the default **Mac** command line*
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
  ('Cofin', 'Cold', '32'),
  ('Forrest', 'Haunted', '70'),
  ('Basement', 'Cool', '50');
  
  INSERT INTO lives(monster, habitat)
  VALUES
  ('Dracula', 'Cofin'),
  ('Big Foot', 'Forrest'),
  ('Zombie', 'Basement');
  ```
  
  ## Node SQL Configuration
  1. In your terminal, run `createdb -U node_user monstersdb`
  2. Launch the interactive postgres shell by using the followig command `psql -U node_user monstersdb`
  3. Enter `CREATE USER node_user WITH SUPERUSER PASSWORD '<Password>';`
    1. This creates a new role in the database
    2. To confirm it exists, run `SELECT * FROM pg_user;`
  4. Exit the database with the command `\q`
  5. Create a directory called bin with the following command `mkdir bin/configuredb.sh`
  6. Create a new configuration file within the bin folder by running `touch bin/configuredb.sh`
  7. Add the following code to the configuredb.sh file:
  
    ```sh
    #!/bin/bash
    
    database="monstersdb"
    echo "Configurating database: $database"
    
    dropdb -U node_user monstersdb
    createdb -U node_user monstersdb
    
    psql -U node_user monstersdb < ./bin/sql/monsters.sql
    
    echo "$database configured"
    
    ```
 8. Let's organize our files so the above configure file actually works
     1. Within the bin folder, create a new folder called sql with the following command `mkdir bin/sql`
     2. Move the monsters.sql file within the bin/sql folder by running `mv monsters.sql bin/sql`
 9. To run this file, we will add a `configure` script within the script object in the package.json file:
   ```json
   "scripts": {
     "test": "echo \"Error: no test specified\" && exit 1",
     "configure": "./bin/configuredb.sh"
   }
   ```
  10. Now we need to configure the permissions for the bin folder
    1. In your terminal, change into the bin folder by running `cd bin`
    2. Run the command `ls -l`
        - Currently, there are only read and write permissions
    3. To make this file an executable file, run the following `chmod +x configuredb.sh`
        - Run the command `ls -l` again to confirm your file can execute as well
  11. Run the script with the following command: `npm run configure`
    1. By now, you data should have been inserted into the database. To confirm, go into the psql shell by running `psql -U node_user monstersdb`
    2. In the shell, run `\d`
          - You should see the newly created tables!
