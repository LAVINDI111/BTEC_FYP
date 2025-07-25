-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.5.26-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for db_of_acnsms
CREATE DATABASE IF NOT EXISTS `db_of_acnsms` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `db_of_acnsms`;

-- Dumping structure for table db_of_acnsms.admin
CREATE TABLE IF NOT EXISTS `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fullName` varchar(100) NOT NULL,
  `adminId` varchar(20) NOT NULL,
  `email` varchar(120) NOT NULL,
  `phone` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `adminId` (`adminId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.admin: ~0 rows (approximately)
REPLACE INTO `admin` (`id`, `fullName`, `adminId`, `email`, `phone`) VALUES
	(1, 'System Administrator', 'ADM0001', 'admin@acnsms.com', '+1234567890');

-- Dumping structure for table db_of_acnsms.alembic_version
CREATE TABLE IF NOT EXISTS `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.alembic_version: ~1 rows (approximately)
REPLACE INTO `alembic_version` (`version_num`) VALUES
	('509093b497ef');

-- Dumping structure for table db_of_acnsms.attendance
CREATE TABLE IF NOT EXISTS `attendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `schedule_id` int(11) NOT NULL,
  `status` enum('Present','Absent','Excused') NOT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_id` (`student_id`,`schedule_id`),
  KEY `schedule_id` (`schedule_id`),
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
  CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.attendance: ~0 rows (approximately)

-- Dumping structure for table db_of_acnsms.audit_log
CREATE TABLE IF NOT EXISTS `audit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `target_type` varchar(50) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.audit_log: ~51 rows (approximately)
REPLACE INTO `audit_log` (`id`, `user_id`, `action`, `target_type`, `target_id`, `timestamp`) VALUES
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
	(51, 1, 'Logged In', 'User', 1, '2025-07-24 10:43:21');

-- Dumping structure for table db_of_acnsms.lecturer
CREATE TABLE IF NOT EXISTS `lecturer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fullName` varchar(100) NOT NULL,
  `lecturerId` varchar(20) NOT NULL,
  `email` varchar(120) NOT NULL,
  `phone` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lecturerId` (`lecturerId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.lecturer: ~6 rows (approximately)
REPLACE INTO `lecturer` (`id`, `fullName`, `lecturerId`, `email`, `phone`) VALUES
	(1, 'Dr. Sakunika Perera', 'DRS001', 'sankilavindi@gmail.com', '+94718296726'),
	(2, 'Prof. John Gunawardhana', 'PRJ001', 'nipunaber@gmail.com', '+94702511260'),
	(3, 'Ms. Chathuni De Silva', 'MSC001', 'gachirathdilshanedu@gmail.com', '+94784491594'),
	(4, 'Mr. Indunil Bandara', 'MRI001', 'chirathdilshan2003@gmail.com', '+94776427812'),
	(5, 'Prof. Chanaka Thilakarathne', 'PRC001', 'laviber411@gmail.com', '+94784497226'),
	(6, 'Mr. Prasanna Jayawarna', 'MRP001', 'chirathdilshanhp@gmail.com', '+94723497504');

-- Dumping structure for table db_of_acnsms.message_templates
CREATE TABLE IF NOT EXISTS `message_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `body_text` text NOT NULL,
  `body_html` text NOT NULL,
  `template_type` enum('schedule','reschedule','reminder') NOT NULL,
  `channel` enum('sms','email','both') NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.message_templates: ~0 rows (approximately)

-- Dumping structure for table db_of_acnsms.module
CREATE TABLE IF NOT EXISTS `module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `department` varchar(100) NOT NULL,
  `specializePath` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `programId` int(11) NOT NULL,
  `semester` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `programId` (`programId`),
  CONSTRAINT `module_ibfk_1` FOREIGN KEY (`programId`) REFERENCES `program` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.module: ~6 rows (approximately)
REPLACE INTO `module` (`id`, `department`, `specializePath`, `name`, `code`, `programId`, `semester`) VALUES
	(1, 'BTEC', 'SE', 'Software Engineering Basics', 'SE101', 3, 1),
	(2, 'BTEC', 'AI', 'Introduction to AI', 'AI201', 6, 2),
	(4, 'UH', 'DA', 'Programming Fundermentals', 'DA104', 2, 1),
	(5, 'CAIT', 'CC', 'Database Systems', 'AI105', 1, 1),
	(6, 'BTEC', 'SE', 'Web Development', 'CS106', 7, 2),
	(7, 'UH', 'NW', 'IOT', 'CC107', 5, 2);

-- Dumping structure for table db_of_acnsms.notification_log
CREATE TABLE IF NOT EXISTS `notification_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `schedule_id` int(11) DEFAULT NULL,
  `reschedule_id` int(11) DEFAULT NULL,
  `template_id` int(11) NOT NULL,
  `channel` enum('sms','email') NOT NULL,
  `sent_at` datetime DEFAULT NULL,
  `status` enum('sent','failed','pending') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `schedule_id` (`schedule_id`),
  KEY `reschedule_id` (`reschedule_id`),
  KEY `template_id` (`template_id`),
  CONSTRAINT `notification_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `notification_log_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`),
  CONSTRAINT `notification_log_ibfk_3` FOREIGN KEY (`reschedule_id`) REFERENCES `reschedule` (`id`),
  CONSTRAINT `notification_log_ibfk_4` FOREIGN KEY (`template_id`) REFERENCES `message_templates` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.notification_log: ~0 rows (approximately)

-- Dumping structure for table db_of_acnsms.program
CREATE TABLE IF NOT EXISTS `program` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` enum('Degree','HND','Certificate') DEFAULT NULL,
  `mode` enum('weekday','weekend') NOT NULL,
  `department` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.program: ~7 rows (approximately)
REPLACE INTO `program` (`id`, `name`, `type`, `mode`, `department`) VALUES
	(1, 'HND in Computer Science', 'HND', 'weekday', 'BTEC'),
	(2, 'BTEC HND in Computing', 'HND', 'weekend', 'BTEC'),
	(3, 'HND in Software Engineering', 'HND', 'weekday', 'BTEC'),
	(4, 'HND in Computer Science', 'HND', 'weekend', 'BTEC'),
	(5, 'BSc in EEE', 'Degree', 'weekday', 'UH'),
	(6, 'BSc in AI', 'Degree', 'weekend', 'UH'),
	(7, 'Certificate in Computer Science', 'Certificate', 'weekend', 'CAIT');

-- Dumping structure for table db_of_acnsms.reschedule
CREATE TABLE IF NOT EXISTS `reschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `schedule_id` int(11) NOT NULL,
  `old_date` date NOT NULL,
  `old_start_time` time NOT NULL,
  `old_end_time` time NOT NULL,
  `new_date` date NOT NULL,
  `new_start_time` time NOT NULL,
  `new_end_time` time NOT NULL,
  `reason` text NOT NULL,
  `updated_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `google_calendar_link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_id` (`schedule_id`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `reschedule_ibfk_1` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`id`),
  CONSTRAINT `reschedule_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.reschedule: ~4 rows (approximately)
REPLACE INTO `reschedule` (`id`, `schedule_id`, `old_date`, `old_start_time`, `old_end_time`, `new_date`, `new_start_time`, `new_end_time`, `reason`, `updated_by`, `updated_at`, `google_calendar_link`) VALUES
	(1, 22, '2025-07-06', '09:00:00', '12:00:00', '2025-07-13', '09:00:00', '05:00:00', 'have another exam in that class room', 1, '2025-07-20 10:15:06', NULL),
	(2, 24, '2025-08-08', '09:00:00', '12:00:00', '2025-08-28', '09:00:00', '12:00:00', '', 1, '2025-07-21 08:45:15', NULL),
	(3, 24, '2025-08-28', '09:00:00', '12:00:00', '2025-08-28', '03:00:00', '05:00:00', 'personal matter', 1, '2025-07-21 09:06:53', NULL),
	(4, 10, '2025-08-03', '09:00:00', '05:00:00', '2025-08-21', '09:00:00', '12:00:00', '', 1, '2025-07-22 16:35:44', NULL);

-- Dumping structure for table db_of_acnsms.room
CREATE TABLE IF NOT EXISTS `room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `capacity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.room: ~14 rows (approximately)
REPLACE INTO `room` (`id`, `name`, `capacity`) VALUES
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
	(14, 'E\'tronic lab', 25);

-- Dumping structure for table db_of_acnsms.schedule
CREATE TABLE IF NOT EXISTS `schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `subject` varchar(100) NOT NULL,
  `status` enum('Scheduled','Completed','Cancelled') NOT NULL,
  `google_calendar_link` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `room_id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `room_id` (`room_id`),
  KEY `lecturer_id` (`lecturer_id`),
  KEY `program_id` (`program_id`),
  KEY `module_id` (`module_id`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`),
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`lecturer_id`) REFERENCES `user` (`id`),
  CONSTRAINT `schedule_ibfk_3` FOREIGN KEY (`program_id`) REFERENCES `program` (`id`),
  CONSTRAINT `schedule_ibfk_4` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.schedule: ~9 rows (approximately)
REPLACE INTO `schedule` (`id`, `date`, `start_time`, `end_time`, `subject`, `status`, `google_calendar_link`, `created_at`, `room_id`, `lecturer_id`, `program_id`, `module_id`) VALUES
	(10, '2025-08-21', '09:00:00', '12:00:00', '(auto)', 'Scheduled', NULL, '2025-07-16 12:26:15', 1, 1, 1, 1),
	(15, '2025-09-06', '06:00:00', '07:00:00', '(auto)', 'Scheduled', NULL, '2025-07-17 07:56:44', 4, 1, 1, 1),
	(17, '2025-08-07', '09:00:00', '12:00:00', '(auto)', 'Scheduled', NULL, '2025-07-17 08:01:25', 1, 1, 1, 1),
	(19, '2025-07-06', '08:00:00', '01:00:00', '(auto)', 'Scheduled', NULL, '2025-07-17 08:27:15', 12, 1, 3, 1),
	(21, '2025-07-06', '09:00:00', '10:00:00', 'mache lerning and ai', 'Scheduled', NULL, '2025-07-19 05:33:57', 12, 1, 2, 4),
	(22, '2025-07-13', '09:00:00', '05:00:00', 'java fundermendal', 'Scheduled', NULL, '2025-07-20 10:13:16', 3, 1, 2, 2),
	(23, '2025-05-18', '08:00:00', '10:00:00', 'AI & ML', 'Scheduled', NULL, '2025-07-21 04:53:46', 12, 1, 6, 1),
	(24, '2025-08-28', '03:00:00', '05:00:00', 'business interligent', 'Scheduled', NULL, '2025-07-21 08:25:08', 1, 1, 2, 1),
	(25, '2025-09-07', '07:00:00', '09:00:00', 'abc', 'Scheduled', NULL, '2025-07-21 10:18:03', 1, 1, 1, 7);

-- Dumping structure for table db_of_acnsms.specializepath
CREATE TABLE IF NOT EXISTS `specializepath` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pathCode` varchar(20) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pathCode` (`pathCode`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.specializepath: ~7 rows (approximately)
REPLACE INTO `specializepath` (`id`, `pathCode`, `name`) VALUES
	(1, 'AI', 'Artificial Intelligence'),
	(2, 'SE', 'Software Engineering'),
	(3, 'CY', 'Cybersecurity'),
	(4, 'DA', 'Data Analytics'),
	(5, 'EEE', 'Electrical & Electronic Engineering'),
	(6, 'GD', 'Game Development'),
	(7, 'NW', 'Networking');

-- Dumping structure for table db_of_acnsms.student
CREATE TABLE IF NOT EXISTS `student` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `sfId` varchar(20) NOT NULL,
  `email` varchar(120) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `department` varchar(100) NOT NULL,
  `specializePath` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sfId` (`sfId`),
  KEY `userId` (`userId`),
  KEY `fk_student_specializePath` (`specializePath`),
  CONSTRAINT `fk_student_specializePath` FOREIGN KEY (`specializePath`) REFERENCES `specializepath` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.student: ~0 rows (approximately)
REPLACE INTO `student` (`id`, `userId`, `sfId`, `email`, `phone`, `department`, `specializePath`) VALUES
	(1, 2, 'SF0002', 'Laviber411@gmail.com', '0702511260', 'BTEC', 3);

-- Dumping structure for table db_of_acnsms.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userName` varchar(80) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `role` enum('student','lecturer','admin') NOT NULL,
  `department` varchar(100) NOT NULL,
  `fName` varchar(50) NOT NULL,
  `lName` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userName` (`userName`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table db_of_acnsms.user: ~2 rows (approximately)
REPLACE INTO `user` (`id`, `userName`, `email`, `password_hash`, `phone`, `role`, `department`, `fName`, `lName`, `created_at`) VALUES
	(1, 'admin', 'admin@acnsms.com', 'pbkdf2:sha256:600000$3HTJirpJTzYKxeqn$73ef77fd1e3660ec31d08323cbf6935bf1d556871046a0895c7805cab59c9b22', '+1234567890', 'admin', 'administration', 'System', 'Administrator', '2025-07-14 07:26:39'),
	(2, 'Tharu@2007', 'Laviber411@gmail.com', 'pbkdf2:sha256:600000$M9WaupTzHG8kYm2D$d38c07585f42c233bdc98e098e6ae4e322612c4e30d7e1c318af566d94d848cd', '0702511260', 'student', 'BTEC', 'Tharumini', 'Nawavickrama', '2025-07-14 07:36:18');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
