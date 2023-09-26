-- Create a table to store patient information.
CREATE TABLE patients(
	id serial PRIMARY KEY,
	name VARCHAR(50),
	date_of_birth DATE
)

-- Create a table to store invoices.
CREATE TABLE invoices(
	id serial PRIMARY KEY,
	total_amount DECIMAL(10, 2),
	generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	medical_history_id INTEGER
)

-- Create a table to store treatments.
CREATE TABLE treatments (
    id serial PRIMARY KEY,
    name varchar(50),
    type varchar(50)
);

-- Create a table to store medical histories.
CREATE TABLE medical_histories(
	id serial PRIMARY KEY,
	admitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	patient_id INTEGER,
	status VARCHAR(50)
)

-- Create a table to store invoice items.
CREATE TABLE invoice_items (
    id serial PRIMARY KEY,
    unit_price DECIMAL(10, 2),
    quantity INT,
    total_price DECIMAL(10, 2),
    invoice_id INT,
    treatment_id INT
);

-- Add a foreign key constraint to the invoice table that references the medical_history table.
ALTER TABLE invoices
ADD CONSTRAINT fk_invoice_medical_history_id
FOREIGN KEY (medical_history_id)
REFERENCES medical_histories (id);

-- Add a foreign key constraint to the medical_history table that references the patients table.
ALTER TABLE medical_histories
ADD CONSTRAINT fk_medical_history_patients_id
FOREIGN KEY (patient_id)
REFERENCES patients (id);

-- Add a foreign key constraint to the invoice_items table that references the invoices table.
ALTER TABLE invoice_items
ADD CONSTRAINT fk_invoice_invoice_items_invoice_id
FOREIGN KEY (invoice_id)
REFERENCES invoices (id);

-- Add a foreign key constraint to the invoice_items table that references the treatments table.
ALTER TABLE invoice_items
ADD CONSTRAINT fk_tratments_tratment_id
FOREIGN KEY (treatment_id)
REFERENCES treatments(id);

-- Create a table to store the many-to-many relationship between treatments and medical histories.
CREATE TABLE treatment_medical (
    treatment_id INT,
    medical_histories_id INT,
    PRIMARY KEY (treatment_id, medical_histories_id),
    FOREIGN KEY (treatment_id) REFERENCES treatments(id),
    FOREIGN KEY (medical_histories_id) REFERENCES medical_histories(id)
);