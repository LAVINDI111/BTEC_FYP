"""
Notification Service
Handles email and SMS notifications
"""

import os
from flask import current_app
from flask_mail import Mail, Message
from twilio.rest import Client
from datetime import datetime

class NotificationService:
    """Service class for sending notifications"""
    
    def __init__(self, app=None):
        self.mail = None
        self.twilio_client = None
        if app:
            self.init_app(app)
    
    def init_app(self, app):
        """Initialize with Flask app"""
        self.mail = Mail(app)
        
        # Initialize Twilio client
        account_sid = app.config.get('TWILIO_ACCOUNT_SID')
        auth_token = app.config.get('TWILIO_AUTH_TOKEN')
        
        if account_sid and auth_token:
            self.twilio_client = Client(account_sid, auth_token)
    
    def send_email(self, to_email, subject, body_text, body_html=None):
        """Send email notification"""
        try:
            msg = Message(
                subject=subject,
                sender=current_app.config['MAIL_USERNAME'],
                recipients=[to_email]
            )
            msg.body = body_text
            if body_html:
                msg.html = body_html
            
            self.mail.send(msg)
            return True
            
        except Exception as e:
            print(f"Email sending error: {e}")
            return False
    
    def send_sms(self, to_phone, message):
        """Send SMS notification"""
        try:
            if not self.twilio_client:
                print("Twilio client not initialized")
                return False
            
            message = self.twilio_client.messages.create(
                body=message,
                from_='+1234567890',  # Your Twilio phone number
                to=to_phone
            )
            
            return True
            
        except Exception as e:
            print(f"SMS sending error: {e}")
            return False
    
    def send_schedule_notification(self, users, schedule_data, notification_type='schedule'):
        """Send schedule-related notifications to multiple users"""
        results = {'email': [], 'sms': []}
        
        for user in users:
            # Prepare message content
            if notification_type == 'schedule':
                subject = f"New Schedule: {schedule_data['subject']}"
                message = f"New lecture scheduled:\n{schedule_data['subject']}\nDate: {schedule_data['date']}\nTime: {schedule_data['start_time']} - {schedule_data['end_time']}\nRoom: {schedule_data['room']}"
            elif notification_type == 'reschedule':
                subject = f"Schedule Updated: {schedule_data['subject']}"
                message = f"Lecture rescheduled:\n{schedule_data['subject']}\nNew Date: {schedule_data['new_date']}\nNew Time: {schedule_data['new_start_time']} - {schedule_data['new_end_time']}\nRoom: {schedule_data['room']}"
            else:
                subject = f"Schedule Reminder: {schedule_data['subject']}"
                message = f"Reminder: Lecture tomorrow\n{schedule_data['subject']}\nDate: {schedule_data['date']}\nTime: {schedule_data['start_time']} - {schedule_data['end_time']}\nRoom: {schedule_data['room']}"
            
            # Send email
            email_sent = self.send_email(user.email, subject, message)
            results['email'].append({
                'user_id': user.id,
                'email': user.email,
                'sent': email_sent
            })
            
            # Send SMS
            sms_sent = self.send_sms(user.phone, message)
            results['sms'].append({
                'user_id': user.id,
                'phone': user.phone,
                'sent': sms_sent
            })
        
        return results

# Global instance
notification_service = NotificationService()