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
