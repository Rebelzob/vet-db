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

/* Inside a transaction delete all animals. 
Then rollback the transaction and verify that the animals are still there. */
BEGIN TRANSACTION;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

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

/* Write queries (using JOIN) to answer the following questions*/
-- What animals belong to Melody Pond?
SELECT animals.name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon)
SELECT animals.name FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that dont own any animals
SELECT owners.full_name, animals.name FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

-- How many animals are there per species?
SELECT species.name, COUNT(*) FROM animals
JOIN species ON animals.species_id = species.id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell
SELECT owners.full_name, animals.name FROM animals
JOIN owners ON animals.owner_id = owners.id
JOIN species ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell'
AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape
SELECT owners.full_name, animals.name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester'
AND animals.escape_attempts = 0;

-- Who owns the most animals?
SELECT owners.full_name, COUNT(*) FROM animals
JOIN owners ON animals.owner_id = owners.id
GROUP BY owners.full_name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT 
  visits.date_of_visit, 
	owners.full_name AS owner_name, 
	animals.name AS animal_name, 
	vets.name AS vet_name 
	FROM animals
JOIN owners ON animals.owner_id = owners.id
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.date_of_visit DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animals.id) FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including those that have no specialties
SELECT vets.name, species.name FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020
SELECT 
  animals.name AS animals_name, 
  vets.name AS vet_name 
  FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT animals.name, COUNT(*) FROM animals
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT 
  animals.name AS animal_name, 
  vets.name AS vet_name, 
  FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
JOIN owners ON animals.owner_id = owners.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_of_visit ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit
SELECT animals.name, vets.name, visits.date_of_visit FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.date_of_visit DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
JOIN specializations ON vets.id = specializations.vet_id
WHERE animals.species_id != specializations.species_id;

-- What specialty should veterinarian Maisy Smith consider getting? Look for the species she gets the most
SELECT species.name AS specialty
FROM species
JOIN (
    SELECT animals.species_id, COUNT(visits.animal_id) AS number_of_visits
    FROM visits
    JOIN animals ON animals.id = visits.animal_id
    JOIN vets ON vets.id = visits.vet_id
    WHERE vets.name = 'Maisy Smith'
    GROUP BY animals.species_id
    ORDER BY number_of_visits DESC
    LIMIT 1
) AS most_visited_species ON most_visited_species.species_id = species.id
JOIN specializations s ON s.species_id = species.id
LIMIT 1;

-- Help reduce time in the first query
CREATE INDEX idx_animal_id ON visits(animal_id);

-- Optimize second query
CREATE INDEX idx_vet_id ON visits(vet_id);

-- Optimaize third query
CREATE INDEX idx_email ON owners(email);
