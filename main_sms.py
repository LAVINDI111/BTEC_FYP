import keys
from twilio.rest import Client
import os
from models import db, Student, User

# These values must be stored as strings inside keys.py
TWILIO_ACCOUNT_SID = keys.TWILIO_ACCOUNT_SID
TWILIO_AUTH_TOKEN = keys.TWILIO_AUTH_TOKEN

#client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

#message = client.messages.create(
    #from_=keys.TWILIO_NUMBER,   # ✅ Note: use from_ (with underscore)
    #body="This is to notify you that the following class has been rescheduled:........... test msg 1..",
    #to=keys.MY_PHONE_NUMBER
#)

#print(message.sid)


def send_sms_to_all_students(message):
    students = db.session.query(Student, User).join(User, Student.userId == User.id).all()

    for student, user in students:
        try:
            Client.messages.create(
                body=message,
                from_= keys.TWILIO_NUMBER,
                to=user.phone  # Make sure this is a verified number
            )
            print(f"SMS sent to {user.phone}")
        except Exception as e:
            print(f"Failed to send to {user.phone}: {e}")



