
-- =====================================================
-- PRACTO DATABASE PROJECT
-- CP1 - Phase 2: Schema Creation
-- Team: T0035 | Section: E
-- =====================================================

-- Create schema
CREATE SCHEMA IF NOT EXISTS practo;

-- Set default schema
SET search_path TO practo;


-- =====================================================
-- 1. CITIES
-- =====================================================

CREATE TABLE cities (
    city_id INTEGER PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,

    CONSTRAINT uq_cities_name_state
        UNIQUE (city_name, state)
);


-- =====================================================
-- 2. SPECIALIZATIONS
-- =====================================================

CREATE TABLE specializations (
    spec_id INTEGER PRIMARY KEY,
    spec_name VARCHAR(100) NOT NULL UNIQUE
);


-- =====================================================
-- 3. DOCTORS
-- =====================================================

CREATE TABLE doctors (
    doctor_id INTEGER PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    registration_no VARCHAR(30) NOT NULL UNIQUE,
    gender CHAR(1) NOT NULL,
    experience_years INTEGER NOT NULL,
    consultation_fee NUMERIC(10,2) NOT NULL,
    video_fee NUMERIC(10,2),
    languages TEXT[] NOT NULL,
    is_verified BOOLEAN NOT NULL,
    joined_on DATE NOT NULL,

    CONSTRAINT chk_doctor_gender
        CHECK (gender IN ('M', 'F')),

    CONSTRAINT chk_doctor_experience
        CHECK (experience_years >= 0),

    CONSTRAINT chk_doctor_consultation_fee
        CHECK (consultation_fee >= 0),

    CONSTRAINT chk_doctor_video_fee
        CHECK (video_fee IS NULL OR video_fee >= 0),

    CONSTRAINT chk_doctor_languages
        CHECK (cardinality(languages) > 0)
);


-- =====================================================
-- 4. DOCTOR SPECIALIZATIONS
-- =====================================================

CREATE TABLE doctor_specializations (
    doctor_id INTEGER NOT NULL,
    spec_id INTEGER NOT NULL,
    is_primary BOOLEAN NOT NULL,

    CONSTRAINT pk_doctor_specializations
        PRIMARY KEY (doctor_id, spec_id),

    CONSTRAINT fk_ds_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_ds_specialization
        FOREIGN KEY (spec_id)
        REFERENCES specializations(spec_id)
        ON DELETE RESTRICT
);

-- Each doctor can have only one primary specialization.
CREATE UNIQUE INDEX uq_one_primary_specialization
ON doctor_specializations (doctor_id)
WHERE is_primary = TRUE;


-- =====================================================
-- 5. CLINICS
-- =====================================================

CREATE TABLE clinics (
    clinic_id INTEGER PRIMARY KEY,
    clinic_name VARCHAR(150) NOT NULL,
    city_id INTEGER NOT NULL,
    locality VARCHAR(150) NOT NULL,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,

    CONSTRAINT fk_clinic_city
        FOREIGN KEY (city_id)
        REFERENCES cities(city_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_clinic_latitude
        CHECK (latitude BETWEEN -90 AND 90),

    CONSTRAINT chk_clinic_longitude
        CHECK (longitude BETWEEN -180 AND 180)
);


-- =====================================================
-- 6. DOCTOR SCHEDULES
-- =====================================================

CREATE TABLE doctor_schedules (
    doctor_id INTEGER NOT NULL,
    weekday INTEGER NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    clinic_id INTEGER,
    slot_minutes INTEGER NOT NULL,

    CONSTRAINT pk_doctor_schedules
        PRIMARY KEY (doctor_id, weekday, start_time),

    CONSTRAINT fk_schedule_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_schedule_clinic
        FOREIGN KEY (clinic_id)
        REFERENCES clinics(clinic_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_schedule_weekday
        CHECK (weekday BETWEEN 1 AND 7),

    CONSTRAINT chk_schedule_time
        CHECK (start_time < end_time),

    CONSTRAINT chk_schedule_slot_minutes
        CHECK (slot_minutes IN (10, 15, 20))
);


-- =====================================================
-- 7. PATIENTS
-- =====================================================

CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) UNIQUE,
    dob DATE NOT NULL,
    gender CHAR(1) NOT NULL,
    blood_group VARCHAR(3),
    allergies TEXT[],
    city_id INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,

    CONSTRAINT fk_patient_city
        FOREIGN KEY (city_id)
        REFERENCES cities(city_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_patient_gender
        CHECK (gender IN ('M', 'F', 'X')),

    CONSTRAINT chk_patient_blood_group
        CHECK (
            blood_group IS NULL OR
            blood_group IN (
                'A+', 'A-', 'B+', 'B-',
                'AB+', 'AB-', 'O+', 'O-'
            )
        )
);


-- =====================================================
-- 8. APPOINTMENTS
-- =====================================================

CREATE TABLE appointments (
    appointment_id INTEGER PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    clinic_id INTEGER,
    consult_type VARCHAR(20) NOT NULL,
    booked_at TIMESTAMPTZ NOT NULL,
    slot_start TIMESTAMPTZ NOT NULL,
    slot_end TIMESTAMPTZ NOT NULL,
    reason TEXT,
    status VARCHAR(20) NOT NULL,
    checked_in_at TIMESTAMPTZ,
    consult_started_at TIMESTAMPTZ,
    consult_ended_at TIMESTAMPTZ,
    fee NUMERIC(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointment_clinic
        FOREIGN KEY (clinic_id)
        REFERENCES clinics(clinic_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_appointment_consult_type
        CHECK (consult_type IN ('IN_CLINIC', 'VIDEO')),

    CONSTRAINT chk_appointment_status
        CHECK (
            status IN (
                'BOOKED', 'CHECKED_IN', 'COMPLETED',
                'CANCELLED', 'NO_SHOW'
            )
        ),

    CONSTRAINT chk_appointment_payment_status
        CHECK (
            payment_status IN (
                'PAID', 'PENDING', 'REFUNDED'
            )
        ),

    CONSTRAINT chk_appointment_slot_time
        CHECK (slot_end > slot_start),

    CONSTRAINT chk_appointment_fee
        CHECK (fee >= 0),

    CONSTRAINT chk_appointment_clinic_type
        CHECK (
            (consult_type = 'IN_CLINIC' AND clinic_id IS NOT NULL)
            OR
            (consult_type = 'VIDEO' AND clinic_id IS NULL)
        ),

    CONSTRAINT chk_appointment_checkin_type
        CHECK (
            checked_in_at IS NULL
            OR consult_type = 'IN_CLINIC'
        ),

    CONSTRAINT chk_appointment_consult_timestamps
        CHECK (
            (consult_started_at IS NULL AND consult_ended_at IS NULL)
            OR
            (
                consult_started_at IS NOT NULL
                AND consult_ended_at IS NOT NULL
                AND consult_ended_at >= consult_started_at
            )
        )
);


-- =====================================================
-- 9. PRESCRIPTIONS
-- =====================================================

CREATE TABLE prescriptions (
    prescription_id INTEGER PRIMARY KEY,
    appointment_id INTEGER NOT NULL UNIQUE,
    diagnosis TEXT NOT NULL,
    notes TEXT,
    follow_up_date DATE,
    issued_at TIMESTAMPTZ NOT NULL,

    CONSTRAINT fk_prescription_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
        ON DELETE RESTRICT
);


-- =====================================================
-- 10. PRESCRIPTION ITEMS
-- =====================================================

CREATE TABLE prescription_items (
    prescription_id INTEGER NOT NULL,
    line_no INTEGER NOT NULL,
    medicine_name VARCHAR(200) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    duration_days INTEGER NOT NULL,
    instructions TEXT,

    CONSTRAINT pk_prescription_items
        PRIMARY KEY (prescription_id, line_no),

    CONSTRAINT fk_item_prescription
        FOREIGN KEY (prescription_id)
        REFERENCES prescriptions(prescription_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_prescription_line
        CHECK (line_no > 0),

    CONSTRAINT chk_prescription_duration
        CHECK (duration_days > 0)
);


-- =====================================================
-- 11. DOCTOR REVIEWS
-- =====================================================

CREATE TABLE doctor_reviews (
    review_id INTEGER PRIMARY KEY,
    appointment_id INTEGER NOT NULL UNIQUE,
    rating INTEGER NOT NULL,
    recommends BOOLEAN NOT NULL,
    wait_time_bucket VARCHAR(20),
    review_text TEXT,
    created_at TIMESTAMPTZ NOT NULL,

    CONSTRAINT fk_review_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_review_rating
        CHECK (rating BETWEEN 1 AND 5),

    CONSTRAINT chk_review_wait_bucket
        CHECK (
            wait_time_bucket IS NULL
            OR wait_time_bucket IN (
                '<15 min',
                '15-30 min',
                '30-60 min',
                '>1 hr'
            )
        )
);


-- =====================================================
-- END OF PRACTO DATABASE SCHEMA
-- Total Tables: 11
-- =====================================================
