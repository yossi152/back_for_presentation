import datetime
from flask import jsonify, request

from my_requests.help.check_permissions import check_permissions
from .help.get_time_and_date import get_datetime_string 

from .help.initial import initial

def post_pick():
    # Initialize database connection and variables
    conn, cursor, driver_code, order_id = initial()

    # Extract JSON data from the request body
    data = request.get_json()

    try:
        # Retrieve car license number from the database
        cursor.execute(f'SELECT orders.car_license_number FROM orders WHERE order_id = {order_id}')
        result = cursor.fetchone()
        car_license_number_from_db = result[0]
    except ValueError as ve:
        return jsonify({'error': f"DB problem: {ve}"}), 400

    try:
        # Retrieve user information from the database
        cursor.execute(f"""SELECT users.first_name, 
                           users.last_name, 
                           users.gov_id, 
                           users.phone, 
                           users.drivers_license_validity, 
                           users.email, 
                           users.address, 
                           users.city, 
                           users.zip,
                           users.credit_card,
                           users.credit_card_validity,
                           users.health_declaration_validity,
                           users.id
                           FROM users 
                           WHERE users.driver_code = {driver_code}""")
        users_from_db = cursor.fetchone()

        # Create a user object
        users_object = {
            'first_name': users_from_db[0],
            'last_name': users_from_db[1],
            'gov_id' : users_from_db[2],
            'phone': users_from_db[3],
            'drivers_license_validity': users_from_db[4],
            'email': users_from_db[5],
            'address': users_from_db[6],
            'city': users_from_db[7],
            'zip': users_from_db[8],
            'credit_card': users_from_db[9],
            'credit_card_validity': users_from_db[10],
            'health_declaration_validity': users_from_db[11],
            'id': users_from_db[12]
        }
    except ValueError as ve:
        return jsonify({'error': f"DB problem: {ve}"}), 400

    # Create user's full name and driver's government ID
    full_name = users_object["first_name"] + ' ' + users_object["last_name"]
    driver_gov_id = users_object["gov_id"]        
        
    rentals = data.get('rentals')

    try:
        cursor.execute(f"SELECT rental_id FROM rentals WHERE car_license_number = {car_license_number_from_db} ORDER BY rental_id DESC LIMIT 2")
        last_rental = cursor.fetchall()

        cursor.execute(f"SELECT rental_id FROM rentals WHERE car_license_number = {car_license_number_from_db} ORDER BY rental_id DESC LIMIT 1")
        rental_id = cursor.fetchone()[0]

        if 'estimated_return_time' in rentals:
            estimated_return_time = f"estimated_return_time = '{get_datetime_string(rentals['estimated_return_time'])}', "
        elif 'Administrative driver' not in check_permissions(cursor, driver_code):
            return jsonify({'error': "estimated_return_time in missed"}), 400
        else:
            estimated_return_time = ''

        # Insert rental information into the database
        update_query = f"""UPDATE rentals SET pickup_time = '{get_datetime_string(rentals['pickup_time'])}', 
                            {estimated_return_time}
                            pickup_kilometers = {rentals['pickup_kilometers']}, 
                            car_license_number = {car_license_number_from_db}, 
                            driver_id = {users_object['id']}, 
                            order_id = {order_id} 
                        WHERE rental_id = {rental_id}"""
        cursor.execute(update_query)
        conn.commit()
    
        # update credit_card changes 
        if "credit_card_change_num" in rentals or "credit_card_change_validity" in rentals:
            #check for changes
            cursor.execute(f"SELECT `credit_card`, `credit_card_validity` FROM `users` WHERE gov_id = {driver_gov_id}")
            card_details = cursor.fetchone()
            credit_card = card_details[0]
            credit_card_validity = card_details[1]
            
            # update in rentals and messages
            update_query = "UPDATE `rentals` SET "
            message_start = f"""<br> שלום, <br/>
פרטי האשראי שהלקוח{full_name} ת"ז: {driver_gov_id} הזין במערכת: <br/>
"""
            message_end = f"""<br/>ששונים מפרטי האשראי במאגר החברה: <br/>
"""

            if "credit_card_change_num" in rentals and rentals['credit_card_change_num'] != credit_card:
                update_query += f"`credit_card_change_num` = {rentals['credit_card_change_num']}, "
                message_start += f"4 ספרות אחרונות בכרטיס האשראי: {rentals['credit_card_change_num']}, "
                message_end += f"4 ספרות אחרונות בכרטיס האשראי: {credit_card}, "

            # Convert the date format from 'MM/DD' to 'YYYY-MM-DD'
            credit_card_change_validity = rentals.get('credit_card_change_validity')
            if credit_card_change_validity and credit_card_change_validity != credit_card_validity:
                try:
                    credit_card_change_validity = datetime.datetime.strptime(credit_card_change_validity, '%m/%y').strftime('%Y-%m-%d')
                    rentals['credit_card_change_validity'] = f"'{credit_card_change_validity}'"
                except ValueError as ve:
                    return jsonify({'error': f"Invalid date format: {ve}"}), 400

                update_query += f"`credit_card_change_validity` = {rentals['credit_card_change_validity']} "
                message_start += f"תוקף הכרטיס: {credit_card_change_validity} "
                message_end += f"תוקף הכרטיס: {credit_card_validity} <br/>"

            update_query += f"WHERE `rental_id` = {rental_id}"
            message_end += f"</p> <p>לבדיקתך, <br/> תודה רבה! </p>"

            #update in rentals
            cursor.execute(update_query)
            conn.commit()   

            #update in messages            
            #recipients & subject
            message_templates_id = 12
            cursor.execute(f"SELECT `recipients`, `subject` FROM `message_templates` WHERE `id` = {message_templates_id}")
            result = cursor.fetchone()
            recipients = result[0]
            subject = result[1]

            cursor.execute(f"""INSERT INTO `messages` (
                           `rental_id`, 
                           `template_id`, 
                           `time_sent`, 
                           `recipients`, 
                           `subject`, 
                           `text`, 
                           `status`)
                        VALUES (
                           {rental_id}, 
                           {message_templates_id}, 
                           '{datetime.datetime.now()}',
                           '{recipients}', 
                           '{subject}', 
                           '{message_start + message_end}', 
                           0
                        )""")
            conn.commit()
            
    
    except ValueError as ve:
        return jsonify({'error': f"Necessary information is missing: {ve}"}), 400

#       # emails on changes
        #
    try:
        car_license_number = rentals.get('car_license_number')
        if (car_license_number != car_license_number_from_db and car_license_number != ''):

            textmsg = f"""שלום, <br/>
                    הלקוח {full_name} מס ת"ז: {driver_gov_id} מבקש לשנות את מספר הרישוי במספר הזמנה {order_id} <br/>
ממספר רישוי {car_license_number_from_db} למספר רישוי {car_license_number}
"""
                    
            email_content = f"""
                <p>{textmsg}</p>
                <p>לבדיקתך, תודה רבה</p>
            """

            #recipients & subject
            message_templates_id = 13
            cursor.execute(f"SELECT `recipients`, `subject` FROM `message_templates` WHERE `id` = {message_templates_id}")
            result = cursor.fetchone()
            recipients = result[0]
            subject = result[1]

            insert_query = "INSERT INTO messages (`rental_id`, `template_id`, `time_sent`, `recipients`, `subject`, `text`, `status`) VALUES (%s, %s, %s, %s, %s, %s, %s)"
            values = (rental_id, message_templates_id, datetime.datetime.now(), recipients, subject, email_content, 0)
            cursor.execute(insert_query, values)
            conn.commit()           
    
    except ValueError as ve:
        return jsonify({'error': f"car license update fails: {ve}"}), 400

    try:
        users = data.get('users')
        if users:
            textmsg = f"""<p> שלום, <br/>
                        הלקוח {full_name} מס ת"ז: {driver_gov_id} מבקש לשנות את פרטיו האישיים מ"""

            first_name = users.get('first_name')
            last_name = users.get('last_name')
            id = users.get('id')
            phone = users.get('phone')
            drivers_license_validity = users.get('drivers_license_validity')
            email = users.get('email')
            address = users.get('address')
            city = users.get('city')
            PC = users.get('zip')

            
            tabel = []
            old_details = []
            new_details = []

            if first_name != users_object['first_name'] and first_name is not None:
                old_details.append(users_object['first_name'])
                new_details.append(first_name)
                tabel.append("first_name")

            if last_name != users_object['last_name'] and last_name is not None:
                old_details.append(users_object['last_name'])
                new_details.append(last_name)
                tabel.append("last_name")

            if id != users_object['gov_id'] and id is not None:
                old_details.append(users_object['gov_id'])
                new_details.append(id)
                tabel.append("gov_id")

            if phone !=  users_object['phone'] and phone is not None:
                old_details.append(users_object['phone'])
                new_details.append(phone)
                tabel.append("phone")

            if drivers_license_validity != users_object['drivers_license_validity'] and drivers_license_validity is not None:
                old_details.append(users_object['drivers_license_validity'])
                new_details.append(drivers_license_validity)
                tabel.append("drivers_license_validity")

            if email != users_object['email'] and email is not None:
                old_details.append(users_object['email'])
                new_details.append(email)
                tabel.append("email")

            if address != users_object['address'] and address is not None:
                old_details.append(users_object['address'])
                new_details.append(address)
                tabel.append("address")

            if city != users_object['city'] and city is not None:
                old_details.append(users_object['city'])
                new_details.append(city)
                tabel.append("city")

            if PC != users_object['zip'] and PC is not None:
                old_details.append(users_object['zip'])
                new_details.append(PC)
                tabel.append("zip")


            # כאן ניתן להשתמש במערכים old_details ו-new_details לצורך ביצוע פעולות נוספות
            # כמו להדפיס את השינויים, לבצע פעולות מסוימות וכדומה
            if tabel:
                # Create the email content
                for field in old_details:
                    textmsg = f"{textmsg} {field}, "
                
                textmsg = textmsg + "<br/>ל"
                for field in new_details:
                    textmsg = f"{textmsg} {field}, "

                email_content = "<table border='1'><tr><th>Field</th><th>Old Value</th><th>New Value</th></tr>"

                for field, old_val, new_val in zip(tabel, old_details, new_details):
                    email_content += f"<tr><td>{field}</td><td>{old_val}</td><td>{new_val}</td></tr>"

                email_content += "</table>" + "<p>תודה רבה <br />נא ליצור איתו/ה קשר</p>"

                email_content = textmsg + email_content

                #recipients & subject
                message_templates_id = 2
                cursor.execute(f"SELECT `recipients`, `subject` FROM `message_templates` WHERE `id` = {message_templates_id}")
                result = cursor.fetchone()
                recipients = result[0]
                subject = result[1]

                insert_query = "INSERT INTO messages (`rental_id`, `template_id`, `time_sent`, `recipients`, `subject`, `text`, `status`) VALUES (%s, %s, %s, %s, %s, %s, %s)"
                values = (rental_id, message_templates_id, datetime.datetime.now(), recipients, subject, email_content, 0)
                cursor.execute(insert_query, values)
                conn.commit()           
        
    except ValueError as ve:
        return jsonify({'error': f"user details update fails: {ve}"}), 400

    try:
        orders = data.get("orders")

        if orders:
            start_date = orders.get("start_date")
            end_date = orders.get("end_date")

            cursor.execute(f"SELECT `start_date`, `end_date` FROM `orders` WHERE `order_id` = {order_id}")
            dates = cursor.fetchone()
            start_date_db = dates[0].strftime('%d/%m/%Y')
            end_date_db = dates[1].strftime('%d/%m/%Y')

            cursor.execute(f"""SELECT `car_type_description`
FROM `car_types`
JOIN `cars` ON `cars`.`car_type` = `car_types`.`car_type_id`
WHERE `cars`.`car_license_number` = {car_license_number_from_db}""")
            car_type_description = cursor.fetchone()[0]

            if end_date and end_date != dates[1]:               
                #recipients & subject
                message_templates_id = 3
                cursor.execute(f"SELECT `recipients`, `subject` FROM `message_templates` WHERE `id` = {message_templates_id}")
                result = cursor.fetchone()
                recipients = result[0]
                subject = result[1]

                email_content = f"""<p> שלום, <br/> הלקוח: {users_object["first_name"]} {users_object["last_name"]} ת"ז: {driver_gov_id} מספר הזמנה: {order_id} <br/>
אסף את הרכב סוג הרכב:{car_type_description} מספר רישוי: {car_license_number_from_db} <br/>
תאריך איסוף הרכב שנקבע היה {start_date_db} הלקוח שינה את פרטי החזרת הרכב מתאריך:{end_date_db} לתאריך: {end_date} <br/>
לבדיקתך, <br/>
תודה רבה!
 <p/>""" 

                insert_query = "INSERT INTO messages (`rental_id`, `template_id`, `time_sent`, `recipients`, `subject`, `text`, `status`) VALUES (%s, %s, %s, %s, %s, %s, %s)"
                values = (rental_id, message_templates_id, datetime.datetime.now(), recipients, subject, email_content, 0)
                cursor.execute(insert_query, values)
                conn.commit()    

            if start_date and start_date != dates[0]:               
                #recipients & subject
                message_templates_id = 10
                cursor.execute(f"SELECT `recipients`, `subject` FROM `message_templates` WHERE `id` = {message_templates_id}")
                result = cursor.fetchone()
                recipients = result[0]
                subject = result[1]

                email_content = f"""<p> שלום, <br/> הלקוח: {users_object["first_name"]} {users_object["last_name"]} ת"ז: {driver_gov_id} מספר הזמנה: {order_id} <br/>
אסף את הרכב סוג הרכב:{car_type_description} מספר רישוי: {car_license_number_from_db} בתאריך: {start_date} <br/> 
בשונה ממועד האיסוף המתוכנן שנקבע בתאריך {start_date_db} 
 <br/>
לבדיקתך, <br/>
תודה רבה!
 <p/>""" 

                insert_query = "INSERT INTO messages (`rental_id`, `template_id`, `time_sent`, `recipients`, `subject`, `text`, `status`) VALUES (%s, %s, %s, %s, %s, %s, %s)"
                values = (rental_id, message_templates_id, datetime.datetime.now(), recipients, subject, email_content, 0)
                cursor.execute(insert_query, values)
                conn.commit()      

    except ValueError as ve:
        return jsonify({'error': f"order dates update fails: {ve}"}), 400
    
    try:
        # return kilometers
        if len(last_rental) >= 2:
            last_rental = last_rental[1][0]
            cursor.execute(f"SELECT return_kilometers, order_id FROM rentals WHERE rental_id = {last_rental}")
            result = cursor.fetchone()
            return_kilometers = result[0]
            older_order = result[1]

            cursor.execute(f"SELECT `last_name`, `first_name`, `gov_id` FROM `users` JOIN `orders` ON `customer_id` = `users`.`id` WHERE `order_id` = {older_order} ")
            set_user = cursor.fetchone()

            if return_kilometers and return_kilometers != rentals['return_kilometers']:
                #recipients & subject
                message_templates_id = 4
                cursor.execute(f"SELECT `recipients`, `subject` FROM `message_templates` WHERE `id` = {message_templates_id}")
                result = cursor.fetchone()
                recipients = result[0]
                subject = result[1]

                email_content = f"""<p> שלום, <br/> הלקוח: {users_object["first_name"]} {users_object["last_name"]} ת"ז: {driver_gov_id} מספר הזמנה: {order_id} <br/>
אסף את הרכב סוג הרכב:{car_type_description} מספר רישוי: {car_license_number_from_db} <br/> 
דיווח נסועה התחלתית {rentals['return_kilometers']} <br/> 
אשר לא תואמת לנסועה של הנסיעה הקודמת {return_kilometers} בהזמנה: {older_order} על ידי הלקוח {set_user[0]} {set_user[1]} ת"ז: {set_user[2]} 
 <br/>
לבדיקתך, <br/>
תודה רבה!
 <p/>""" 

                insert_query = "INSERT INTO messages (`rental_id`, `template_id`, `time_sent`, `recipients`, `subject`, `text`, `status`) VALUES (%s, %s, %s, %s, %s, %s, %s)"
                values = (rental_id, message_templates_id, datetime.datetime.now(), recipients, subject, email_content, 0)
                cursor.execute(insert_query, values)
                conn.commit()    

    except ValueError as ve:
        return jsonify({'error': f"pickup kilometers update fails: {ve}"}), 400

    response = {"update": "successfuly"}
    return jsonify(response), 200
    
        
        
