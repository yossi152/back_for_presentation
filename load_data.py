import mysql.connector

# Connect to the database
connection = mysql.connector.connect(
    host="127.0.0.1", # שם המארח
    user="root", # יוזר
    password="!Yossigri770", # סיסמא
    database="guydigital_dev" # שם של הבסיס נתונים
)
cursor = connection.cursor()

# Read the CSV file and extract data sections
csv_path = 'all_data.csv'

with open(csv_path, 'r') as csv_file:
    lines = csv_file.readlines()

# Create a dictionary to store table data
table_data = {}
current_table = None

for line in lines:
    if line.startswith('# Table: '):
        current_table = line.strip('# Table: ').strip()
        table_data[current_table] = []
    elif current_table and line.strip():
        table_data[current_table].append(line.strip())

# Load data from dictionary into each table
for table_name, data_lines in table_data.items():
    load_query = f"""
        LOAD DATA LOCAL INFILE '{csv_path}'
        INTO TABLE {table_name}
        FIELDS TERMINATED BY ','
        LINES TERMINATED BY '\\n'
        IGNORE 1 LINES
        ({','.join(data_lines)});
    """
    cursor.execute(load_query)

# Commit changes and close the connection
connection.commit()
connection.close()

#print("Data loaded from CSV file to all tables in the database.")
