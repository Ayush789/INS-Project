from flask import Flask, request, jsonify
import os
import base64
import json

app = Flask(__name__)


def validate_token(token):
    return True


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
