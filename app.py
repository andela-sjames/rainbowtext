from flask import Flask
from flask import request, render_template

app = Flask(__name__)


@app.route('/', methods=['GET', ])
def index():
    if request.method == 'GET':
        return render_template("home.html")


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
