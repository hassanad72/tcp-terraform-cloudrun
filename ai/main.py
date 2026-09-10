import argparse
import json
import os

from plan_parser import (
    get_resource_changes,
    load_terraform_plan,
    redact_sensitive_values,
)
from reviewer import (
    MODEL_NAME,
    build_review_request,
    generate_review,
    load_reviewer_prompt,
)
from rag.retrieve_context import format_contexts, retrieve_contexts


RAG_LOCATION = "us-central1"
RAG_TOP_K = 3


def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Review a Terraform JSON plan against platform standards."
    )
    parser.add_argument(
        "plan",
        help="Path to the Terraform JSON plan.",
    )
    return parser.parse_args()


def main():
    args = parse_arguments()

    plan = load_terraform_plan(args.plan)
    resource_changes = get_resource_changes(plan)
    safe_resource_changes = redact_sensitive_values(resource_changes)
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    corpus_name = os.environ.get("RAG_CORPUS_NAME")

    if not project_id:
        raise RuntimeError("GOOGLE_CLOUD_PROJECT is required for RAG retrieval.")

    if not corpus_name:
        raise RuntimeError("RAG_CORPUS_NAME is required for RAG retrieval.")

    retrieval_query = json.dumps(
        {"resource_changes": safe_resource_changes},
        indent=2,
    )
    retrieved_contexts = retrieve_contexts(
        project_id=project_id,
        location=RAG_LOCATION,
        corpus_name=corpus_name,
        query=retrieval_query,
        top_k=RAG_TOP_K,
    )
    retrieved_standards = format_contexts(retrieved_contexts)
    prompt = load_reviewer_prompt()
    review_request = build_review_request(
        prompt,
        retrieved_standards,
        safe_resource_changes,
    )

    print(f"Found {len(resource_changes)} resource changes.\n")

    for change in resource_changes:
        address = change.get("address")
        actions = change.get("change", {}).get("actions", [])

        print(f"Resource: {address}")
        print(f"Actions: {actions}")
        print("-" * 40)

    print(f"Retrieved {len(retrieved_contexts)} relevant standards chunk(s).")
    print(f"\nPrepared review request: {len(review_request)} characters")
    print(f"Requesting review from {MODEL_NAME}...\n")

    review = generate_review(review_request)

    print("## AI Terraform Review\n")
    print(review)


if __name__ == "__main__":
    main()
