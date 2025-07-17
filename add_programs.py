from app import app
from extensions import db
from models import Program

# Make sure you're inside the app context
with app.app_context():
    program_samples = [
        Program(name="HND in Software Engineering", type="HND", mode="weekday", department="BTEC"),
        Program(name="HND in Computer Science", type="HND", mode="weekday", department="BTEC"),
        Program(name="HND in Digital Technology", type="HND", mode="weekday", department="BTEC"),
        Program(name="HND in Digital Technology", type="HND", mode="weekend", department="BTEC"),
        Program(name="HND in Software Engineering", type="HND", mode="weekend", department="BTEC"),
        Program(name="HND in Computer Science", type="HND", mode="weekend", department="BTEC"),
        Program(name="BSc in Artificial Intelligence", type="Degree", mode="weekend", department="UH"),
        Program(name="BSc in Cloud Infrastructure", type="Degree", mode="weekend", department="UH"),
        Program(name="Certificate in Web Development", type="Certificate", mode="weekday", department="CAIT"),
        Program(name="Certificate in Graphic Design", type="Certificate", mode="weekend", department="CAIT"),
        Program(name="Foundation in IT Skills", type="Foundation", mode="weekday", department="UH/BTEC"),
        Program(name="Foundation in Engineering Basics", type="Foundation", mode="weekend", department="UH/BTEC"),
        Program(name="Certificate in Cybersecurity", type="Certificate", mode="weekday", department="CAIT"),
        Program(name="BSc in Digital Transformation", type="Degree", mode="weekend", department="UH")
    ]

    db.session.add_all(program_samples)
    db.session.commit()
    print("✅ Sample programs added successfully.")
