-- Use your database
USE db_of_acnsms;

-- User Table
INSERT INTO user (username, email, password_hash, phone, role, department) VALUES ('lavindi', 'LavindiNawavickrama@example.com', 'hashed_pw1', '0771234567', 'admin', 'Administration');
INSERT INTO user (username, email, password_hash, phone, role, department) VALUES ('sakunika', 'sakunika@example.com', 'hashed_pw2', '0772345678', 'lecturer', 'BTEC');
INSERT INTO user (username, email, password_hash, phone, role, department) VALUES ('nipuna', 'nipunaber@gmail.com', 'hashed_pw3', '0773456789', 'student', 'BTEC');
INSERT INTO user (username, email, password_hash, phone, role, department) VALUES ('sonali', 'sonaliyagoda@gmail.com', 'hashed_pw4', '0774567890', 'student', 'CAIT');message_templatesmodulemoduleprogramroomroom

-- Room Table
INSERT INTO room (name, capacity, department) VALUES ('Auditorium', 200, 'UH');
INSERT INTO room (name, capacity, department) VALUES ('LR1', 70, 'UH');
INSERT INTO room (name, capacity, department) VALUES ('LR2', 30, 'UH');
INSERT INTO room (name, capacity, department) VALUES ('LR3', 40, 'UH');
INSERT INTO room (name, capacity, department) VALUES ('LR4', 35, 'UH');
INSERT INTO room (name, capacity, department) VALUES ('LR5', 30, 'UH');
INSERT INTO room (name, capacity, department) VALUES ('LR6', 75, 'UH');
INSERT INTO room (name, capacity, department) VALUES ('Com Lab 1', 40, 'BTEC');
INSERT INTO room (name, capacity, department) VALUES ('Com Lab 2', 30, 'BTEC');
INSERT INTO room (name, capacity, department) VALUES ('Com Lab 3', 25, 'BTEC');
INSERT INTO room (name, capacity, department) VALUES ('DSM Lab', 24, 'CAIT');
INSERT INTO room (name, capacity, department) VALUES ('DC Lab', 30, 'CAIT');
INSERT INTO room (name, capacity, department) VALUES ('CSP Lab', 25, 'CAIT');
INSERT INTO room (name, capacity, department) VALUES ('E''tronic Lab', 25, 'CAIT');

-- Program Table
INSERT INTO program (name, type, mode, department) VALUES ('UH Program', 'Degree', 'Weekday', 'UH');
INSERT INTO program (name, type, mode, department) VALUES ('BTEC Program', 'HND', 'Weekend', 'BTEC');
INSERT INTO program (name, type, mode, department) VALUES ('CAIT Program', 'CAIT', 'Weekday', 'CAIT');
INSERT INTO program (name, type, mode, department) VALUES ('BTEC Foundation', 'HND', 'Weekday', 'BTEC');

-- Module Table
INSERT INTO module (name, code, program_id, semester) VALUES ('Intro to UH', 'UH101', 1, 1);
INSERT INTO module (name, code, program_id, semester) VALUES ('BTEC DT 23–25', 'BTEC102', 2, 1);
INSERT INTO module (name, code, program_id, semester) VALUES ('CAIT Basics', 'CAIT103', 3, 1);
INSERT INTO module (name, code, program_id, semester) VALUES ('Foundation Module', 'BTEC104', 4, 1);

-- Schedule Table (Based on Screenshot)
INSERT INTO schedule (subject, lecturer_id, room_id, program_id, module_id, date, start_time, end_time, status, google_calendar_link)
VALUES ('BTEC DT 23–25', 2, 10, 2, 2, '2025-06-15', '09:00:00', '17:00:00', 'Scheduled', 'https://meet.google.com/gwa-pcgy-aof');

-- Message Templates
INSERT INTO message_templates (name, subject, body_text, body_html, template_type, channel, is_active) VALUES
('Schedule Email', 'Class Scheduled', 'Your class {{subject}} is on {{date}} at {{start_time}} in {{room}}.', '<p>Your class <strong>{{subject}}</strong> is scheduled for <strong>{{date}}</strong> at <strong>{{start_time}}</strong> in <strong>{{room}}</strong>.</p>', 'schedule', 'email', TRUE);

INSERT INTO message_templates (name, subject, body_text, body_html, template_type, channel, is_active) VALUES
('Schedule SMS', 'Class Scheduled', 'Class {{subject}} on {{date}} at {{start_time}} in {{room}}.', '', 'schedule', 'sms', TRUE);
