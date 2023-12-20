import datetime


def get_current_date():
    current_date = datetime.datetime.now().date()
    formatted_date = current_date.strftime('%Y-%m-%d')
    return formatted_date

def get_current_year():
    current_date = datetime.datetime.now().date()
    formatted_date = current_date.strftime('%Y')
    return formatted_date

def get_current_time():
    now = datetime.datetime.now()
    formatted_time = now.strftime("%H:%M")
    return formatted_time

def get_datetime_string(time_str):
    return f"2024-01-01 {time_str}:00"

