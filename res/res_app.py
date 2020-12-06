from flask import Flask, request, jsonify
import os
import base64
import json
import hmac

app = Flask(__name__)

key = 'secret'

def validate_token(token):
    (header, payload, signature) = token.split('.')
    hp_data = header + '.' + payload
    d = hmac.new(key, hp_data.encode('utf-8'), 'sha256')
    dig = d.digest()
    denc = base64.urlsafe_b64encode(dig).decode().strip('=')
    verified = hmac.compare_digest(signature, denc)
    payload += '=' * (-len(payload) % 4)
    payload_data = json.loads(base64.urlsafe_b64decode(payload).decode())
    print("Payload Data: {}".format(payload_data))
    return verified


@app.route("/",methods=["POST"])
def fetch():
    data = json.loads(request.get_data())
    if "token" not in data.keys():
        return jsonify({"accepted": False})

    token = data["token"]
    if validate_token(token):
        if "res" not in data.keys():
            return jsonify({"accepted": True, "reslist": os.listdir("resources")})
        res = data["res"]
        file_data = open("resources/"+res,"rb").read()
        b64 = base64.b64encode(file_data).decode('ascii')

        return jsonify({"accepted": True, "res": b64})
    else:
        return jsonify({"accepted": False})


if __name__ == "__main__":
    app.run(port=8080)
