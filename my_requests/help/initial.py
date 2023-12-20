import json
import mysql.connector

def initial():


    config = open('config.json')
    config_data = json.load(config)

    conn = mysql.connector.connect(
        host = config_data["host"], 
        user = config_data["user"], 
        password = config_data["password"], 
        database = config_data["database"] 
    )

    config.close()

    cursor = conn.cursor()
    cursor.execute("SELECT driver_code FROM users LIMIT 1")
    driver_code = cursor.fetchone()[0]
    cursor.execute("SELECT order_id FROM orders LIMIT 1")
    order_id = cursor.fetchone()[0]

    return (conn, cursor, driver_code, order_id)
