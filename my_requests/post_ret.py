

from flask import jsonify, request
from my_requests.help.check_permissions import check_permissions
from my_requests.help.get_time_and_date import get_datetime_string 

from my_requests.help.initial import initial


def post_ret():
    conn, cursor, driver_code, order_id = initial()
    # driver_code = "11213"
    # order_id = 9101112
    try:
        cursor.execute(f"SELECT id FROM users WHERE driver_code = {driver_code}")
        driver_id = cursor.fetchone()[0]

        cursor.execute(f"SELECT rental_id FROM rentals WHERE order_id = {order_id} AND driver_id = {driver_id} ORDER BY rental_id DESC LIMIT 1")
        rental_id = cursor.fetchone()[0]

        data = request.get_json()  # Get JSON data from the request body
        
        # rentals
        try:
            if "rentals" not in data or "actual_return_time" not in data["rentals"] or "return_kilometers" not in data["rentals"] or data["rentals"]['return_kilometers'] == '' or  (data["rentals"]['actual_return_time'] == '' and 'Administrative driver' not in check_permissions(cursor, driver_code)):
                return jsonify({'error': "Necessary information is missing"}), 500
            
            cursor.execute(f"""UPDATE rentals
                        SET actual_return_time = '{get_datetime_string(data['rentals']['actual_return_time'])}', return_kilometers = {data['rentals']['return_kilometers']}
    WHERE rental_id = {rental_id}
    """)
            conn.commit()
        except Exception as e:
            return jsonify({'error': f'Update rentals failed. {str(e)}'}), 500

        # toll roads
        try:
            if "toll_roads" in data:
                toll_roads = data["toll_roads"]
                #print(toll_roads)
                for road_use in toll_roads:
                    if road_use != {}:
                        
                        #get price
                        if road_use["road_id"] == "3":
                            numbers = re.findall(r'-?\d+', road_use["price"])
                            price = sum(map(int, numbers))
                            #print(price)
                        else:
                            cursor.execute(f"SELECT road_price FROM toll_roads WHERE road_id = {road_use['road_id']}")
                            price = cursor.fetchone()[0]
                            #print(price)
                        
                        insertQuery = f"""INSERT INTO toll_road_use (rental_id, use_date, road_id, number_of_uses, price)
VALUES ({rental_id}, '{road_use['use_date']}', {road_use["road_id"]}, {road_use['numbers_of_uses']}, {price})"""
                        #print(insertQuery)
                        cursor.execute(insertQuery)
                        conn.commit()
        except Exception as e:
            return jsonify({'error': f'Update toll_roads failed. {str(e)}'}), 500

        # orders
        try:
            if "orders" in data and len(data["orders"]) > 0:
                orders = data["orders"]
                #print(orders)

                updateQuery = f"""UPDATE orders SET end_date = '{orders["end_date"]}'"""
                #print(updateQuery)
                cursor.execute(updateQuery)
                conn.commit()
        except Exception as e:
            return jsonify({'error': f'Update orders failed. {str(e)}'}), 500
        
        # faults
        try:
            if "faults" in data:
                faults = data["faults"]
                #print(faults)

                insertQuery = f"""INSERT INTO faults (rental_id, description)
VALUES ({rental_id}, '{faults}')"""
                #print(insertQuery)
                cursor.execute(insertQuery)
                conn.commit()
                
        except Exception as e:
            return jsonify({'error': f'Update faults failed. {str(e)}'}), 500

        # fines
        try:
            if "fines" in data:
                fines = data["fines"]
                #print(fines)

                type_to_id = {"משטרה": 1, "חניה": 2}

                for fine in fines:
                    fine_id = type_to_id.get(fine['type'])
                    insertQuery = f"""INSERT INTO fines (rental_id, date, fine_type, sum, description)
    VALUES ({rental_id}, '{fine['date']}', {fine_id}, {fine['amount']}, '{fine['description']}')"""
                    #print(insertQuery)
                    cursor.execute(insertQuery)
                    conn.commit()
                
        except Exception as e:
            return jsonify({'error': f'Update fines failed. {str(e)}'}), 500

        # accident
        try:
            if "accident" in data:
                accident = data["accident"]
                #print(accident)

                if accident.get('injuries'):
                    injuries = 1
                else:
                    injuries = 0

                insertQuery = f"""INSERT INTO accidents (rental_id, date, description, body_injuries, body_injuries_description)
VALUES ({rental_id}, '{accident['accidentDate']}', '{accident['accidentDescription']}', {injuries}, '{accident.get('injuries')}')"""
                #print(insertQuery)
                cursor.execute(insertQuery)
                conn.commit()
                
        except Exception as e:
            return jsonify({'error': f'Update accident failed. {str(e)}'}), 500

        
        response = {"update": "successfuly"}
        return jsonify(response), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
