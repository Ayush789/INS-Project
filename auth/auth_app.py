from flask import Flask, request
from flask.json import jsonify
import jwt
import json

app = Flask(__name__)

key = "secret"
id = "student"
password = "projectINS"

@app.route("/",methods=["POST"])
def auth():

    print("AuthServer")
    credentials = json.loads(request.get_data())

    if id!=credentials['id']:
        return jsonify({"Error": "Incorrect ID"})
    elif password!=credentials['password']:
        return jsonify({"Error": "Incorrect password"})
        
    encoded = jwt.encode({'key1': 'val1', 'key2': 'val2'}, key, algorithm='HS256').decode()

    print("Credentials Correct. Received{}".format(credentials))
    print("Token Generated {}".format(encoded))

    return jsonify({"accepted":True,"token":encoded})

if __name__=="__main__":
    app.run(port=5000)