import csv
import mysql.connector

# # Replace with your database credentials
# db_config = {
#     'host': 'your_host',
#     'user': 'your_user',
#     'password': 'your_password',
#     'database': 'your_database'
# }

# Connect to the database
connection = mysql.connector.connect(
    host="127.0.0.1", # שם המארח
    user="root", # יוזר
    password="!Yossigri770", # סיסמא
    database="guydigital_dev" # שם של הבסיס נתונים
)
cursor = connection.cursor()

# Get a list of all tables in the database
cursor.execute("SHOW TABLES")
tables = [table[0] for table in cursor.fetchall()]

# Fetch data from each table and save to a CSV file
with open('all_data.csv', 'w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)
    
    for table in tables:
        cursor.execute(f"SELECT * FROM {table}")
        table_data = cursor.fetchall()
        
        # Write table name as a comment before its data
        csv_writer.writerow([f'# Table: {table}'])
        
        if table_data:
            # Write column headers
            csv_writer.writerow([i[0] for i in cursor.description])
            
            # Write table data
            csv_writer.writerows(table_data)
        
        csv_writer.writerow([])  # Add an empty row between tables

# Close the cursor and connection
cursor.close()
connection.close()

#print("Data saved to 'all_data.csv'")
