import json
from pathlib import Path

import google.auth
from google import genai
from google.genai import types


AI_DIRECTORY = Path(__file__).resolve().parent
PROMPT_PATH = AI_DIRECTORY / "prompts" / "terraform_review.md"
MODEL_NAME = "gemini-2.5-flash"
VERTEX_AI_LOCATION = "global"


def load_text_file(file_path):
    return file_path.read_text(encoding="utf-8")


def load_reviewer_prompt():
    return load_text_file(PROMPT_PATH)


def build_review_request(prompt, retrieved_standards, resource_changes):
    plan_json = json.dumps(
        {"resource_changes": resource_changes},
        indent=2,
    )

    return f"""{prompt}

<platform_standards>
{retrieved_standards}
</platform_standards>

<terraform_plan>
{plan_json}
</terraform_plan>
"""


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


def generate_review(review_request):
    with get_vertex_client() as client:
        response = client.models.generate_content(
            model=MODEL_NAME,
            contents=review_request,
        )

    return response.text or "No review text was returned."
