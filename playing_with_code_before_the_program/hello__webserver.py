from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!\n Hi Tami!"

if __name__ == "__main__":
    app.run()
