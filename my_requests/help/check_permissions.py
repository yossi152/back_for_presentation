def check_permissions(cursor, driver_code):
    cursor.execute(f"SELECT `permissions` FROM `users` WHERE `driver_code` = {driver_code}")
    permissions = cursor.fetchone()[0]
    permissions_array = []

    if permissions & 0b0001:
        permissions_array.append("Customer")

    if permissions & 0b0010:
        permissions_array.append("Administrative driver")

    if permissions & 0b0100:
        permissions_array.append("Manager")

    if permissions & 0b1000:
        permissions_array.append("Admin")

    return permissions_array
