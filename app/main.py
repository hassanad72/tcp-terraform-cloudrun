import os
from functools import lru_cache

import google.auth
from flask import Flask, jsonify, request
from google import genai
from google.genai import types


app = Flask(__name__)

MODEL_NAME = os.environ.get("VERTEX_AI_MODEL", "gemini-2.5-flash")
VERTEX_AI_LOCATION = os.environ.get("VERTEX_AI_LOCATION", "global")
MAX_PROMPT_LENGTH = 10_000


@lru_cache(maxsize=1)
def get_vertex_client():
    credentials, project_id = google.auth.default(
        scopes=["https://www.googleapis.com/auth/cloud-platform"]
    )

    if not project_id:
        raise RuntimeError("Google Cloud project ID could not be determined.")

    return genai.Client(
        vertexai=True,
        project=project_id,
        location=VERTEX_AI_LOCATION,
        credentials=credentials,
        http_options=types.HttpOptions(api_version="v1"),
    )


@app.get("/")
def home():
    return jsonify(
        message="Hello from Cloud Run!",
        status="running",
    )


@app.get("/health")
def health():
    return jsonify(status="healthy"), 200


@app.post("/chat")
def chat():
    body = request.get_json(silent=True)

    if not isinstance(body, dict):
        return jsonify(error="Request body must be valid JSON."), 400

    prompt = body.get("prompt")

    if not isinstance(prompt, str) or not prompt.strip():
        return jsonify(error="The 'prompt' field must be a non-empty string."), 400

    if len(prompt) > MAX_PROMPT_LENGTH:
        return jsonify(error="The prompt is too long."), 400

    try:
        response = get_vertex_client().models.generate_content(
            model=MODEL_NAME,
            contents=prompt.strip(),
        )
        generated_text = response.text or ""
    except Exception:
        app.logger.exception("Vertex AI request failed")
        return jsonify(error="Unable to generate a response right now."), 500

    return jsonify(
        model=MODEL_NAME,
        response=generated_text,
    )


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
