"""Create a managed Vertex AI RAG corpus for platform-standard documents."""

import argparse
import os

import vertexai
from vertexai import rag


EMBEDDING_MODEL = "publishers/google/models/text-embedding-005"


def find_corpus(display_name: str):
    """Return an existing corpus with this display name, if one exists."""
    for corpus in rag.list_corpora():
        if corpus.display_name == display_name:
            return corpus

    return None


def create_corpus(project_id: str, location: str, display_name: str):
    """Create the corpus, unless one with the same display name already exists."""
    vertexai.init(project=project_id, location=location)

    existing_corpus = find_corpus(display_name)
    if existing_corpus:
        print(f"RAG corpus already exists: {existing_corpus.name}")
        return existing_corpus

    embedding_model_config = rag.RagEmbeddingModelConfig(
        vertex_prediction_endpoint=rag.VertexPredictionEndpoint(
            publisher_model=EMBEDDING_MODEL
        )
    )

    corpus = rag.create_corpus(
        display_name=display_name,
        description="Platform standards used to ground Terraform AI reviews.",
        backend_config=rag.RagVectorDbConfig(
            rag_embedding_model_config=embedding_model_config
        ),
    )

    print(f"Created RAG corpus: {corpus.name}")
    return corpus


def parse_args() -> argparse.Namespace:
    """Read the corpus configuration supplied at the command line."""
    parser = argparse.ArgumentParser(description="Create a Vertex AI RAG corpus.")
    parser.add_argument(
        "--project-id",
        default=os.environ.get("GOOGLE_CLOUD_PROJECT"),
        help="Google Cloud project ID. Defaults to GOOGLE_CLOUD_PROJECT.",
    )
    parser.add_argument("--location", default="us-central1")
    parser.add_argument(
        "--display-name",
        default="gap-dev-platform-standards",
        help="Human-readable name for the RAG corpus.",
    )
    args = parser.parse_args()

    if not args.project_id:
        parser.error("--project-id or GOOGLE_CLOUD_PROJECT is required.")

    return args


def main() -> None:
    """Create the configured RAG corpus."""
    args = parse_args()
    create_corpus(args.project_id, args.location, args.display_name)


if __name__ == "__main__":
    main()
