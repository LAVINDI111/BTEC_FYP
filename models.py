"""
ACNSMS - Database Models
Defines all database tables and relationships
"""

from datetime import datetime
from flask_login import UserMixin
from extensions import db  # Import shared db instance

# ----------------------------------
# Main User Table
# ----------------------------------
class User(UserMixin, db.Model):
    __tablename__ = 'user'

    id = db.Column(db.Integer, primary_key=True)
    userName = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    role = db.Column(db.Enum('student', 'lecturer', 'admin'), nullable=False)
    department = db.Column(db.String(100), nullable=False)
    fName = db.Column(db.String(50), nullable=False)
    lName = db.Column(db.String(50), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # Relationships
    #schedules = db.relationship('Schedule', backref='lecturer', lazy=True)
    schedules = db.relationship('Schedule', back_populates='lecturer', lazy=True)
    reschedules = db.relationship('Reschedule', backref='updated_by_user', lazy=True)
    audit_logs = db.relationship('AuditLog', backref='user', lazy=True)
    notifications = db.relationship('NotificationLog', backref='user', lazy=True)
    
# ----------------------------------
# Role-Specific Tables
# ----------------------------------
class Admin(db.Model):
    __tablename__ = 'admin'
    id = db.Column(db.Integer, primary_key=True)
    fullName = db.Column(db.String(100), nullable=False)
    adminId = db.Column(db.String(20), unique=True, nullable=False)
    email = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(20), nullable=False)

class Lecturer(db.Model):
    __tablename__ = 'lecturer'
    id = db.Column(db.Integer, primary_key=True)
    fullName = db.Column(db.String(100), nullable=False)
    lecturerId = db.Column(db.String(20), unique=True, nullable=False)
    email = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(20), nullable=False)

class Student(db.Model):
    __tablename__ = 'student'
    id = db.Column(db.Integer, primary_key=True)
    userId = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    sfId = db.Column(db.String(20), unique=True, nullable=False)
    email = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    department = db.Column(db.String(100), nullable=False)
    specializePath = db.Column(db.String(50), nullable=False)

    # Relationships
    attendances = db.relationship('Attendance', backref='student', cascade="all, delete-orphan", lazy=True)

# ----------------------------------
# Academic Structure
# ----------------------------------
class Room(db.Model):
    __tablename__ = 'room'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    capacity = db.Column(db.Integer, nullable=False)

    # Relationship
    #schedules = db.relationship('Schedule', backref='room', lazy=True)
    schedules = db.relationship('Schedule', back_populates='room', lazy=True)


    def __repr__(self):
        return f"<Room {self.id} - {self.name} ({self.capacity} seats)>"

class Program(db.Model):
    __tablename__ = 'program'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    type = db.Column(db.Enum('Degree', 'HND', 'Certificate', ), nullable=False)
    mode = db.Column(db.Enum('weekday', 'weekend'), nullable=False)
    department = db.Column(db.String(100), nullable=False)

    # Relationships
    modules = db.relationship('Module', backref='program', lazy=True)
    schedules = db.relationship('Schedule', back_populates='program', lazy=True)
    #schedules = db.relationship('Schedule', backref='program', lazy=True)

class SpecializePath(db.Model):
    __tablename__ = 'specializePath'
    id = db.Column(db.Integer, primary_key=True)
    pathCode = db.Column(db.String(20), unique=True, nullable=False)

class Module(db.Model):
    __tablename__ = 'module'
    id = db.Column(db.Integer, primary_key=True)
    department = db.Column(db.String(100), nullable=False)
    specializePath = db.Column(db.String(50), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    code = db.Column(db.String(20), unique=True, nullable=False)
    programId = db.Column(db.Integer, db.ForeignKey('program.id'), nullable=False)
    semester = db.Column(db.Integer, nullable=False)

    # Relationship
    schedules = db.relationship('Schedule', back_populates='module', lazy=True)
    #schedules = db.relationship('Schedule', backref='module', lazy=True)

# ----------------------------------
# Scheduling & Rescheduling
# ----------------------------------
class Schedule(db.Model):
    __tablename__ = 'schedule'
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.Date, nullable=False)
    start_time = db.Column(db.Time, nullable=False)
    end_time = db.Column(db.Time, nullable=False)
    subject = db.Column(db.String(100), nullable=False)
    status = db.Column(db.Enum('Scheduled', 'Completed', 'Cancelled'), nullable=False, default='Scheduled')
    google_calendar_link = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # Foreign Keys
    room_id = db.Column(db.Integer, db.ForeignKey('room.id'), nullable=False)
    lecturer_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    program_id = db.Column(db.Integer, db.ForeignKey('program.id'), nullable=False)
    module_id = db.Column(db.Integer, db.ForeignKey('module.id'), nullable=False)
    

    # Relationships
    reschedules = db.relationship('Reschedule', backref='schedule', lazy=True)
    attendances = db.relationship('Attendance', backref='schedule', cascade="all, delete-orphan", lazy=True)
    notifications = db.relationship('NotificationLog', backref='schedule', lazy=True)
    #lecturer = db.relationship('User', backref='lecturer_schedules')  # ✅ ADD this
    lecturer = db.relationship('User', back_populates='schedules')
    #room = db.relationship('Room', backref='schedules')
    room = db.relationship('Room', back_populates='schedules')
    #program = db.relationship('Program', backref='schedules')
    program = db.relationship('Program', back_populates='schedules')
    module = db.relationship('Module', back_populates='schedules')
    # module = db.relationship('Module', backref='schedules')
    def to_dict(self):
        return {
            "id": self.id,
            "date": self.date.strftime('%Y-%m-%d'),
            "start_time": self.start_time.strftime('%H:%M'),
            "end_time": self.end_time.strftime('%H:%M'),
            "subject": self.subject,
            "lecturer": f"{self.lecturer.fName} {self.lecturer.lName}" if self.lecturer else "Unknown",
            "room": self.room.name if self.room else "Unknown",
            "program": self.program.name if self.program else "Unknown",
            "status": self.status
    }





class Reschedule(db.Model):
    __tablename__ = 'reschedule'
    id = db.Column(db.Integer, primary_key=True)
    schedule_id = db.Column(db.Integer, db.ForeignKey('schedule.id'), nullable=False)

    old_date = db.Column(db.Date, nullable=False)
    old_start_time = db.Column(db.Time, nullable=False)
    old_end_time = db.Column(db.Time, nullable=False)
    new_date = db.Column(db.Date, nullable=False)
    new_start_time = db.Column(db.Time, nullable=False)
    new_end_time = db.Column(db.Time, nullable=False)
    reason = db.Column(db.Text, nullable=False)

    updated_by = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow)
    google_calendar_link = db.Column(db.String(255))

    # Relationship
    notifications = db.relationship('NotificationLog', backref='reschedule', lazy=True)

# ----------------------------------
# Notifications & Templates
# ----------------------------------
class MessageTemplates(db.Model):
    __tablename__ = 'message_templates'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    subject = db.Column(db.String(200), nullable=False)
    body_text = db.Column(db.Text, nullable=False)
    body_html = db.Column(db.Text, nullable=False)
    template_type = db.Column(db.Enum('schedule', 'reschedule', 'reminder'), nullable=False)
    channel = db.Column(db.Enum('sms', 'email', 'both'), nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)

    # Relationship
    logs = db.relationship('NotificationLog', backref='template', lazy=True)

class NotificationLog(db.Model):
    __tablename__ = 'notification_log'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    schedule_id = db.Column(db.Integer, db.ForeignKey('schedule.id'))
    reschedule_id = db.Column(db.Integer, db.ForeignKey('reschedule.id'))
    template_id = db.Column(db.Integer, db.ForeignKey('message_templates.id'), nullable=False)
    channel = db.Column(db.Enum('sms', 'email'), nullable=False)
    sent_at = db.Column(db.DateTime, default=datetime.utcnow)
    status = db.Column(db.Enum('sent', 'failed', 'pending'), nullable=False)

# ----------------------------------
# Attendance & Auditing
# ----------------------------------
class Attendance(db.Model):
    __tablename__ = 'attendance'
    __table_args__ = (
        db.UniqueConstraint('student_id', 'schedule_id'),
        {'mysql_engine': 'InnoDB'}
    )

    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('student.id'), nullable=False)
    schedule_id = db.Column(db.Integer, db.ForeignKey('schedule.id'), nullable=False)
    status = db.Column(db.Enum('Present', 'Absent', 'Excused'), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)


class AuditLog(db.Model):
    __tablename__ = 'audit_log'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    action = db.Column(db.String(255), nullable=False)
    target_type = db.Column(db.String(50))  # e.g., 'User', 'Schedule'
    target_id = db.Column(db.Integer)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
