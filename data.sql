/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, scape_attempts, neutered, weight_kg) VALUES ('Agumon', '2020-02-03', '0', 'TRUE', '10.23');
INSERT INTO animals (name, date_of_birth, scape_attempts, neutered, weight_kg) VALUES ('Gabumon', '2018-11-15', '2', 'TRUE', '8');
INSERT INTO animals (name, date_of_birth, scape_attempts, neutered, weight_kg) VALUES ('Pikachu', '2021-01-07', '1', 'FALSE', '15.04');
INSERT INTO animals (name, date_of_birth, scape_attempts, neutered, weight_kg) VALUES ('Devimon', '2017-05-12', '5', 'TRUE', '11');

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
    ('Charmander', '2020-02-08', 0, false, -11),
    ('Plantmon', '2021-11-15', 2, true, -5.7),
    ('Squirtle', '1993-04-02', 3, false, -12.13),
    ('Angemon', '2005-06-12', 1, true, -45),
    ('Boarmon', '2005-06-07', 7, true, 20.4),
    ('Blossom', '1998-10-13', 3, true, 17),
    ('Ditto', '2022-05-14', 4, true, 22);

/* Populate database owners with this data */

INSERT INTO owners (full_name, age)
VALUES
    ('Sam Smith', 34),
    ('Jennifer Orwell', 19),
    ('Bob', 45),
    ('Melody Pond', 77),
    ('Dean Winchester', 14),
    ('Jodie Whittaker', 38);


/* Populate database species with this data */

INSERT INTO species (name)
VALUES
    ('Pokemon'),
    ('Digimon');

/* Modify your inserted animals so it includes the species_id value:
If the name ends in "mon" it will be Digimon
All other animals are Pokemon
*/

UPDATE animals
SET species_id = (SELECT id FROM species WHERE name = 'Digimon')
WHERE name LIKE '%mon';

UPDATE animals
SET species_id = (SELECT id FROM species WHERE name = 'Pokemon')
WHERE name NOT LIKE '%mon';

/* Modify your inserted animals to include owner information (owner_id)*/

-- Sam Smith owns Agumon.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Sam Smith')
WHERE name = 'Agumon';

-- Jennifer Orwell owns Gabumon and Pikachu.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
WHERE name IN ('Gabumon', 'Pikachu');

-- Bob owns Devimon and Plantmon.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Bob')
WHERE name IN ('Devimon', 'Plantmon');

-- Melody Pond owns Charmander, Squirtle, and Blossom.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Melody Pond')
WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

-- Dean Winchester owns Angemon and Boarmon.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
WHERE name IN ('Angemon', 'Boarmon');
