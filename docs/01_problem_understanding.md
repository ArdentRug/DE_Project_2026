# Understanding the Problem: Practo Doctor Appointments

## 1. Project Overview

Practo is a healthcare technology platform that allows patients to find doctors, book appointments, attend consultations, and access prescriptions and medical records.

The platform supports both in-clinic and video consultations, connecting patients, doctors, and healthcare facilities through a centralized appointment management system.

The existing database schema is not available, so the database structure must be inferred from the provided data exports. The main objective is to design a stable, well-constrained PostgreSQL database that supports operational transactions, analytical workloads, and future scalability.

## 2. Business Problem Analysis

The following table describes the key business requirements, their stakeholders, and their classifications.

| ID | Business Requirement | Stakeholders | Classification |
|---|---|---|---|
| P1 | Improve doctor discovery, profile retrieval, and appointment slot availability through efficient searches based on specialization, city, verification status, and doctor schedules. | Patients, Doctors | Customer-facing / Real-time |
| P2 | Improve the response time of patient sign-in, appointment history, prescription retrieval, and appointment booking operations. | Patients | Customer-facing / Real-time |
| P3 | Allow clinic reception staff to access doctors' daily appointment schedules and check in patients without delays. | Clinic Reception, Doctors | Customer-facing / Real-time |
| P4 | Enable quick identification of potential medication-allergy conflicts, overdue follow-ups, and patients consulting multiple doctors within the same specialization. | Patients, Care Team, Patient Safety Team | Customer-facing / Real-time |
| P5 | Support clinic partnership management and operational planning by identifying clinics without any doctors on a schedule. | Clinic Partnerships Team | Reporting / Analytics |
| P6 | Improve the analysis of no-show rates, waiting times, doctor ratings, and appointment double-bookings to monitor healthcare service quality. | Quality Team, Clinics | Reporting / Analytics |
| P7 | Support efficient financial, pharmacy, and population-health reporting while preparing the database to handle a 20x increase in appointment volume. | Finance Team, Pharmacy Partners, Insights Team | Reporting / Analytics |

## 3. Key System Requirements

1. Enable efficient doctor searches based on specialization, location, language, and verification status.
2. Maintain up-to-date information about doctors' schedules and appointment availability.
3. Provide secure patient registration, appointment booking, check-in, and consultation records.
4. Maintain prescription, medicine, allergy, follow-up, and review information.
5. Allow operational monitoring and identification of data-quality and patient-safety issues.
6. Support financial, pharmacy, and population-health analytics.
7. Ensure data integrity and provide scalability to accommodate future growth.

## 4. Assumptions

1. The 11 CSV files provided are the available source datasets for reconstructing the database.
2. All existing identifier columns will be evaluated for their suitability as primary keys and for establishing appropriate relationships.
3. The meaning of `N/A` values will be interpreted according to the relevant business context.
4. Multiple doctors can have multiple specializations, and clinics can have multiple schedule entries per week.
5. Appointments can be conducted either in-clinic or through video consultation.
6. Appointment fees will be stored as historical transaction values and will not automatically change when a doctor's consultation fee is updated.
7. The timezone information associated with timestamp columns will be preserved.
8. The database design must support the existing dataset and remain scalable to accommodate a projected 20-fold increase in appointment volume.

## 5. Project Objective

The objective of this project is to design and implement a normalized, well-constrained relational database using PostgreSQL.

The project will involve:

- Validating and loading the provided healthcare datasets.
- Designing appropriate tables, primary keys, foreign keys, and relationships.
- Ensuring data consistency and referential integrity.
- Testing query performance against operational and analytical requirements.
- Optimizing database queries and indexes where necessary.
- Evaluating the database's ability to support future growth, including a projected 20x increase in appointment volume.

The final goal is to build a reliable, scalable, and efficient database system that supports Practo's healthcare appointment management operations and analytical requirements.

