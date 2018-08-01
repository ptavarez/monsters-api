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
  
    ```
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

## Configure the Postgress Pool
1. Create a new folder in the main directory called `db`
2. In the `db` folder, create a `index.js` file with the following code:

  ```javascript
  const { Pool } = require('pg');
  
  const pool = new Pool({
    user: 'node_user',
    host: 'localhost',
    database: 'monstersdb',
    password: '<Your Password>',
    port: 5432
  });
  
  pool.query('SELECT * FROM monsters', (err, res) => {
    if (err) return console.log(err);
    
    console.log(res);
  });
  ```
  - To test this file, run `node db` in your terminal
3. To protect some of this data, lets create a new folder called `secrets`
4. Within the `secrets` folder, create a file called `db_configuration.js` and add the following code:
  ```javascript
  module.exports = {
     host: 'localhost',
     database: 'monstersdb',
     password: '<Your Password>',
     port: 5432
  };
  ```
5. Go back into the `db/index.js` file and modidy the code like so:

  ```javascript
  const { Pool } = require('pg');
  const { user, host, database, password, port } = require('../secrets/db_configuration')

  const pool = new Pool({user, host, database, password, port});

  pool.query('SELECT * FROM monsters', (err, res) => {
    if (err) return console.log(err);
    
    console.log(res);
  });
  ```
6. If you're using [git](https://git-scm.com/) as your version control system, create a `.gitignore` file in the main directory and add the following code:

  ```
  secrets/
  package-lock.json
  ```
7. Run `node db` in your terminal to confirm everything still works

## Monsters GET Request with Express
1. In the route of the application, create a `app.js` file and add the following code:
  
  ```javascript
  const express = require('express');
  
  const app = express();
  
  app.get('/monsters', (request, response) => {
    
  });
  ```
2. Go into the `db/index.js` file to export the pool instance and cut the query code out:

  ```javascript
  const { Pool } = require('pg');
  const { user, host, database, password, port } = require('../secrets/db_configuration');

  const pool = new Pool({user, host, database, password, port});

  module.exports = pool;
  ```
3. Return to the `app.js` file to require the pool instance and paste the query code like so:

  ```javascript
  const express = require('express');
  const pool = require('./db');
  
  const app = express();
  
  app.get('/monsters', (request, response) => {
    pool.query('SELECT * FROM monsters', (err, res) => {
      if (err) return console.log(err);
      
      console.log(res);
    });
  });
  ```
4. To run the server, lets add some code to the `app.js` file:

  ```javascript
  const express = require('express');
  const pool = require('./db');
  
  const app = express();
  
  app.get('/monsters', (request, response) => {
    pool.query('SELECT * FROM monsters', (err, res) => {
      if (err) return console.log(err);
      
      console.log(res.rows);
    });
  });
  
  const port = 3000;
  
  app.listen(port, () =>  console.log(`listening on port ${port}`));
  ```
5. Confirm these modifications work:
    1. In your terminal, run `node app`
    2. In your browser, head over to `http://localhost:3000/monsters`
    3. Return to your terminal and you should see the monsters table!
6. In the `bin` folder, create a new file called `www` with the following code:

    ```
    #!/user/bin/env node
    
    const app = require('../app');
    
    const port = 3000;
    
    app.listen(port, () =>  console.log(`listening on port ${port}`));
    
    ```
    
7. Within `app.js`, make the following modifications:

  ```javascript
  const express = require('express');
  const pool = require('./db');

  const app = express();

  app.get('/monsters', (request, response) => {
    pool.query('SELECT * FROM monsters', (err, res) => {
      if (err) return console.log(err);
      
      console.log(res.rows);
    });
  });

  module.exports = app;
  ```
8. Within the `package.json` file, lets add new commands within the scripts object:

  ```javascript
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "configure": "./bin/configuredb.sh",
    "start": "node ./bin/www",
    "dev": "nodemon ./bin/www"
  },
  ```
9. Confirm these modifications work:
    1. In your terminal, run `npm run dev`
    2. In your browser, head over to `http://localhost:3000/monsters`
    3. Return to your terminal and you should see the monsters table!
10. Return to the `app.js` file and make the following changes:
  ```javascript
  const express = require('express');
  const pool = require('./db');

  const app = express();

  app.get('/monsters', (request, response) => {
    pool.query('SELECT * FROM monsters ORDER BY id ASC', (err, res) => {
      if (err) return console.log(err);
      
      response.json(res.rows);
    });
  });

  module.exports = app;
  ```
  
  ## Error Handling with Middleware
  1. To add error handling to the get request, modify the `app.js` file like so:
    ```javascript
    const express = require('express');
    const pool = require('./db');

    const app = express();

    app.get('/monsters', (request, response, next) => {
      pool.query('SELECT * FROM monsters ORDER BY id ASC', (err, res) => {
        if (err) return next(err);
        
        response.json(res.rows);
      });
    });
    
    app.use((err, req, res, next) => {
      res.json(err);
    });
    
    module.exports = app;
    ```
  
