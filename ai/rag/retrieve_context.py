"""Retrieve relevant company-standard chunks from a Vertex AI RAG corpus."""

import argparse
import os

import vertexai
from vertexai import rag


def retrieve_contexts(
    project_id: str,
    location: str,
    corpus_name: str,
    query: str,
    top_k: int,
):
    """Search a corpus and return the most relevant document chunks."""
    vertexai.init(project=project_id, location=location)

    response = rag.retrieval_query(
        rag_resources=[rag.RagResource(rag_corpus=corpus_name)],
        text=query,
        rag_retrieval_config=rag.RagRetrievalConfig(top_k=top_k),
    )

    return response.contexts.contexts


def print_contexts(contexts) -> None:
    """Print retrieved chunks with their source document URI."""
    if not contexts:
        print("No relevant standards were found.")
        return

    for index, context in enumerate(contexts, start=1):
        print(f"\n--- Result {index} ---")
        print(f"Source: {context.source_uri}")
        print(context.text)


def format_contexts(contexts) -> str:
    """Format retrieved chunks for inclusion in a Gemini review request."""
    return "\n\n".join(
        f"Source: {context.source_uri}\n{context.text}" for context in contexts
    )


def parse_args() -> argparse.Namespace:
    """Read retrieval settings supplied at the command line."""
    parser = argparse.ArgumentParser(
        description="Retrieve relevant standards from a Vertex AI RAG corpus."
    )
    parser.add_argument(
        "--project-id",
        default=os.environ.get("GOOGLE_CLOUD_PROJECT"),
        help="Google Cloud project ID. Defaults to GOOGLE_CLOUD_PROJECT.",
    )
    parser.add_argument("--location", default="us-central1")
    parser.add_argument(
        "--corpus-name",
        required=True,
        help="Full resource name of the RAG corpus to search.",
    )
    parser.add_argument(
        "--query",
        required=True,
        help="Question or Terraform-related text used to search the corpus.",
    )
    parser.add_argument(
        "--top-k",
        type=int,
        default=3,
        help="Maximum number of relevant chunks to return. Defaults to 3.",
    )
    args = parser.parse_args()

    if not args.project_id:
        parser.error("--project-id or GOOGLE_CLOUD_PROJECT is required.")

    if args.top_k < 1:
        parser.error("--top-k must be at least 1.")

    return args


def main() -> None:
    """Retrieve and display the most relevant company standards."""
    args = parse_args()
    contexts = retrieve_contexts(
        project_id=args.project_id,
        location=args.location,
        corpus_name=args.corpus_name,
        query=args.query,
        top_k=args.top_k,
    )
    print_contexts(contexts)


if __name__ == "__main__":
    main()
