# ACNSMS - Complete Setup Guide for VS Code

## Prerequisites Installation

### 1. Install Required Software

#### A. Install Python (3.8 or higher)
1. Go to https://www.python.org/downloads/
2. Download Python 3.8+ for your operating system
3. During installation, **CHECK** "Add Python to PATH"
4. Verify installation: Open Command Prompt/Terminal and type:
   ```
   python --version
   ```

#### B. Install VS Code
1. Go to https://code.visualstudio.com/
2. Download and install VS Code
3. Open VS Code

#### C. Install VS Code Extensions
In VS Code, go to Extensions (Ctrl+Shift+X) and install:
- Python (by Microsoft)
- Flask Snippets
- HTML CSS Support
- Bootstrap 5 Quick Snippets
- Auto Rename Tag

### 2. Install Database (Choose One)

#### Option A: SQLite (Easiest - Recommended for beginners)
- No installation needed, comes with Python

#### Option B: MySQL/MariaDB (Production-ready)
1. Download from https://dev.mysql.com/downloads/mysql/
2. Install with default settings
3. Remember your root password

## Project Setup

### 3. Create Project Folder
1. Create a new folder called `ACNSMS` on your desktop
2. Open VS Code
3. File → Open Folder → Select your `ACNSMS` folder

### 4. Create Virtual Environment
Open VS Code Terminal (Terminal → New Terminal) and run:

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate

# On Mac/Linux:
source venv/bin/activate

# You should see (venv) at the beginning of your terminal line
```

### 5. Install Python Libraries
With virtual environment activated, run:

```bash
pip install flask
pip install flask-sqlalchemy
pip install flask-login
pip install flask-wtf
pip install wtforms
pip install werkzeug
pip install bcrypt
pip install flask-mail
pip install python-dotenv
pip install pymysql
pip install twilio
pip install google-auth
pip install google-auth-oauthlib
pip install google-auth-httplib2
pip install google-api-python-client
pip install python-dateutil
```

## Project Structure

### 6. Create Project Files
Create these folders and files in your ACNSMS folder:

```
ACNSMS/
├── app.py
├── models.py
├── config.py
├── requirements.txt
├── .env
├── templates/
│   ├── base.html
│   ├── home.html
│   ├── login.html
│   ├── register.html
│   └── dashboard.html
├── static/
│   ├── css/
│   │   └── style.css
│   └── js/
│       └── main.js
└── services/
    ├── __init__.py
    ├── google_calendar_service.py
    └── notification_service.py
```

## Running the Application

### 7. Terminal Commands to Run

#### First Time Setup:
```bash
# 1. Activate virtual environment (if not already active)
venv\Scripts\activate

# 2. Set environment variables (Windows)
set FLASK_APP=app.py
set FLASK_ENV=development

# For Mac/Linux:
export FLASK_APP=app.py
export FLASK_ENV=development

# 3. Initialize database
python
>>> from app import db
>>> db.create_all()
>>> exit()

# 4. Run the application
python app.py
```

#### Daily Development:
```bash
# 1. Activate virtual environment
venv\Scripts\activate

# 2. Run application
python app.py
```

### 8. Access Your Application
- Open web browser
- Go to: http://127.0.0.1:5000 or http://localhost:5000

## Environment Configuration

### 9. Create .env File
Create a file named `.env` in your project root with:

```
# Database Configuration
DATABASE_URL=sqlite:///acnsms.db

# Flask Configuration
SECRET_KEY=your-secret-key-here
FLASK_ENV=development

# Email Configuration (Gmail)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password

# Twilio Configuration
TWILIO_ACCOUNT_SID=your_twilio_sid_here
TWILIO_AUTH_TOKEN=token here

# Google Calendar API (You'll get these from Google Cloud Console)
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-client-secret
```

## Troubleshooting

### Common Issues and Solutions:

#### 1. "python is not recognized"
- Reinstall Python and check "Add to PATH"
- Restart VS Code and terminal

#### 2. "pip is not recognized"
- Same as above, or use: `python -m pip install package-name`

#### 3. "Module not found"
- Make sure virtual environment is activated
- Reinstall the missing package: `pip install package-name`

#### 4. "Permission denied"
- Run VS Code as administrator (Windows)
- Use `sudo` on Mac/Linux

#### 5. Database connection errors
- For SQLite: No setup needed
- For MySQL: Make sure MySQL service is running

## Development Workflow

### Daily Development Steps:
1. Open VS Code
2. Open your ACNSMS folder
3. Open Terminal in VS Code
4. Activate virtual environment: `venv\Scripts\activate`
5. Run application: `python app.py`
6. Open browser to http://localhost:5000
7. Make changes to your code
8. Refresh browser to see changes

### When Adding New Features:
1. Stop the server (Ctrl+C in terminal)
2. Make your code changes
3. If you added new database models, update database:
   ```bash
   python
   >>> from app import db
   >>> db.drop_all()
   >>> db.create_all()
   >>> exit()
   ```
4. Restart server: `python app.py`

## Next Steps After Setup

1. **Test Basic Setup**: Run the application and access the home page
2. **Create Test Users**: Register with different roles (student, lecturer, admin)
3. **Test Login**: Login with created users
4. **Setup Google Calendar API**: Follow Google's documentation
5. **Configure Email**: Setup Gmail app password
6. **Test Notifications**: Send test emails and SMS

## Getting Help

If you encounter issues:
1. Check the terminal for error messages
2. Make sure virtual environment is activated
3. Verify all packages are installed
4. Check that all files are in correct locations
5. Restart VS Code and try again

## Important Notes

- Always activate virtual environment before working
- Keep your .env file secure (don't share passwords)
- Test each feature as you build it
- Save your work frequently
- Use Git for version control (optional but recommended)