# Practo Doctor Appointments Database Schema

## 1. Overview

The Practo database will be created using PostgreSQL. The schema will ensure data is structured using tables with relations to reduce duplication and ensure data integrity.

The design will use a relational database and normalisation.

## 2. Database Tables and Descriptions

| No. | Table Name | Description |
|----|----------|-----------|
| 1 | cities | Contains city information |
| 2 | specializations | Contains medical specialisations |
| 3 | doctors | Contains doctor information |
| 4 | doctor_specializations | Contains doctors and their specialisations |
| 5 | clinics | Contains clinic information |
| 6 | doctor_schedules | Contains doctors schedules and clinic information |
| 7 | patients | Contains patient information |
| 8 | appointments | Contains appointments made by patients |
| 9 | prescriptions | Contains prescriptions |
| 10 | prescription_items | Contains individual medicines on the prescriptions |
| 11 | doctor_reviews | Contains reviews on doctors by patients |

## 3. Relations Between Tables

| Parent Table | Child Table | Relation |
|-------------|------------|---------|
| cities | clinics | One to Many |
| cities | patients | One to Many |
| doctors | doctor_specializations | One to Many |
| specializations | doctor_specializations | One to Many |
| doctors | doctor_schedules | One to Many |
| clinics | doctor_schedules | One to Many |
| patients | appointments | One to Many |
| doctors | appointments | One to Many |
| clinics | appointments | One to Many |
| appointments | prescriptions | One to One / One to Many (Depends on data) |
| prescriptions | prescription_items | One to Many |
| doctors | doctor_reviews | One to Many |
| patients | doctor_reviews | One to Many |

## 4. Primary and Foreign Keys

| Table | Primary Key | Foreign Key |
|------|------------|-----------|
| cities | city_id | N/A |
| specializations | specialization_id | N/A |
| doctors | doctor_id | city_id |
| doctor_specializations | doctor_specialization_id | doctor_id, specialization_id |
| clinics | clinic_id | city_id |
| doctor_schedules | schedule_id | doctor_id, clinic_id |
| patients | patient_id | city_id |
| appointments | appointment_id | patient_id, doctor_id, clinic_id |
| prescriptions | prescription_id | appointment_id |
| prescription_items | prescription_item_id | prescription_id |
| doctor_reviews | review_id | patient_id, doctor_id |

The Primary and foreign keys will be confirmed once the actual CSV columns are viewed.

## 5. Guidelines For Implementation

The database will be implemented using the following guidelines:

- Normalisation – To reduce any unneccessary duplication.
- Primary Keys – Every record will have a Primary Key.
- Foreign Keys – Valid relations will be created.
- Constraints – The database will have Not Null, Unique, Check, etc constraints.
- Data Types – All columns will have appropriate data types for PostgreSQL.
- Indexes – Columns which will be heavily searched / joined will have indexes.
- Scale – The database will be built to scale with 20x more appointments.

## 6. Benefits Of This Design

- Less data duplication.
- Improved data consistency.
- Doctors and Clinics can be easily searched.
- Appointments can be booked and found quickly.
- Improved reporting.
- Future growth of the database.

## 7. Implementation

Once the final schema has been decided upon, based on the actual CSVs the database can be implemented with the tables in PostgreSQL using SQL Scripts.
