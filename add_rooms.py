from app import app
from models import Room
from extensions import db

with app.app_context():
    room_data = [
        {"name": "auditorium", "capacity": 150},
        {"name": "LR1", "capacity": 60},
        {"name": "LR2", "capacity": 40},
        {"name": "LR3", "capacity": 70},
        {"name": "LR4", "capacity": 40},
        {"name": "LR5", "capacity": 30},
        {"name": "LR6", "capacity": 30},
        {"name": "com_lab1", "capacity": 50},
        {"name": "com_lab2", "capacity": 30},
        {"name": "com_lab3", "capacity": 25},
        {"name": "DSM lab", "capacity": 40},
        {"name": "DC lab", "capacity": 30},
        {"name": "CSP lab", "capacity": 30},
        {"name": "E'tronic lab", "capacity": 25}
    ]

    for data in room_data:
        room = Room(**data)
        db.session.add(room)

    db.session.commit()
    print("✅ Room data added.")
