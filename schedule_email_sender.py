import os
import smtplib
from email.message import EmailMessage
from email.utils import formataddr
from pathlib import Path

from dotenv import load_dotenv # pip install python - dotenv

MAIL_PORT = 587
MAIL_SERVER= "smtp.gmail.com"

# load the environment variable 
curreent_dir = Path(__file__).resolve().parent if "__file__" in locals() else Path.cwd()
envars = curreent_dir / ".env"
load_dotenv(envars)

#read environment variables
sender_email = os.getenv("MAIL_USERNAME")
password_email = os.getenv("MAIL_PASSWORD")

def send_email(subject_t,subject,r_email,BCC_email,module_id,date,start_time,end_time,room_id,lecturer_id):
    #create the base text massage
    msg = EmailMessage()
    msg["Subject"] = subject_t
    msg["From"] = formataddr(("Academic Office", f"{sender_email}"))

    msg["To"] = r_email
    msg["BCC"] = BCC_email

    msg.set_content( 
        f"""
        Dear all receivers,

        This is to inform you about the upcoming class scheduled as follows:
                
                Module Name: {module_id}
                Subject Name: {subject}
                Date: {date}
                Start Time: {start_time}
                End Time: {end_time}
                Lecture Room: {room_id}
                Lecturer: {lecturer_id}
        
        Please make sure to attend on time and be prepared.

        Best regards,
        Academic Team
            """)
    
# add the html version. this converts the massage into a alternative
# container, with the original text message as the first part and the new html 
# mag as the 2nd part 

    msg.add_alternative(f"""
    <html>
        <body>
            <p>Hello,</p>
            <p>This is to inform you about the upcoming class scheduled as follows:</p>
            <ul>
                <li><strong>Module Name:</strong> {module_id}</li>
                <li><strong>Subject Name:</strong> {subject}</li>
                <li><strong>Date:</strong> {date}</li>
                <li><strong>Start Time:</strong> {start_time}</li>
                <li><strong>End Time:</strong> {end_time}</li>
                <li><strong>Lecture Room:</strong> {room_id}</li>
                <li><strong>Lecturer:</strong> {lecturer_id}</li>
            </ul>
            <p>Please make sure to attend on time and be prepared.</p>
            <p>Best regards,<br>Academic Team</p>
        </body>
    </html>
    """, subtype='html',
    )
    
    with smtplib.SMTP(MAIL_SERVER,MAIL_PORT) as server:
        server.starttls()
        server.login(sender_email,password_email)
        server.sendmail(sender_email,r_email,msg.as_string())

if __name__ == "__main__":
    msg = send_email(
        subject_t="📅 Class Schedule Notification - Computer Networks",
        r_email="student@example.com",
        BCC_email="admin@example.com",
        module_id="Information Technology",
        subject="Introduction to IT Basics",
        date="2025-07-25",
        start_time="09:00 AM",
        end_time="11:00 AM",
        room_id="Room A102",
        lecturer_id="Mr. Ruwan Perera"
    )
        
    



       
    















