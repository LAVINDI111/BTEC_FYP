-- PostgreSQL Database Setup for ACNSMS
-- Converted from MariaDB/MySQL to PostgreSQL

-- Create database (will be created by Docker, but included for reference)
-- CREATE DATABASE db_of_acnsms;

-- Connect to the database
\c db_of_acnsms;

-- Create ENUM types for PostgreSQL
CREATE TYPE user_role AS ENUM ('student', 'lecturer', 'admin');
CREATE TYPE attendance_status AS ENUM ('Present', 'Absent', 'Excused');
CREATE TYPE schedule_status AS ENUM ('Scheduled', 'Completed', 'Cancelled');
CREATE TYPE program_type AS ENUM ('Degree', 'HND', 'Certificate');
CREATE TYPE program_mode AS ENUM ('weekday', 'weekend');
CREATE TYPE template_type AS ENUM ('schedule', 'reschedule', 'reminder');
CREATE TYPE notification_channel AS ENUM ('sms', 'email', 'both');
CREATE TYPE notification_status AS ENUM ('sent', 'failed', 'pending');

-- Table: admin
CREATE TABLE IF NOT EXISTS admin (
    id SERIAL PRIMARY KEY,
    "fullName" VARCHAR(100) NOT NULL,
    "adminId" VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

-- Insert admin data
INSERT INTO admin (id, "fullName", "adminId", email, phone) VALUES
    (1, 'System Administrator', 'ADM0001', 'admin@acnsms.com', '+1234567890')
ON CONFLICT (id) DO NOTHING;

-- Table: alembic_version
CREATE TABLE IF NOT EXISTS alembic_version (
    version_num VARCHAR(32) PRIMARY KEY
);

-- Insert alembic version
INSERT INTO alembic_version (version_num) VALUES ('509093b497ef')
ON CONFLICT DO NOTHING;

-- Table: specializepath
CREATE TABLE IF NOT EXISTS specializepath (
    id SERIAL PRIMARY KEY,
    "pathCode" VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50)
);

-- Insert specializepath data
INSERT INTO specializepath (id, "pathCode", name) VALUES
    (1, 'AI', 'Artificial Intelligence'),
    (2, 'SE', 'Software Engineering'),
    (3, 'CY', 'Cybersecurity'),
    (4, 'DA', 'Data Analytics'),
    (5, 'EEE', 'Electrical & Electronic Engineering'),
    (6, 'GD', 'Game Development'),
    (7, 'NW', 'Networking')
ON CONFLICT (id) DO NOTHING;

-- Table: program
CREATE TABLE IF NOT EXISTS program (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type program_type,
    mode program_mode NOT NULL,
    department VARCHAR(100) NOT NULL
);

-- Insert program data
INSERT INTO program (id, name, type, mode, department) VALUES
    (1, 'HND in Computer Science', 'HND', 'weekday', 'BTEC'),
    (2, 'BTEC HND in Computing', 'HND', 'weekend', 'BTEC'),
    (3, 'HND in Software Engineering', 'HND', 'weekday', 'BTEC'),
    (4, 'HND in Computer Science', 'HND', 'weekend', 'BTEC'),
    (5, 'BSc in EEE', 'Degree', 'weekday', 'UH'),
    (6, 'BSc in AI', 'Degree', 'weekend', 'UH'),
    (7, 'Certificate in Computer Science', 'Certificate', 'weekend', 'CAIT')
ON CONFLICT (id) DO NOTHING;

-- Table: user
CREATE TABLE IF NOT EXISTS "user" (
    id SERIAL PRIMARY KEY,
    "userName" VARCHAR(80) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role user_role NOT NULL,
    department VARCHAR(100) NOT NULL,
    "fName" VARCHAR(50) NOT NULL,
    "lName" VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert user data
INSERT INTO "user" (id, "userName", email, password_hash, phone, role, department, "fName", "lName", created_at) VALUES
    (1, 'admin', 'admin@acnsms.com', 'pbkdf2:sha256:600000$3HTJirpJTzYKxeqn$73ef77fd1e3660ec31d08323cbf6935bf1d556871046a0895c7805cab59c9b22', '+1234567890', 'admin', 'administration', 'System', 'Administrator', '2025-07-14 07:26:39'),
    (2, 'Tharu@2007', 'Laviber411@gmail.com', 'pbkdf2:sha256:600000$M9WaupTzHG8kYm2D$d38c07585f42c233bdc98e098e6ae4e322612c4e30d7e1c318af566d94d848cd', '0702511260', 'student', 'BTEC', 'Tharumini', 'Nawavickrama', '2025-07-14 07:36:18')
ON CONFLICT (id) DO NOTHING;

-- Table: lecturer
CREATE TABLE IF NOT EXISTS lecturer (
    id SERIAL PRIMARY KEY,
    "fullName" VARCHAR(100) NOT NULL,
    "lecturerId" VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

-- Insert lecturer data
INSERT INTO lecturer (id, "fullName", "lecturerId", email, phone) VALUES
    (1, 'Dr. Sakunika Perera', 'DRS001', 'sankilavindi@gmail.com', '+94718296726'),
    (2, 'Prof. John Gunawardhana', 'PRJ001', 'nipunaber@gmail.com', '+94702511260'),
    (3, 'Ms. Chathuni De Silva', 'MSC001', 'gachirathdilshanedu@gmail.com', '+94784491594'),
    (4, 'Mr. Indunil Bandara', 'MRI001', 'chirathdilshan2003@gmail.com', '+94776427812'),
    (5, 'Prof. Chanaka Thilakarathne', 'PRC001', 'laviber411@gmail.com', '+94784497226'),
    (6, 'Mr. Prasanna Jayawarna', 'MRP001', 'chirathdilshanhp@gmail.com', '+94723497504')
ON CONFLICT (id) DO NOTHING;

-- Table: student
CREATE TABLE IF NOT EXISTS student (
    id SERIAL PRIMARY KEY,
    "userId" INTEGER NOT NULL REFERENCES "user"(id),
    "sfId" VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    department VARCHAR(100) NOT NULL,
    "specializePath" INTEGER REFERENCES specializepath(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Insert student data
INSERT INTO student (id, "userId", "sfId", email, phone, department, "specializePath") VALUES
    (1, 2, 'SF0002', 'Laviber411@gmail.com', '0702511260', 'BTEC', 3)
ON CONFLICT (id) DO NOTHING;

-- Table: module
CREATE TABLE IF NOT EXISTS module (
    id SERIAL PRIMARY KEY,
    department VARCHAR(100) NOT NULL,
    "specializePath" VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    "programId" INTEGER NOT NULL REFERENCES program(id),
    semester INTEGER NOT NULL
);

-- Insert module data
INSERT INTO module (id, department, "specializePath", name, code, "programId", semester) VALUES
    (1, 'BTEC', 'SE', 'Software Engineering Basics', 'SE101', 3, 1),
    (2, 'BTEC', 'AI', 'Introduction to AI', 'AI201', 6, 2),
    (4, 'UH', 'DA', 'Programming Fundermentals', 'DA104', 2, 1),
    (5, 'CAIT', 'CC', 'Database Systems', 'AI105', 1, 1),
    (6, 'BTEC', 'SE', 'Web Development', 'CS106', 7, 2),
    (7, 'UH', 'NW', 'IOT', 'CC107', 5, 2)
ON CONFLICT (id) DO NOTHING;

-- Table: room
CREATE TABLE IF NOT EXISTS room (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    capacity INTEGER NOT NULL
);

-- Insert room data
INSERT INTO room (id, name, capacity) VALUES
    (1, 'auditorium', 150),
    (2, 'LR1', 60),
    (3, 'LR2', 40),
    (4, 'LR3', 70),
    (5, 'LR4', 40),
    (6, 'LR5', 30),
    (7, 'LR6', 30),
    (8, 'com_lab1', 50),
    (9, 'com_lab2', 30),
    (10, 'com_lab3', 25),
    (11, 'DSM lab', 40),
    (12, 'DC lab', 30),
    (13, 'CSP lab', 30),
    (14, 'E''tronic lab', 25)
ON CONFLICT (id) DO NOTHING;

-- Table: schedule
CREATE TABLE IF NOT EXISTS schedule (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    subject VARCHAR(100) NOT NULL,
    status schedule_status NOT NULL,
    google_calendar_link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    room_id INTEGER NOT NULL REFERENCES room(id),
    lecturer_id INTEGER NOT NULL REFERENCES "user"(id),
    program_id INTEGER NOT NULL REFERENCES program(id),
    module_id INTEGER NOT NULL REFERENCES module(id)
);

-- Insert schedule data
INSERT INTO schedule (id, date, start_time, end_time, subject, status, google_calendar_link, created_at, room_id, lecturer_id, program_id, module_id) VALUES
    (10, '2025-08-21', '09:00:00', '12:00:00', '(auto)', 'Scheduled', NULL, '2025-07-16 12:26:15', 1, 1, 1, 1),
    (15, '2025-09-06', '06:00:00', '07:00:00', '(auto)', 'Scheduled', NULL, '2025-07-17 07:56:44', 4, 1, 1, 1),
    (17, '2025-08-07', '09:00:00', '12:00:00', '(auto)', 'Scheduled', NULL, '2025-07-17 08:01:25', 1, 1, 1, 1),
    (19, '2025-07-06', '08:00:00', '13:00:00', '(auto)', 'Scheduled', NULL, '2025-07-17 08:27:15', 12, 1, 3, 1),
    (21, '2025-07-06', '09:00:00', '10:00:00', 'mache lerning and ai', 'Scheduled', NULL, '2025-07-19 05:33:57', 12, 1, 2, 4),
    (22, '2025-07-13', '09:00:00', '17:00:00', 'java fundermendal', 'Scheduled', NULL, '2025-07-20 10:13:16', 3, 1, 2, 2),
    (23, '2025-05-18', '08:00:00', '10:00:00', 'AI & ML', 'Scheduled', NULL, '2025-07-21 04:53:46', 12, 1, 6, 1),
    (24, '2025-08-28', '03:00:00', '05:00:00', 'business interligent', 'Scheduled', NULL, '2025-07-21 08:25:08', 1, 1, 2, 1),
    (25, '2025-09-07', '07:00:00', '09:00:00', 'abc', 'Scheduled', NULL, '2025-07-21 10:18:03', 1, 1, 1, 7)
ON CONFLICT (id) DO NOTHING;

-- Table: attendance
CREATE TABLE IF NOT EXISTS attendance (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES student(id),
    schedule_id INTEGER NOT NULL REFERENCES schedule(id),
    status attendance_status NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, schedule_id)
);

-- Table: reschedule
CREATE TABLE IF NOT EXISTS reschedule (
    id SERIAL PRIMARY KEY,
    schedule_id INTEGER NOT NULL REFERENCES schedule(id),
    old_date DATE NOT NULL,
    old_start_time TIME NOT NULL,
    old_end_time TIME NOT NULL,
    new_date DATE NOT NULL,
    new_start_time TIME NOT NULL,
    new_end_time TIME NOT NULL,
    reason TEXT NOT NULL,
    updated_by INTEGER NOT NULL REFERENCES "user"(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    google_calendar_link VARCHAR(255)
);

-- Insert reschedule data
INSERT INTO reschedule (id, schedule_id, old_date, old_start_time, old_end_time, new_date, new_start_time, new_end_time, reason, updated_by, updated_at, google_calendar_link) VALUES
    (1, 22, '2025-07-06', '09:00:00', '12:00:00', '2025-07-13', '09:00:00', '17:00:00', 'have another exam in that class room', 1, '2025-07-20 10:15:06', NULL),
    (2, 24, '2025-08-08', '09:00:00', '12:00:00', '2025-08-28', '09:00:00', '12:00:00', '', 1, '2025-07-21 08:45:15', NULL),
    (3, 24, '2025-08-28', '09:00:00', '12:00:00', '2025-08-28', '03:00:00', '05:00:00', 'personal matter', 1, '2025-07-21 09:06:53', NULL),
    (4, 10, '2025-08-03', '09:00:00', '17:00:00', '2025-08-21', '09:00:00', '12:00:00', '', 1, '2025-07-22 16:35:44', NULL)
ON CONFLICT (id) DO NOTHING;

-- Table: message_templates
CREATE TABLE IF NOT EXISTS message_templates (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    body_text TEXT NOT NULL,
    body_html TEXT NOT NULL,
    template_type template_type NOT NULL,
    channel notification_channel NOT NULL,
    is_active BOOLEAN NOT NULL
);

-- Table: notification_log
CREATE TABLE IF NOT EXISTS notification_log (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES "user"(id),
    schedule_id INTEGER REFERENCES schedule(id),
    reschedule_id INTEGER REFERENCES reschedule(id),
    template_id INTEGER NOT NULL REFERENCES message_templates(id),
    channel notification_channel NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status notification_status NOT NULL
);

-- Table: audit_log
CREATE TABLE IF NOT EXISTS audit_log (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES "user"(id),
    action VARCHAR(255) NOT NULL,
    target_type VARCHAR(50),
    target_id INTEGER,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert audit_log data
INSERT INTO audit_log (id, user_id, action, target_type, target_id, timestamp) VALUES
    (1, 2, 'User Registered', 'User', 2, '2025-07-14 07:36:18'),
    (2, 2, 'Logged In', 'User', 2, '2025-07-14 07:36:35'),
    (3, 2, 'Logged Out', 'User', 2, '2025-07-14 07:37:58'),
    (4, 1, 'Logged In', 'User', 1, '2025-07-14 07:39:02'),
    (5, 1, 'Logged Out', 'User', 1, '2025-07-14 07:50:49'),
    (6, 2, 'Logged In', 'User', 2, '2025-07-14 13:24:02'),
    (7, 2, 'Logged Out', 'User', 2, '2025-07-14 13:36:32'),
    (8, 2, 'Logged In', 'User', 2, '2025-07-14 13:36:41'),
    (9, 2, 'Logged Out', 'User', 2, '2025-07-14 13:44:28'),
    (10, 2, 'Logged In', 'User', 2, '2025-07-14 13:44:34'),
    (11, 2, 'Logged Out', 'User', 2, '2025-07-14 13:45:22'),
    (12, 1, 'Logged In', 'User', 1, '2025-07-14 13:45:45'),
    (13, 1, 'Logged Out', 'User', 1, '2025-07-14 13:46:26'),
    (14, 2, 'Logged In', 'User', 2, '2025-07-14 13:46:32'),
    (15, 2, 'Logged Out', 'User', 2, '2025-07-14 13:47:50'),
    (16, 1, 'Logged In', 'User', 1, '2025-07-14 13:48:10'),
    (17, 1, 'Logged Out', 'User', 1, '2025-07-14 14:37:27'),
    (18, 2, 'Logged In', 'User', 2, '2025-07-14 14:37:33'),
    (19, 2, 'Logged In', 'User', 2, '2025-07-14 18:09:08'),
    (20, 2, 'Logged Out', 'User', 2, '2025-07-14 18:09:16'),
    (21, 1, 'Logged In', 'User', 1, '2025-07-14 18:09:34'),
    (22, 1, 'Logged Out', 'User', 1, '2025-07-14 18:37:42'),
    (23, 2, 'Logged In', 'User', 2, '2025-07-14 18:38:34'),
    (24, 2, 'Logged Out', 'User', 2, '2025-07-14 18:42:59'),
    (25, 1, 'Logged In', 'User', 1, '2025-07-14 18:43:25'),
    (26, 1, 'Logged In', 'User', 1, '2025-07-15 05:09:16'),
    (27, 1, 'Created Schedule', 'Schedule', 10, '2025-07-16 12:26:15'),
    (28, 1, 'Logged In', 'User', 1, '2025-07-17 06:20:11'),
    (29, 1, 'Logged In', 'User', 1, '2025-07-17 07:12:30'),
    (30, 1, 'Created Schedule', 'Schedule', 15, '2025-07-17 07:56:44'),
    (31, 1, 'Created Schedule', 'Schedule', 17, '2025-07-17 08:01:25'),
    (32, 1, 'Created Schedule', 'Schedule', 19, '2025-07-17 08:27:15'),
    (33, 1, 'Logged In', 'User', 1, '2025-07-19 05:23:33'),
    (34, 1, 'Logged In', 'User', 1, '2025-07-19 05:27:17'),
    (35, 1, 'Created Schedule', 'Schedule', 21, '2025-07-19 05:33:57'),
    (36, 1, 'Created Schedule', 'Schedule', 22, '2025-07-20 10:13:16'),
    (37, 1, 'Rescheduled Class', 'Schedule', 22, '2025-07-20 10:15:06'),
    (38, 1, 'Created Schedule', 'Schedule', 23, '2025-07-21 04:53:46'),
    (39, 1, 'Logged In', 'User', 1, '2025-07-21 05:26:55'),
    (40, 1, 'Logged In', 'User', 1, '2025-07-21 08:09:52'),
    (41, 1, 'Created Schedule', 'Schedule', 24, '2025-07-21 08:25:08'),
    (42, 1, 'Rescheduled Class', 'Schedule', 24, '2025-07-21 08:45:15'),
    (43, 1, 'Rescheduled Class', 'Schedule', 24, '2025-07-21 09:06:53'),
    (44, 1, 'Created Schedule', 'Schedule', 25, '2025-07-21 10:18:03'),
    (45, 1, 'Logged In', 'User', 1, '2025-07-21 14:30:14'),
    (46, 1, 'Logged In', 'User', 1, '2025-07-21 17:21:53'),
    (47, 1, 'Logged In', 'User', 1, '2025-07-22 16:29:21'),
    (48, 1, 'Rescheduled Class', 'Schedule', 10, '2025-07-22 16:35:44'),
    (49, 1, 'Logged In', 'User', 1, '2025-07-24 09:46:33'),
    (50, 1, 'Logged Out', 'User', 1, '2025-07-24 10:41:00'),
    (51, 1, 'Logged In', 'User', 1, '2025-07-24 10:43:21')
ON CONFLICT (id) DO NOTHING;

-- Reset sequences to match the inserted data
SELECT setval('admin_id_seq', (SELECT MAX(id) FROM admin));
SELECT setval('alembic_version_version_num_seq', 1, false);
SELECT setval('specializepath_id_seq', (SELECT MAX(id) FROM specializepath));
SELECT setval('program_id_seq', (SELECT MAX(id) FROM program));
SELECT setval('user_id_seq', (SELECT MAX(id) FROM "user"));
SELECT setval('lecturer_id_seq', (SELECT MAX(id) FROM lecturer));
SELECT setval('student_id_seq', (SELECT MAX(id) FROM student));
SELECT setval('module_id_seq', (SELECT MAX(id) FROM module));
SELECT setval('room_id_seq', (SELECT MAX(id) FROM room));
SELECT setval('schedule_id_seq', (SELECT MAX(id) FROM schedule));
SELECT setval('reschedule_id_seq', (SELECT MAX(id) FROM reschedule));
SELECT setval('audit_log_id_seq', (SELECT MAX(id) FROM audit_log));
