from flask import Flask, request
import psycopg2

app = Flask(__name__)

DATABASE_URL = "url"

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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
