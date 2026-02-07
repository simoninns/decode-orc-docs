# decode-orc-docs

This repository contains the user documentation for [Decode Orc](https://github.com/simoninns/decode-orc).

Built with [MkDocs](https://www.mkdocs.org/) and [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).

## Live Site

The documentation is available at: https://simoninns.github.io/decode-orc-docs/

## Adding/Editing Documentation

Simply add or edit markdown files in the `docs/` folder. The navigation sidebar is automatically generated from the folder structure.

### Folder Organization

- Place files in `docs/` or organized subdirectories
- Navigation is auto-generated from folder structure
- Use `.pages` files to customize ordering (optional)

### Local Development

#### Using Nix (recommended for decode-orc developers)

1. **Enter development shell:**
   ```bash
   nix develop
   ```

2. **Run local development server:**
   ```bash
   mkdocs serve
   ```
   
   Open http://127.0.0.1:8000 in your browser. Changes to markdown files will auto-reload.

3. **Build static site:**
   ```bash
   nix build
   # Output in ./result/
   ```

#### Using pip (alternative)

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run local development server:**
   ```bash
   mkdocs serve
   ```
   
   Open http://127.0.0.1:8000 in your browser. Changes to markdown files will auto-reload.

3. **Build static site:**
   ```bash
   mkdocs build
   ```
   
   Output will be in the `site/` folder.

## Deployment

Documentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch via GitHub Actions.

No manual build or deployment steps needed!

## Project Structure

```
decode-orc-docs/
├── docs/               # Documentation markdown files
│   ├── index.md       # Home page
│   ├── installation/  # Installation guides
│   ├── guides/        # User guides
│   └── .pages         # Optional navigation customization
├── mkdocs.yml         # MkDocs configuration
├── flake.nix          # Nix flake for reproducible builds
├── flake.lock         # Locked dependency versions
└── requirements.txt   # Python dependencies (for non-Nix users)
```
