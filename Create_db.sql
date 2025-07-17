-- Create the database
CREATE DATABASE IF NOT EXISTS db_of_acnsms;
USE db_of_acnsms;

-- 1. User Table
CREATE TABLE user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(80) UNIQUE NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role ENUM('student', 'lecturer', 'admin') NOT NULL,
    department VARCHAR(100) NOT NULL
);

-- 2. Room Table
CREATE TABLE room (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    capacity INT NOT NULL,
    department VARCHAR(100) NOT NULL
);

-- 3. Program Table
CREATE TABLE program (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type ENUM('Degree', 'HND', 'CAIT') NOT NULL,
    mode ENUM('Weekday', 'Weekend') NOT NULL,
    department VARCHAR(100) NOT NULL
);

-- 4. Module Table
CREATE TABLE module (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    program_id INT NOT NULL,
    semester INT NOT NULL,
    FOREIGN KEY (program_id) REFERENCES program(id) ON DELETE CASCADE
);

-- 5. Schedule Table
CREATE TABLE schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject VARCHAR(100) NOT NULL,
    lecturer_id INT NOT NULL,
    room_id INT NOT NULL,
    program_id INT NOT NULL,
    module_id INT NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') NOT NULL,
    google_calendar_link VARCHAR(255),
    FOREIGN KEY (lecturer_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES room(id) ON DELETE CASCADE,
    FOREIGN KEY (program_id) REFERENCES program(id) ON DELETE CASCADE,
    FOREIGN KEY (module_id) REFERENCES module(id) ON DELETE CASCADE
);

-- 6. Reschedule Table
CREATE TABLE reschedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    schedule_id INT NOT NULL,
    old_date DATE NOT NULL,
    old_start_time TIME NOT NULL,
    old_end_time TIME NOT NULL,
    new_date DATE NOT NULL,
    new_start_time TIME NOT NULL,
    new_end_time TIME NOT NULL,
    reason TEXT NOT NULL,
    updated_by INT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    google_calendar_link VARCHAR(255),
    FOREIGN KEY (schedule_id) REFERENCES schedule(id) ON DELETE CASCADE,
    FOREIGN KEY (updated_by) REFERENCES user(id) ON DELETE CASCADE
);

-- 7. Message Templates Table
CREATE TABLE message_templates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    body_text TEXT NOT NULL,
    body_html TEXT NOT NULL,
    template_type ENUM('schedule', 'reschedule', 'reminder') NOT NULL,
    channel ENUM('sms', 'email', 'both') NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- 8. Notification Log Table
CREATE TABLE notification_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    schedule_id INT,
    reschedule_id INT,
    template_id INT NOT NULL,
    channel ENUM('sms', 'email') NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('sent', 'failed', 'pending') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES schedule(id) ON DELETE SET NULL,
    FOREIGN KEY (reschedule_id) REFERENCES reschedule(id) ON DELETE SET NULL,
    FOREIGN KEY (template_id) REFERENCES message_templates(id) ON DELETE CASCADE
);
