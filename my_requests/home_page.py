from flask import jsonify
from my_requests.help.check_permissions import check_permissions
from my_requests.help.initial import initial
from my_requests.help.isRental import is_rental


def home_page():
    conn, cursor, driver_code, order_id = initial()

    results = {'role': check_permissions(cursor, driver_code),
               'is_rental': is_rental(cursor, driver_code)
               }
    return jsonify(results), 200