import os
import smtplib
from email.message import EmailMessage
from email.utils import formataddr
from pathlib import Path
from dotenv import load_dotenv

MAIL_PORT = 587
MAIL_SERVER = "smtp.gmail.com"

# Load environment variables
current_dir = Path(__file__).resolve().parent if "__file__" in locals() else Path.cwd()
envars = current_dir / ".env"
load_dotenv(envars)

sender_email = os.getenv("MAIL_USERNAME")
password_email = os.getenv("MAIL_PASSWORD")

def send_reschedule_email(subject_t, subject, r_email, BCC_email, module_id,
                          old_date, room_id, lecturer_id,
                          new_date, new_start_time, new_end_time, reason):
    msg = EmailMessage()
    msg["Subject"] = subject_t
    msg["From"] = formataddr(("Academic Office", f"{sender_email}"))
    msg["To"] = r_email
    msg["BCC"] = BCC_email

    # Plain text content
    msg.set_content(f"""
Dear All,

This is to notify you that the following class has been rescheduled:

Module Name: {module_id}
Subject: {subject}
Schedule Date: {old_date}
Reshedule Date: {new_date}
New Time: {new_start_time} to {new_end_time}
Lecture Room: {room_id}
Lecturer: {lecturer_id}

Reason for rescheduling: {reason}

Please update your calendar accordingly and be present on time.

Best regards,  
Academic Team
""")

    # HTML version
    msg.add_alternative(f"""
    <html>
        <body>
            <p>Dear All,</p>
            <p>This is to notify you that the following class has been <strong>rescheduled</strong>:</p>
            <ul>
                <li><strong>Module Name:</strong> {module_id}</li>
                <li><strong>Subject:</strong> {subject}</li>
                <li><strong>Schedule Date:</strong> {old_date}</li>
                <li><strong>Reschedule Date:</strong> {new_date}</li>
                <li><strong>New Time:</strong> {new_start_time} to {new_end_time}</li>
                <li><strong>Lecture Room:</strong> {room_id}</li>
                <li><strong>Lecturer:</strong> {lecturer_id}</li>
                <li><strong>Reason for Rescheduling:</strong> {reason}</li>
            </ul>
            <p>Please update your calendar accordingly and ensure your attendance.</p>
            <p>Best regards,<br>Academic Affairs Team</p>
        </body>
    </html>
    """, subtype='html')

    # Send the email
    with smtplib.SMTP(MAIL_SERVER, MAIL_PORT) as server:
        server.starttls()
        server.login(sender_email, password_email)
        server.sendmail(sender_email, r_email, msg.as_string())

# Example test run
if __name__ == "__main__":
    send_reschedule_email(
        subject_t="⏰ Class Reschedule Notification – Computer Networks",
        subject="Computer Networks",
        r_email="student@example.com",
        BCC_email="admin@example.com",
        module_id="Information Technology",
        old_date="2025-07-25",
        new_date="2025-07-27",
        new_start_time="10:00 AM",
        new_end_time="12:00 PM",
        room_id="Room A102",
        lecturer_id="Dr. Ruwan Perera",
        reason="Lecturer unavailable due to conference"
    )
