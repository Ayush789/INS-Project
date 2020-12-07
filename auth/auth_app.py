from flask import Flask, request
from flask.json import jsonify
import json
import base64
import hmac
import time

app = Flask(__name__)


id = "student"
password = "projectINS"

key = b'\xffN.\xb64\xa9\xe3\x06\xed[\xc9u\xcc\xbb&\x1f'
def create_signed_token(data):
    header = json.dumps({'typ': 'JWT', 'alg': 'HS256'}).encode('utf-8')
    header_decode = base64.urlsafe_b64encode(header).decode().strip('=')
    payload = json.dumps(data).encode('utf-8')
    payload_decode = base64.urlsafe_b64encode(payload).decode().strip('=')
    hp_data = header_decode + '.' + payload_decode
    s = hmac.new(key, hp_data.encode('utf-8'), 'sha256')
    signature = s.digest()
    signature_decode = base64.urlsafe_b64encode(signature).decode().strip('=')
    token = hp_data + '.' + signature_decode
    return token


@app.route("/",methods=["POST"])
def auth():    
    print("AuthServer")
    credentials = json.loads(request.get_data())

    if id!=credentials['username']:
        return jsonify({"Error": "Incorrect ID"})
    elif password!=credentials['password']:
        return jsonify({"Error": "Incorrect password"})

    payload = {'username': id, 'valid': time.time()}   
    token = create_signed_token(payload)

    print("Credentials Received{}".format(credentials))
    print("Token Generated {}".format(token))

    return jsonify({"accepted":True,"token":token}) 

if __name__=="__main__":
    app.run(port=5000)