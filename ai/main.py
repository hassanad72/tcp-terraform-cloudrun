import argparse

from plan_parser import (
    get_resource_changes,
    load_terraform_plan,
    redact_sensitive_values,
)
from reviewer import (
    MODEL_NAME,
    build_review_request,
    generate_review,
    load_reviewer_context,
)


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
    prompt, standards = load_reviewer_context()
    review_request = build_review_request(
        prompt,
        standards,
        safe_resource_changes,
    )

    print(f"Found {len(resource_changes)} resource changes.\n")

    for change in resource_changes:
        address = change.get("address")
        actions = change.get("change", {}).get("actions", [])

        print(f"Resource: {address}")
        print(f"Actions: {actions}")
        print("-" * 40)

    print(f"\nPrepared review request: {len(review_request)} characters")
    print(f"Requesting review from {MODEL_NAME}...\n")

    review = generate_review(review_request)

    print("## AI Terraform Review\n")
    print(review)


if __name__ == "__main__":
    main()
