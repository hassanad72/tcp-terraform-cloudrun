"""Import platform-standard documents from Cloud Storage into a RAG corpus."""

import argparse
import os

import vertexai
from vertexai import rag


DEFAULT_CHUNK_SIZE = 512
DEFAULT_CHUNK_OVERLAP = 100


def import_documents(
    project_id: str,
    location: str,
    corpus_name: str,
    gcs_uri: str,
):
    """Import one Cloud Storage document and let RAG Engine process it."""
    vertexai.init(project=project_id, location=location)

    response = rag.import_files(
        corpus_name,
        [gcs_uri],
        transformation_config=rag.TransformationConfig(
            rag.ChunkingConfig(
                chunk_size=DEFAULT_CHUNK_SIZE,
                chunk_overlap=DEFAULT_CHUNK_OVERLAP,
            )
        ),
    )

    print(f"Imported {response.imported_rag_files_count} document(s).")
    return response


def parse_args() -> argparse.Namespace:
    """Read the import configuration supplied at the command line."""
    parser = argparse.ArgumentParser(
        description="Import a Cloud Storage document into a Vertex AI RAG corpus."
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
        help="Full resource name of the target RAG corpus.",
    )
    parser.add_argument(
        "--gcs-uri",
        required=True,
        help="Cloud Storage URI of the document, such as gs://bucket/path/file.md.",
    )
    args = parser.parse_args()

    if not args.project_id:
        parser.error("--project-id or GOOGLE_CLOUD_PROJECT is required.")

    return args


def main() -> None:
    """Import the configured document into the configured corpus."""
    args = parse_args()
    import_documents(
        project_id=args.project_id,
        location=args.location,
        corpus_name=args.corpus_name,
        gcs_uri=args.gcs_uri,
    )


if __name__ == "__main__":
    main()
