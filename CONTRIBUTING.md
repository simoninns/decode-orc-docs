# Contributing

Thanks for your interest in improving the decode-orc documentation.

## How to contribute

- Report errors, typos, or inaccuracies via GitHub Issues.
- Request new or improved content via GitHub Issues.
- Submit focused pull requests with clear descriptions.

## Before opening a pull request

- Search existing issues and pull requests first.
- Build the documentation locally and verify your change renders correctly.
- Keep changes focused on a single topic or fix per pull request.

## Building locally

The documentation uses [MkDocs](https://www.mkdocs.org/) with the [Material theme](https://squidfunk.github.io/mkdocs-material/).

Install dependencies:

```
pip install -r requirements.txt
```

Serve locally with live reload:

```
mkdocs serve
```

The site will be available at `http://127.0.0.1:8000`.

Build static output:

```
mkdocs build
```

## File structure

- `docs/` — All source Markdown content
- `docs/decode-orc/` — Decode-Orc application documentation
- `docs/encode-orc/` — Encode-Orc application documentation
- `docs/misc/` — Community, issue reporting, and migration pages
- `mkdocs.yml` — Site configuration

## Writing guidelines

- Use standard Markdown. Extensions available include syntax highlighting (```` ```language ````), task lists, and superfences.
- Keep each page focused on a single topic.
- Use sentence case for headings.
- Prefer short paragraphs and lists over dense prose.
- Place images and other assets in the `assets/` subfolder alongside the relevant page.
- Link to other pages using relative paths.

## Pull request checklist

- [ ] The change addresses one clear issue or topic
- [ ] Documentation builds successfully with `mkdocs build`
- [ ] Pages render correctly with `mkdocs serve`
- [ ] Links and images are valid
- [ ] Commit messages are clear

## Questions

If you are unsure about scope or placement of new content, open an issue to discuss first.
