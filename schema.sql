/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
	id serial PRIMARY KEY,
	name VARCHAR(50),
	date_of_birth DATE,
	scape_attempts SMALLINT,
	neutered BOOLEAN,
	weight_kg DECIMAL(5, 2)
) 

ALTER TABLE animals
ADD COLUMN species VARCHAR(50);

CREATE TABLE owners(
	id serial PRIMARY KEY,
	full_name VARCHAR(50),
	age SMALLINT,
)

CREATE TABLE species(
	id serial PRIMARY KEY,
	name VARCHAR(50)
)

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN species_id INTEGER REFERENCES species(id);

ALTER TABLE animals
ADD COLUMN owner_id INTEGER REFERENCES owners(id);

CREATE TABLE vets(
	id serial PRIMARY KEY,
	name VARCHAR(50),
	age SMALLINT,
	date_of_graduation DATE
)

-- Many to many relationship between the tables species and vets:
CREATE TABLE specializations(
	id serial PRIMARY KEY,
	species_id INTEGER REFERENCES species(id),
	vet_id INTEGER REFERENCES vets(id)
)

-- Many to many relationship between the tables animals and vets:
CREATE TABLE visits(
	id serial PRIMARY KEY,
	animal_id INTEGER REFERENCES animals(id),
	vet_id INTEGER REFERENCES vets(id),
	date_of_visit DATE
)

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);


-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';