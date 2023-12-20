import string
import ssl
import smtplib
import random

def send_email(email, name, subject, msg):
    # Create random id
    characters = string.ascii_letters + string.digits
    random_id = ''.join(random.choice(characters) for _ in range(8))
    
    # Create email content
    file = f"""From: Service <service@guytours.co.il>
To: {name} <{email}>
Message-ID: <{random_id}@guytours.co.il>
Subject: {subject}
MIME-Version: 1.0
Content-Type: text/html

{msg}"""
    
    #print("Connecting to SMTP server")
    smtp_server = smtplib.SMTP("smtp.office365.com", port=587)
    #print("Generating SSL context")
    context = ssl.create_default_context()
    #print("Starting TLS")
    smtp_server.starttls(context=context)
    #print("Logging in to SMTP")
    smtp_server.login("service@guytours.co.il", "Cuk33461")
    #print("Sending message")
    smtp_server.sendmail("service@guytours.co.il", email, file)
    #print("Done!")
    return 0
