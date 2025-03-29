from flask import Flask, request, jsonify
import psycopg2
from flask_bcrypt import Bcrypt
import re
from config import DATABASE_URL

app = Flask(__name__)
bcrypt = Bcrypt(app)


def is_valid_email(email):
    return re.match(r"[^@]+@[^@]+\.[^@]+", email)

def insert_data(temp, humid):
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO data (temperature, humidity) VALUES (%s, %s)", (temp, humid))
        conn.commit()
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print("Database error:", e)
        return False

def is_valid_temperature(temp):
    try:
        temp = float(temp)
        return -50 <= temp <= 150 
    except ValueError:
        return False

def is_valid_humidity(humid):
    try:
        humid = float(humid)
        return 0 <= humid <= 100 
    except ValueError:
        return False

@app.route('/store', methods=['POST'])
def store_data():
    data = request.get_json()
    if not data:
        return "Invalid JSON", 400

    temp = data.get('temperature')
    humid = data.get('humidity')

    if temp is None or humid is None:
        return "Missing data", 400

    if not is_valid_temperature(temp):
        return "Invalid temperature value", 400

    if not is_valid_humidity(humid):
        return "Invalid humidity value", 400

    if insert_data(float(temp), float(humid)):
        return "Data stored successfully", 200
    else:
        return "Database error", 500
    
@app.route('/register', methods=['POST'])
def register():
    data = request.json
    email = data['email']
    password = data['password']

    hashed_pw = bcrypt.generate_password_hash(password).decode('utf-8')

    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (email, password) VALUES (%s, %s)", (email, hashed_pw))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "User registered successfully!"}), 201
    except Exception as e:
        print("Database error:", e)
        return jsonify({"error": "Database error"}), 500
    
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data['email']
    password = data['password']

    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        cursor.execute("SELECT password FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()

        if user and bcrypt.check_password_hash(user[0], password):
            return jsonify({"message": "Login successful!"}), 200
        else:
            return jsonify({"error": "Email or password incorrect"}), 401
    except Exception as e:
        print("Database error:", e)
        return jsonify({"error": "Database error"}), 500


@app.route('/data', methods=['GET'])
def download_data():
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        cursor.execute("SELECT temperature, humidity, timestamp FROM data ORDER BY timestamp DESC")
        rows = cursor.fetchall()
        cursor.close()
        conn.close()

        data = []
        for row in rows:
            data.append({
                "temperature": row[0],
                "humidity": row[1],
                "timestamp": row[2].isoformat()
            })

        return jsonify(data), 200
    except Exception as e:
        print("Database error:", e)
        return jsonify({"error": "Database error"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
