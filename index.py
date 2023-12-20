
from flask import Flask
from flask_cors import CORS


from my_requests.get_ret import get_ret
from my_requests.home_page import home_page
from my_requests.photos import photos
from my_requests.post_pick import post_pick
from my_requests.post_ret import post_ret
from my_requests.get_pick import get_pick
from my_requests.check_card import check_card


TRAVEL_PHONE = "025807685"

app = Flask(__name__)
CORS(app)



@app.route('/api/homePage', methods=['GET'])
def get_hoemPage():
    return home_page()

@app.route('/api/pickAllData', methods=['GET'])
def get_pickAllData():
    return get_pick()

@app.route('/api/CheckCard', methods=['POST'])
def check_credit_card():
    return check_card()

@app.route('/api/postPhoto', methods=['POST'])
def post_photo():
    return photos()

@app.route('/api/retAllData', methods=['GET'])
def get_retAllData():
    return get_ret()
   
@app.route('/api/pickAllData', methods=['POST'])
def post_pickAllData():
    return post_pick()

@app.route('/api/retAllData', methods=['POST'])
def post_retAllData():
    return post_ret()    


if __name__ == '__main__':
    app.run(debug=True)
    
    # 
    #cursor.close()
    #conn.close()



