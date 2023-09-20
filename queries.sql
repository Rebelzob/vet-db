/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM animals 
WHERE NAME LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT NAME FROM animals 
WHERE DATE_OF_BIRTH >= '2016-01-01' 
AND DATE_OF_BIRTH <= '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT NAME FROM animals
WHERE NEUTERED = TRUE
AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts
FROM animals
WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals
WHERE neutered = TRUE;

-- Find all animals not named Gabumon.
SELECT * FROM animals
WHERE name != 'Gabumon';

/*Find all animals with a weight between 10.4kg and 17.3kg 
(including the animals with the weights that equals precisely 10.4kg or 17.3kg) */
SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Inside a transaction update the animals table by setting the species column to unspecified. 
Verify that change was made. Then roll back the change and verify that the species columns went back 
to the state before the transaction. */
BEGIN TRANSACTION;
UPDATE animals 
SET species = 'Unspecified';

SELECT species FROM animals;

ROLLBACK;

SELECT species FROM animals;

COMMIT;

/* Inside a transaction to update the animals species column to 'digimon' for all animals whose name ends in 'mon'. 
Then update the species column to 'pokemon' for all animals whose species is NULL.*/
BEGIN TRANSACTION;

UPDATE animals
SET species =  'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

SELECT * FROM animals;

COMMIT;

/* Inside a transaction delete all animals born after 2022-01-01. 
Then save a savepoint. Then update the weight of all animals to be negative. 
Then rollback to the savepoint. Then update the weight of all animals to be negative. 
Then select all animals. */
BEGIN TRANSACTION;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT sp1;

UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO sp1;

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

SELECT * FROM animals

COMMIT;

-- How many animals are there in the database?
SELECT COUNT(*) FROM animals;

-- How many animals never tried to escape?
SELECT COUNT(*) FROM animals
WHERE escape_attempts = 0;

-- What is the average weight of all animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, AVG(escape_attempts) FROM animals
GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;
