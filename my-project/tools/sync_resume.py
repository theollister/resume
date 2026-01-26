from __future__ import annotations

from pathlib import Path


def main() -> None:
    repo_root = Path(__file__).resolve().parents[2]

    source = repo_root / "resume" / "resume.md"
    target = repo_root / "my-project" / "docs" / "index.md"

    if not source.exists():
        raise SystemExit(f"Source resume not found: {source}")

    content = source.read_text(encoding="utf-8")

    # Make bare LinkedIn URLs clickable.
    content = content.replace(" linkedin.com/", " https://linkedin.com/")
    content = content.replace(" linkedin.com", " https://linkedin.com")

    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(content, encoding="utf-8")


if __name__ == "__main__":
    main()
