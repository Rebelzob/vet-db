CREATE TABLE patients(
	id serial PRIMARY KEY,
	name VARCHAR(50),
	date_of_birth DATE
)

CREATE TABLE invoice(
	id serial PRIMARY KEY,
	total_amount DECIMAL(10, 2),
	generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	medical_history_id INTEGER
)

CREATE TABLE treatments (
    id serial PRIMARY KEY,
    name varchar(50),
    type varchar(50)
);