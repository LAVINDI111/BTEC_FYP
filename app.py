"""
ACNSMS - Automated Campus Notification and Schedule Management System
Main Flask Application File
"""

import time
from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
from flask_login import LoginManager, login_user, logout_user, login_required, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime,timedelta
from flask_migrate import Migrate
from extensions import db, login_manager
from models import *
import os
from config import config
from sqlalchemy.orm import joinedload
from app import User
from reSchedule_email_sender import send_reschedule_email


# Create the Flask app
app = Flask(__name__)
config_name = os.environ.get('FLASK_ENV', 'development')
app.config.from_object(config[config_name])

# Initialize extensions
db.init_app(app)
login_manager.init_app(app)
login_manager.login_view = 'login'

# Initialize Flask-Migrate
migrate = Migrate(app, db)

# User loader for Flask-Login
@login_manager.user_loader
def load_user(user_id):
    #return User.query.get(int(user_id)) ##21
    return db.session.get(User, int(user_id))


@app.route('/')
def home():
    return render_template('home.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = User.query.filter_by(userName=username).first()

        if user and check_password_hash(user.password_hash, password):
            login_user(user)
            flash('Login successful!', 'success')
            log = AuditLog(user_id=user.id, action='Logged In', target_type='User', target_id=user.id)
            db.session.add(log)
            db.session.commit()
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid username or password!', 'error')
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        fname = request.form['fname']
        lname = request.form['lname']
        username = request.form['username']
        email = request.form['email']
        phone = request.form['phone']
        role = request.form['role']
        department = request.form['department']
        password = request.form['password']
        specialize_path = request.form.get('specializePath', '')

        if User.query.filter_by(userName=username).first():
            flash('Username already exists!', 'error')
            return render_template('register.html')
        if User.query.filter_by(email=email).first():
            flash('Email already registered!', 'error')
            return render_template('register.html')

        password_hash = generate_password_hash(password)
        new_user = User(
            userName=username,
            email=email,
            password_hash=password_hash,
            phone=phone,
            role=role,
            department=department,
            fName=fname,
            lName=lname
        )

        try:
            db.session.add(new_user)
            db.session.flush() 
            db.session.commit()

            if role == 'student':
                specialize_path = request.form.get('specializePath', '')
                program_id = request.form.get('programId')
                module_id = request.form.get('moduleId')

                # 🛡️ Check if student already exists
                #existing_student = Student.query.filter_by(userId=new_user.id).first()
                #if existing_student:
                    #flash('Student already exists for this user!', 'error')
                    #return render_template('register.html')
                
                if not specialize_path:
                    flash("Specialization path required for students", "error")
                    return render_template('register.html')
                student = Student(
                    userId=new_user.id,
                    sfId=f"SF{new_user.id:04d}",
                    email=email,
                    phone=phone,
                    department=department,
                    specializePath=specialize_path
                )
                db.session.add(student)
                
            elif role == 'lecturer':
                lecturer = Lecturer(
                    fullName=f"{fname} {lname}",
                    lecturerId=f"LEC{new_user.id:04d}",
                    email=email,
                    phone=phone
                )
                db.session.add(lecturer)

            elif role == 'admin':
                admin = Admin(
                    fullName=f"{fname} {lname}",
                    adminId=f"ADM{new_user.id:04d}",
                    email=email,
                    phone=phone
                )
                db.session.add(admin)

            db.session.commit()
            flash('Registration successful! Please login.', 'success')

            log = AuditLog(
                user_id=new_user.id,
                action='User Registered',
                target_type='User',
                target_id=new_user.id
            )
            db.session.add(log)
            db.session.commit()
            flash('Registration successful! Please login.', 'success')
            return redirect(url_for('login'))

        except Exception as e:
            db.session.rollback()
            print(f"Registration error: {e}")  # 👈 check terminal carefully
            flash('Registration failed. Please try again.', 'error')
            print(f"Registration error: {e}")
    return render_template('register.html')

@app.route('/dashboard')
@login_required
def dashboard():
    if current_user.role == 'admin':
        return render_template('dashboard/admin.html')
    elif current_user.role == 'lecturer':
        return render_template('dashboard/lecturer.html')
    else:
        return render_template('dashboard/student.html')

@app.route('/logout')
@login_required
def logout():
    log = AuditLog(user_id=current_user.id, action='Logged Out', target_type='User', target_id=current_user.id)
    db.session.add(log)
    db.session.commit()
    logout_user()
    flash('You have been logged out.', 'info')
    return redirect(url_for('home'))

@app.route('/schedules')
@login_required
def schedules():
    schedules = Schedule.query.all()
    return render_template('schedules.html', schedules=schedules)

@app.route('/api/schedules', methods=['GET', 'POST'])
@login_required
def api_schedules():
    if request.method == 'POST':
        data = request.get_json()
        print(data)
        schedule = Schedule(
            date=datetime.strptime(data['date'], '%Y-%m-%d'),
            start_time=datetime.strptime(data['start_time'], '%H:%M').time(),
            end_time=datetime.strptime(data['end_time'], '%H:%M').time(),
            #subject="(auto)",
            subject=data.get('subject', '(auto)'),
            status='Scheduled',
            room_id=int(data['room_id']),
            lecturer_id=int(data.get('lecturer')),
            program_id=int(data['program_id']),
            module_id=int(data['module_id'])
        )
        db.session.add(schedule)
        db.session.flush()
        print("schedule.................")
        db.session.commit()

        log = AuditLog(
            user_id=current_user.id,
            action='Created Schedule',
            target_type='Schedule',
            target_id=schedule.id
        )
        db.session.add(log)
        db.session.commit()

        module = Module.query.get(schedule.module_id)#----------------------------
        room = Room.query.get(schedule.room_id)#----------------------------

        #-----------------return jsonify({'success': True, 'message': 'Schedule created successfully'})
    ##########################################    
        return jsonify({
            'success': True,
            'schedule': {
                'date': schedule.date.strftime('%d/%m/%Y'),
                'start_time': schedule.start_time.strftime('%H:%M'),
                'end_time': schedule.end_time.strftime('%H:%M'),
                'module_name': module.name,
                'room_name': room.name,
                'status': schedule.status
            }
        })
    ######################################## 21
    #else:
        #schedules = Schedule.query.all()
        #return jsonify([{
            #'id': s.id,
            #'date': s.date.strftime('%Y-%m-%d'),
            #'start_time': s.start_time.strftime('%H:%M'),
            #'end_time': s.end_time.strftime('%H:%M'),
            #'subject': s.subject,
            #'status': s.status
        #} for s in schedules])
    else:
        schedules = Schedule.query.options(
            joinedload(Schedule.room),
            joinedload(Schedule.program),
            joinedload(Schedule.module)
    ).all()

    result = []
    for s in schedules:
        lecturer = Lecturer.query.get(s.lecturer_id) if s.lecturer_id else None
        result.append({
            'id': s.id,
            'date': s.date.strftime('%a, %b %d, %Y'),
            'start_time': s.start_time.strftime('%H:%M'),
            'end_time': s.end_time.strftime('%H:%M'),
            'subject': s.module.name if s.module else '(no module)',
            'lecturer': f"{lecturer.fullName}" if lecturer else 'Unknown',
            'room': s.room.name if s.room else 'Unknown',
            'program': s.program.name if s.program else 'Unknown',
            'status': s.status if s.status else 'Scheduled'
        })
    return jsonify(result)
    

@app.route('/attendance')
@login_required
def attendance():
    if current_user.role not in ['admin', 'lecturer']:
        flash("Access denied!", "danger")
        return redirect(url_for('dashboard'))
    records = Attendance.query.all()
    return render_template('attendance.html', attendance_records=records)

@app.route('/audit-log')
@login_required
def audit_log():
    if current_user.role != 'admin':
        flash("Admins only!", "danger")
        return redirect(url_for('dashboard'))
    logs = AuditLog.query.order_by(AuditLog.timestamp.desc()).all()
    return render_template('audit_log.html', audit_logs=logs)

# Adding route to get a specific schedule

@app.route('/api/schedule/<int:schedule_id>', methods=['GET'])
def get_schedule(schedule_id):
    schedule = db.session.get(Schedule, schedule_id)
    if not schedule:
        return jsonify({'error': 'Schedule not found'}), 404
    return jsonify({
        'id': schedule.id,
        'date': schedule.date.strftime('%Y-%m-%d'),
        'start_time': schedule.start_time.strftime('%H:%M'),
        'end_time': schedule.end_time.strftime('%H:%M'),
        'subject': schedule.subject,
        'notes': getattr(schedule, 'notes', '')  # Safely get notes or return empty string
    })


# route for reschedule

@app.route('/api/reschedule', methods=['POST'])
#@app.route('/reschedule', methods=['POST'])
@login_required
def reschedule_schedule():
    print("🚀 /api/reschedule triggered")  # STEP 1: ENTRY POINT
    data = request.get_json()
    schedule_id = int(data['schedule_id'])
    new_date = datetime.strptime(data['date'], '%Y-%m-%d').date()
    new_start = datetime.strptime(data['start_time'], '%H:%M').time()
    new_end = datetime.strptime(data['end_time'], '%H:%M').time()
    # new raw after adding reschedule
    reason = data.get('reason', 'No reason provided')


    schedule = Schedule.query.get(schedule_id)
    if not schedule:
        print("❌ Schedule not found")
        return jsonify({"success": False, "message": "Schedule not found."})
        #return jsonify({'error': 'Schedule not found'}), 404

    # Save old values before updating
    old_date = schedule.date
    old_start = schedule.start_time
    old_end = schedule.end_time

    # Check for conflicts (same room, date, overlapping time)
    conflict = Schedule.query.filter(
        Schedule.room_id == schedule.room_id,
        Schedule.date == new_date,
        Schedule.id != schedule_id,
        Schedule.start_time < new_end,
        Schedule.end_time > new_start
    ).first()

    if conflict:
        print("❌ Conflict detected:", conflict)
        return jsonify({
            "success": False,
            "message": f"Conflict: Room already booked from {conflict.start_time.strftime('%H:%M')} to {conflict.end_time.strftime('%H:%M')}"
        })
    
    # # Save reschedule record ##
    reschedule = Reschedule(
        schedule_id=schedule.id,
        old_date=schedule.date,
        old_start_time=schedule.start_time,
        old_end_time=schedule.end_time,
        new_date=new_date,
        new_start_time=new_start,
        new_end_time=new_end,
        reason=reason,
        updated_by=current_user.id
    )
    db.session.add(reschedule)

    # Update Schedule
    schedule.date = new_date
    schedule.start_time = new_start
    schedule.end_time = new_end
    db.session.commit()

    # Get related module and program
    module = Module.query.get(schedule.module_id)
    room = Room.query.get(schedule.room_id)
    lecturer = Lecturer.query.get(schedule.lecturer_id)
    program = Program.query.get(schedule.program_id)

    print("📌 Rescheduling:", module.name, room.name, lecturer.fullName, program.name)

    # Fetch all students who belong to this program or department
    #students = Student.query.filter_by(department=program.name).all()
    students = Student.query.join(User).filter(Student.department.ilike(program.name)).all()
    recipient_emails = [student.email for student in students]
    bcc_emails = ['admin@acnsms.com']

    print(f"📧 Students found: {len(students)}")
    for s in students:
        print(f"🔗 Matched student: {s.email}, Dept: {s.department}")


    # send emails
    for recipient in recipient_emails:
        try:
            print(f"📤 Sending email to {recipient} for module {module.name}")
            send_reschedule_email(
                subject_t=f"⏰ Class Reschedule Notification - {module.name}",
                subject=module.name,
                r_email=recipient,
                BCC_email=", ".join(bcc_emails),
                module_id=module.name,
                old_date=old_date.strftime('%Y-%m-%d'),
                new_date=new_date.strftime('%Y-%m-%d'),
                new_start_time=new_start.strftime('%H:%M'),
                new_end_time=new_end.strftime('%H:%M'),
                room_id=room.name,
                lecturer_id=lecturer.fullName,
                reason=reason
            )
            print(f"✅ Email sent to {recipient}")
        except Exception as e:
            print(f"❌ Failed to send email to {recipient}: {str(e)}")


    # Log the change
    log = AuditLog(
        user_id=current_user.id,
        action='Rescheduled Class',
        target_type='Schedule',
        target_id=schedule.id
    )
    db.session.add(log)
    db.session.commit()

    return jsonify({
    "success": True,
    "message": "Schedule updated successfully."
    #send_reschedule_email()

    })

    #return jsonify({'message': 'Rescheduled successfully'})

# end of reschedule route 

@app.route('/api/reschedule/suggestions', methods=['POST'])
@login_required
def get_reschedule_suggestions():
    data = request.get_json()
    schedule_id = int(data['schedule_id'])
    preferred_date = datetime.strptime(data['date'], '%Y-%m-%d').date()
    
    # Get the original schedule
    schedule = Schedule.query.get(schedule_id)
    if not schedule:
        return jsonify({"success": False, "message": "Schedule not found."})
    
    # Calculate original duration
    dummy_date = datetime(2023, 1, 1).date()  # Use a fixed date for time calculations
    original_start_dt = datetime.combine(dummy_date, schedule.start_time)
    original_end_dt = datetime.combine(dummy_date, schedule.end_time)
    
    # Handle case where end_time might be on next day (crosses midnight)
    if schedule.end_time <= schedule.start_time and schedule.start_time > time(0, 0):
        original_end_dt = datetime.combine(dummy_date + timedelta(days=1), schedule.end_time)
    
    duration = original_end_dt - original_start_dt
    
    # Get lecturer's busy slots on the preferred date
    lecturer_busy_slots = Schedule.query.filter(
        Schedule.lecturer_id == schedule.lecturer_id,
        Schedule.date == preferred_date,
        Schedule.id != schedule_id  # Exclude the current schedule
    ).all()
    
    # Get all rooms
    rooms = Room.query.all()
    
    # Generate time suggestions (using original duration)
    suggestions = []
    start_hour = 8
    end_hour = 18
    
    # Create time slots with original duration, incrementing by 30 minutes
    time_slots = []
    current_start = datetime.strptime(f"{start_hour:02d}:00", "%H:%M").time()
    
    while current_start.hour < end_hour:
        slot_start = current_start
        # Calculate end time based on original duration
        slot_start_dt = datetime.combine(dummy_date, slot_start)
        slot_end_dt = slot_start_dt + duration
        slot_end = slot_end_dt.time()
        
        # Check if the slot is within working hours
        if slot_end.hour < end_hour or (slot_end.hour == end_hour and slot_end.minute == 0):
            time_slots.append((slot_start, slot_end))
        
        # Move to next 30-minute slot
        current_start_dt = datetime.combine(dummy_date, current_start)
        current_start_dt += timedelta(minutes=30)
        current_start = current_start_dt.time()
        
        # Break if we've gone past end of day
        if current_start.hour >= end_hour:
            break
    
    # Check each time slot for availability
    for start_time, end_time in time_slots:
        # Check if lecturer is available
        lecturer_available = True
        for busy_slot in lecturer_busy_slots:
            if (start_time < busy_slot.end_time and end_time > busy_slot.start_time):
                lecturer_available = False
                break
        
        if lecturer_available:
            # Find available rooms for this time slot
            available_rooms = []
            for room in rooms:
                # Check if room is available
                room_conflict = Schedule.query.filter(
                    Schedule.room_id == room.id,
                    Schedule.date == preferred_date,
                    Schedule.start_time < end_time,
                    Schedule.end_time > start_time
                ).first()
                
                if not room_conflict:
                    available_rooms.append({
                        'id': room.id,
                        'name': room.name,
                        'capacity': room.capacity
                    })
            
            # Sort rooms by capacity (closest to original room's capacity)
            original_room = Room.query.get(schedule.room_id)
            if original_room:
                available_rooms.sort(key=lambda x: abs(x['capacity'] - original_room.capacity))
            
            if available_rooms:
                suggestions.append({
                    'date': preferred_date.strftime('%Y-%m-%d'),
                    'start_time': start_time.strftime('%H:%M'),
                    'end_time': end_time.strftime('%H:%M'),
                    'rooms': available_rooms[:3]  # Limit to top 3 rooms
                })
    
    return jsonify({
        "success": True,
        "suggestions": suggestions[:5]  # Limit to top 5 time suggestions
    })

# 21_ return data lecturer/room/modules/program
@app.route('/api/lecturers', methods=['GET'])
def get_lecturers():
    lecturers = Lecturer.query.all()
    return jsonify([
        {
            'id': lec.id,
            'name': lec.fullName
        } for lec in lecturers
    ])

# --- GET All Rooms ---
@app.route('/api/rooms', methods=['GET'])
def get_rooms():
    rooms = Room.query.all()
    return jsonify([
        {
            'id': room.id,
            'name': room.name,
            'capacity': room.capacity
        } for room in rooms
    ])

# --- GET All Programs ---
@app.route('/api/programs', methods=['GET'])
def get_programs():
    programs = Program.query.all()
    return jsonify([
        {
            'id': prog.id,
            'name': prog.name
        } for prog in programs
    ])

# --- GET All Modules ---
@app.route('/api/modules', methods=['GET'])
def get_modules():
    modules = Module.query.all()
    return jsonify([
        {
            'id': mod.id,
            'name': mod.name
        } for mod in modules
    ])

# end of return thode data


@app.errorhandler(404)
def not_found(error):
    return render_template('errors/404.html'), 404

@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return render_template('errors/500.html'), 500

def init_db():
    with app.app_context():
        db.create_all()
        admin_user = User.query.filter_by(userName='admin').first()
        if not admin_user:
            admin_user = User(
                userName='admin',
                email='admin@acnsms.com',
                password_hash=generate_password_hash('admin123'),
                phone='+1234567890',
                role='admin',
                department='administration',
                fName='System',
                lName='Administrator'
            )
            db.session.add(admin_user)
            db.session.commit()

            admin_record = Admin(
                fullName='System Administrator',
                adminId='ADM0001',
                email='admin@acnsms.com',
                phone='+1234567890'
            )
            db.session.add(admin_record)
            db.session.commit()
            print("Default admin user created: admin/admin123")



if __name__ == '__main__':
    init_db()
    print("ACNSMS Application Starting...")
    print("Access the application at: http://localhost:5000")
    app.run(debug=True, host='0.0.0.0', port=5000)  