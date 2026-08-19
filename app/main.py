import os

from flask import Flask, jsonify


app = Flask(__name__)


@app.get("/")
def home():
    return jsonify(
        message="Hello from Cloud Run!",
        status="running",
    )


@app.get("/health")
def health():
    return jsonify(status="healthy"), 200


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
