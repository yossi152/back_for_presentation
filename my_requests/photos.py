import datetime
import os
from flask import jsonify, request
from my_requests.help.get_time_and_date import get_current_time, get_datetime_string
from my_requests.help.initial import initial


def photos():
    try:
        conn, cursor, driver_code, order_id = initial()


        if 'image' in request.files:
            #save image
            image_file = request.files['image']
            # Generate a unique name for the image
            photo_type = request.form['photo_type']  # Get photo_type from the form
            current_date = datetime.datetime.now().date()
            photo_name = f"{photo_type}{order_id}{driver_code}{current_date}.jpg"
            image_path = os.path.join('photos', photo_name)
            image_file.save(image_path)

            #insert to db
            if request.form['photo_type'] not in ["expenses", "passport_photo", "visa_photo"]:
                cursor.execute(f"SELECT id FROM users WHERE driver_code = {driver_code}")
                driver_id = cursor.fetchone()[0]

                cursor.execute(f"SELECT orders.car_license_number FROM orders WHERE order_id = {order_id} ")
                car_license_number = cursor.fetchone()[0]

                #rental_id
                cursor.execute(f"SELECT rental_id FROM rentals WHERE order_id = {order_id} AND driver_id = {driver_id} ORDER BY rental_id DESC LIMIT 1")
                result = cursor.fetchone()
                if result:
                    rental_id = result[0]
                else:
                    #create draft rental
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

                cursor.execute(f"SELECT id FROM photo_types WHERE description = '{photo_type}'")
                photo_type_id = cursor.fetchone()[0]

                description = request.form['description']

                insert_query = f"""INSERT INTO photos (photo_time, rental_id,
                                photo_type, description, car_license_number,
                                file_name)
                            VALUES ('{current_date}', {rental_id}, {photo_type_id}, '{description}', {car_license_number}, '{photo_name}')
                            """
                cursor.execute(insert_query)
                conn.commit()

            elif request.form['photo_type']  in ["passport_photo", "visa_photo"]:
   
                gov_id = f"{request.form['pasportCountry'][:2]}{request.form['pasportNumber']}"
                cursor.execute(f"SELECT id FROM users WHERE gov_id = '{gov_id}'")
                result = cursor.fetchone()
                if result:
                    tourist_id = result[0]
                    update_query = f"UPDATE users SET {request.form['photo_type']} = '{photo_name}' WHERE id = {tourist_id}"
                    
                    cursor.execute(update_query)
                    conn.commit()
                else: #have to insert to priority
                    insert_query = "INSERT INTO `users` (`gov_id`, `user_type`, `last_name`, `address`, `country`, `permissions`) VALUES (%s, %s, %s, %s, %s, %s)"
                    values = (gov_id, 0, request.form['fullName'], request.form['address'], request.form['pasportCountry'], 0)
                    # cursor.execute(insert_query, values)
                    # conn.commit() 
                
            return jsonify({'message': 'Image uploaded successfully'}), 200
        else:
            return jsonify({'error': 'Image not found in request'}), 400

    except Exception as e:
        return jsonify({'error': str(e)}), 500

