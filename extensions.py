"""
extensions.py
Initialize and expose shared Flask extensions
Used to avoid circular imports
"""

from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager

# Initialize SQLAlchemy
db = SQLAlchemy()

# Initialize LoginManager
login_manager = LoginManager()
login_manager.login_view = 'login'  # Redirects unauthorized users to /login
login_manager.login_message_category = 'info'
