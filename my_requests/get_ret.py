

from flask import app, json, jsonify
from my_requests.help.check_permissions import check_permissions
from my_requests.help.get_time_and_date import get_current_date, get_current_time, get_current_year
from my_requests.help.initial import initial
from my_requests.help.isRental import is_rental

TRAVEL_PHONE = "025807685"


def get_ret():
    conn, cursor, driver_code, order_id = initial()

    with open('messages.json', 'r', encoding='utf-8') as f:
        messages = json.load(f)
    # driver_code = "11213"
    # order_id = 9101112
    try:
        cursor.execute(f"""
            SELECT car_types.car_type_description, cars.car_license_number, rentals.pickup_time, rentals.estimated_return_time, 
            rentals.pickup_kilometers, orders.start_date, orders.end_date,
            users.first_name, users.last_name, users.drivers_license_validity, users.phone, users.gov_id, orders.customer_id, users.permissions
            FROM orders
            JOIN rentals ON rentals.order_id = {order_id}
            JOIN cars ON rentals.car_license_number = cars.car_license_number
            JOIN users ON users.driver_code = {driver_code}
            JOIN car_types ON car_types.car_type_id = cars.car_type
            WHERE orders.order_id = {order_id}
        """)

        results = cursor.fetchall()

        ret_all_data = []

        for row in results:
            ret_data = {
                'car_type_description': row[0],
                'car_license_number': row[1],
                'pickup_time': row[2].strftime("%H:%M"),
                'estimated_return_time': row[3].strftime("%H:%M"),
                'pickup_kilometers': row[4],
                'start_date': row[5].strftime('%Y-%m-%d'),
                'end_date': row[6].strftime('%Y-%m-%d'),
                'first_name': row[7],
                'last_name': row[8],
                'drivers_license_validity': row[9].strftime('%Y-%m-%d'),
                'phone': row[10],
                'id': row[11],
                'customer_id': row[12],
                'order_id': order_id,
                'messages':messages,
                'peronal_driver_code': driver_code,
                'Travel_Phone': TRAVEL_PHONE,
                'current_date': get_current_date(),
                'current_year': get_current_year(),
                'current_time': get_current_time(),
                'orderer_name': '',
                'toll_roads_types': [],
                'expense_types': [],  # Initialize empty list for expense categories
                'permissions': check_permissions(cursor, driver_code),
                'is_rental': is_rental(cursor, driver_code)
            }
            ret_all_data.append(ret_data)

        #toll_roads
        cursor.execute("""SELECT toll_roads.road_id, toll_roads.road_name, toll_roads.road_price
                        FROM toll_roads
        """)
        results = cursor.fetchall()
        toll_roads = []
        for row in results:
            road = {
                "id": row[0],
                "name": row[1],
                "price": row[2]
            }
            toll_roads.append(road)
        ret_all_data[0]["toll_roads_types"] = toll_roads   

        #expense_types
        cursor.execute("""SELECT expense_types.id, expense_types.description
                FROM expense_types
        """) 
        results = cursor.fetchall()
        expense_categories = []
        for row in results:
            category = {
                "id": row[0],
                "label": row[1]
            }
            expense_categories.append(category)
        ret_all_data[0]["expense_types"] = expense_categories


        #orderer_name
        orederer_name = None
        cursor.execute(f"SELECT users.first_name, users.last_name FROM users WHERE users.id = {ret_all_data[0]['customer_id']}")
        #print(ret_all_data[0]['customer_id'])
        orederer_name = cursor.fetchone()
        #print(orederer_name)
        ret_all_data[0]['orderer_name'] = f"{orederer_name[0]} {orederer_name[1]}"
        #print(ret_all_data[0]['orderer_name'])

        return jsonify(ret_all_data[0]), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
 