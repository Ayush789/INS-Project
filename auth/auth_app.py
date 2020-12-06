from flask import Flask
from flask.json import jsonify

app = Flask(__name__)

@app.route("/",methods=["POST"])
def auth():
    return jsonify({"accepted":True,"token":"abc"})

if __name__=="__main__":
    app.run(port=5000)