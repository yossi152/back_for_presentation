

import datetime
from flask import jsonify, request
from my_requests.help.initial import initial


def check_card():
    conn, cursor, driver_code, order_id = initial()

    # driver_code = 11213
    # order_id = 9101112
    try:
        data = request.get_json()
        credit_card_numbers = data['numbers']
        credit_card_experience_mm_yy = data['experience']

        # Parse MM/YY format to a datetime.date object
        try:
            credit_card_experience_date = datetime.datetime.strptime(credit_card_experience_mm_yy, '%m/%y').date()
        except ValueError as ve:
            return jsonify({'error': f"Invalid date format: {ve}"}), 400

        # Execute the SQL query to retrieve credit card data from the database
        cursor.execute(f"SELECT credit_card, credit_card_validity FROM users WHERE driver_code={driver_code}")
        db_results = cursor.fetchall()

        # Assuming the retrieved data is a list of tuples with (credit_card, credit_card_validity)
        for row in db_results:
            db_credit_card, db_validity = row
            # Compare only month and year
            if db_credit_card == credit_card_numbers and db_validity.month == credit_card_experience_date.month and db_validity.year == credit_card_experience_date.year:
                response = {'valid': True}
                break
        else:
            response = {'valid': False}

        return jsonify(response), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
