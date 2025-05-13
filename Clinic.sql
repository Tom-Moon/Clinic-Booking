-- -------------------------------------------------------------
-- MySQL Database Implementation for Clinic Booking System
-- -------------------------------------------------------------

-- 1. Database Creation
--    Create a new database to house all the tables.
CREATE DATABASE IF NOT EXISTS ClinicBookingSystem;
USE ClinicBookingSystem;

-- -------------------------------------------------------------
-- 2. Table Creation
--    Create tables to store information about patients, doctors,
--    appointments, and medical services.
-- -------------------------------------------------------------

-- 2.1 Patients Table
--    Stores patient details.
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL UNIQUE,
    Email VARCHAR(255) UNIQUE,
    Address VARCHAR(255),
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.2 Doctors Table
--    Stores doctor details.
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Specialization VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    ContactNumber VARCHAR(20) UNIQUE,
    RoomNumber VARCHAR(10),
    HireDate DATE,
    -- Added a self-referencing foreign key for managing supervising doctors
    SupervisorID INT,
    FOREIGN KEY (SupervisorID) REFERENCES Doctors(DoctorID)
);

-- 2.3 Appointments Table
--    Stores appointment details, linking patients and doctors.
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Reason VARCHAR(255) NOT NULL,
    Status ENUM('Scheduled', 'Confirmed', 'Cancelled', 'Completed') NOT NULL DEFAULT 'Scheduled',
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    -- Added a constraint to prevent double booking.
    UNIQUE (DoctorID, AppointmentDate)
);

-- 2.4 MedicalServices Table
--    Stores information about the medical services offered.
CREATE TABLE MedicalServices (
    ServiceID INT AUTO_INCREMENT PRIMARY KEY,
    ServiceName VARCHAR(255) NOT NULL UNIQUE,
    Description TEXT,
    Cost DECIMAL(10, 2) NOT NULL
);

-- 2.5 AppointmentServices Table (M-M Relationship)
--    Links appointments to medical services, allowing for multiple services
--    per appointment.
CREATE TABLE AppointmentServices (
    AppointmentID INT NOT NULL,
    ServiceID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,  -- Allow specifying quantity of service
    PRIMARY KEY (AppointmentID, ServiceID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (ServiceID) REFERENCES MedicalServices(ServiceID)
);

-- -------------------------------------------------------------
-- 3. Constraints and Relationships Summary
-- -------------------------------------------------------------

-- * Primary Keys:  Used to uniquely identify records in each table.
-- * Foreign Keys:  Used to establish relationships between tables.
-- * NOT NULL:      Ensures that certain columns cannot be empty.
-- * UNIQUE:        Ensures that values in a column are unique.
-- * DEFAULT:     Sets a default value for a column if no value is provided.
-- * CHECK:         (Not used in this simplified version, but can be added
--                    for more complex data validation, e.g., ensuring
--                    age is within a reasonable range).
-- * 1-M Relationships:
--     * Patients -> Appointments
--     * Doctors  -> Appointments
--     * Doctors -> Doctors (for supervision)
--     * MedicalServices -> AppointmentServices
-- * M-M Relationship:
--     * Appointments <-> MedicalServices (through AppointmentServices)
-- -------------------------------------------------------------

-- 4. Indexing
-- Added indexes to improve query performance
CREATE INDEX idx_LastName ON Patients(LastName);
CREATE INDEX idx_Specialization ON Doctors(Specialization);
CREATE INDEX idx_AppointmentDate ON Appointments(AppointmentDate);
CREATE INDEX idx_ServiceName ON MedicalServices(ServiceName);
