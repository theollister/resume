# MkDocs site

This repo publishes a Material for MkDocs site from `my-project/`.

## Local preview

From `my-project/`:

- `python -m pip install -r requirements.txt`
- `python tools/sync_resume.py`
- `mkdocs serve`

## Build (CI equivalent)

- `python tools/sync_resume.py`
- `mkdocs build --strict --clean`
