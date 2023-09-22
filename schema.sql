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
