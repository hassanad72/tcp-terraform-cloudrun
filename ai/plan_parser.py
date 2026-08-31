import json


REDACTED_VALUE = "[REDACTED]"
SENSITIVE_FIELD_MARKERS = (
    "password",
    "secret",
    "token",
    "api_key",
    "private_key",
    "credential",
    "authorization",
)


def load_terraform_plan(file_path):
    with open(file_path, "r", encoding="utf-8") as file:
        return json.load(file)


def get_resource_changes(plan):
    changed_resources = []

    for resource in plan.get("resource_changes", []):
        actions = resource.get("change", {}).get("actions", [])

        if actions != ["no-op"]:
            changed_resources.append(resource)

    return changed_resources


def redact_sensitive_values(value, field_name=""):
    if any(marker in field_name.lower() for marker in SENSITIVE_FIELD_MARKERS):
        return REDACTED_VALUE

    if isinstance(value, dict):
        return {
            key: redact_sensitive_values(item, key)
            for key, item in value.items()
        }

    if isinstance(value, list):
        return [redact_sensitive_values(item, field_name) for item in value]

    return value
