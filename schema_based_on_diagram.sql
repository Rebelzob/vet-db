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

CREATE TABLE medical_histories(
	id serial PRIMARY KEY,
	admitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	patient_id INTEGER,
	status VARCHAR(50)
)

CREATE TABLE invoice_items (
    id serial PRIMARY KEY,
    unit_price DECIMAL(10, 2),
    quantity INT,
    total_price DECIMAL(10, 2),
    invoice_id INT,
    treatment_id INT
);

ALTER TABLE invoice
ADD CONSTRAINT fk_invoice_medical_history_id
FOREIGN KEY (medical_history_id)
REFERENCES medical_histories (id);

ALTER TABLE medical_histories
ADD CONSTRAINT fk_medical_history_patients_id
FOREIGN KEY (patient_id)
REFERENCES patients (id);

ALTER TABLE invoice_items
ADD CONSTRAINT fk_invoice_invoice_items_invoice_id
FOREIGN KEY (invoice_id)
REFERENCES invoices (id);

ALTER TABLE invoice_items
ADD CONSTRAINT fk_tratments_tratment_id
FOREIGN KEY (treatment_id)
REFERENCES treatments(id);

CREATE TABLE treatment_medical (
    treatment_id INT,
    medical_histories_id INT,
    PRIMARY KEY (treatment_id, medical_histories_id),
    FOREIGN KEY (treatment_id) REFERENCES treatments(id),
    FOREIGN KEY (medical_histories_id) REFERENCES medical_histories(id)
);