import datetime
from flask_cors import CORS
from my_requests.help.check_permissions import check_permissions
from my_requests.help.get_time_and_date import get_current_date, get_current_time, get_current_year, get_datetime_string
from my_requests.help.initial import initial
from flask import Flask, json, jsonify

from my_requests.help.isRental import is_rental

TRAVEL_PHONE = "025807685"


app = Flask(__name__)
CORS(app)


def get_pick():
    conn, cursor, driver_code, order_id = initial()

    with open('messages.json', 'r', encoding='utf-8') as f:
        messages = json.load(f)
    
    try:
        # driver_code = "11213"
        # order_id = 9101112

        with app.app_context():
            cursor.execute(f"""
                SELECT orders.start_date, 
                        orders.end_date, 
                        orders.price_per_day, 
                        orders.car_license_number, 
                        users.city, 
                        users.zip, 
                        users.phone, 
                        users.last_name, 
                        users.first_name, 
                        users.drivers_license_validity, 
                        users.address, 
                        users.email, 
                        users.health_declaration_validity, 
                        users.gov_id,
                        orders.customer_id,
                        users.permissions
                FROM users
                JOIN orders ON orders.order_id = {order_id}
                WHERE users.driver_code = {driver_code}
            """)

            results = cursor.fetchall()
            #print(results)

            orders_and_cars = []

            for row in results:
                order_car_data = {
                    'start_date': row[0].strftime('%Y-%m-%d'),
                    'end_date': row[1].strftime('%Y-%m-%d'),
                    'price_per_day': row[2],
                    'car_license_number': row[3],
                    'numbers_of_days': (row[1] - row[0]).days,
                    'city': row[4],
                    'zip': row[5],
                    'phone': row[6],
                    'last_name': row[7],
                    'first_name': row[8],
                    'drivers_license_validity': row[9].strftime('%Y-%m-%d'),
                    'address': row[10],
                    'email': row[11],
                    'health_declaration_validity': row[12],
                    'id': row[13],
                    'order_id': order_id,
                    'travel_phone': TRAVEL_PHONE,
                    'peronal_driver_code': driver_code,
                    'current_date': get_current_date(),
                    'current_year': get_current_year(),
                    'current_time': get_current_time(),
                    'messages': messages,
                    'card_validity': '',
                    'customer_id': row[14],
                    'card_exist': True,
                    'return_kilometers': '',
                    'orderer_name': '',
                    'permissions': check_permissions(cursor, driver_code),
                    'is_rental': is_rental(cursor, driver_code)
                }
                orders_and_cars.append(order_car_data)
                car_license_number = row[3]

            # return kilometers
            return_kilometers = None
            cursor.execute(f"SELECT rental_id FROM rentals WHERE car_license_number = {car_license_number} ORDER BY rental_id DESC LIMIT 1")
            result = cursor.fetchone()
            if result is not None:
                last_rental = result[0]
            #print(f"last rental: {last_rental}")

                cursor.execute(f"SELECT return_kilometers FROM rentals WHERE rental_id = {last_rental}")
                result = cursor.fetchone()
                #print(return_kilometers)
                if result is not None:
                    return_kilometers = result[0]
                    orders_and_cars[0]['return_kilometers'] = return_kilometers

            #orderer_name
            orederer_name = None
            cursor.execute(f"SELECT users.first_name, users.last_name FROM users WHERE users.id = {orders_and_cars[0]['customer_id']}")
            #print(orders_and_cars[0]['customer_id'])
            orederer_name = cursor.fetchone()
            #print(orederer_name)
            orders_and_cars[0]['orderer_name'] = f"{orederer_name[0]} {orederer_name[1]}"
            #print(orders_and_cars[0]['orderer_name'])

            #create draft rental
            cursor.execute(f"SELECT id FROM users WHERE driver_code = {driver_code}")
            driver_id = cursor.fetchone()[0]

            cursor.execute(f"""INSERT INTO rentals (pickup_time, 
                    estimated_return_time, 
                    pickup_kilometers, 
                    car_license_number, 
                    driver_id, 
                    order_id) 
                VALUES ('{get_datetime_string('00:00')}', 
                    '{get_datetime_string('00:00')}', 
                    0,
                    {car_license_number},
                    {driver_id},
                    {order_id})""")
            conn.commit()

            cursor.execute(f"SELECT rental_id FROM rentals WHERE order_id = {order_id} AND driver_id = {driver_id} ORDER BY rental_id DESC LIMIT 1")
            rental_id = cursor.fetchone()[0]

            #card_exist
            cursor.execute(f"SELECT `credit_card`, `credit_card_validity` FROM `users` WHERE `driver_code` = {driver_code}")
            card_details = cursor.fetchone()
            credit_card = card_details[0]
            credit_card_validity = card_details[1]
            #print(credit_card_validity)
            if not credit_card or not credit_card_validity:
                orders_and_cars[0]['card_exist'] = False
                orders_and_cars[0]['card_validity'] = False
            

            else:
                orders_and_cars[0]['card_validity'] = credit_card_validity > datetime.datetime.now().date()

            if not credit_card or not credit_card_validity or credit_card_validity < datetime.datetime.now().date():
                # messages
                textmsg = f"""<p> שלום, <br/>
פרטי כרטיס אשראי של הלקוח: {orders_and_cars[0]['first_name']} {orders_and_cars[0]['last_name']} ת"ז: {orders_and_cars[0]['id']} לא בתוקף/ לא קיימים.<p/>
<p> נא ליצור איתו קשר בהקדם. <br/>
תודה רבה!<p/>
"""

                #recipients & subject
                message_templates_id = 1
                cursor.execute(f"SELECT `recipients`, `subject` FROM `message_templates` WHERE `id` = {message_templates_id}")
                result = cursor.fetchone()
                recipients = result[0]
                subject = result[1]

                insert_query = "INSERT INTO messages (`rental_id`, `template_id`, `time_sent`, `recipients`, `subject`, `text`, `status`) VALUES (%s, %s, %s, %s, %s, %s, %s)"
                values = (rental_id, message_templates_id, datetime.datetime.now(), recipients, subject, textmsg, 0)
                cursor.execute(insert_query, values)
                conn.commit()   

            return jsonify(orders_and_cars[0]), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
