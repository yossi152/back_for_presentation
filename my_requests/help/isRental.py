from flask import jsonify


def is_rental(cursor, driver_code):
    try:
        cursor.execute(f"""
            SELECT `rentals`.`return_kilometers` 
            FROM `rentals`
            JOIN `users` ON `users`.`id` = `rentals`.`driver_id`
            WHERE `users`.`driver_code` = {driver_code}
            ORDER BY `rentals`.`rental_id` DESC LIMIT 1   
         """)
        return_kilometers = cursor.fetchone()
        if return_kilometers[0] is not None:
            return False
        else:
            return True
    except Exception as e:
        return jsonify({'error': str(e)}), 500
        

        
