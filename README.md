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

#### Using pip (alternative method)

If you prefer not to use Nix, you can set up the development environment using pip:

1. **Create a virtual environment (recommended):**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Linux/macOS
   # or on Windows: venv\Scripts\activate
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run local development server:**
   ```bash
   mkdocs serve
   ```
   
   Open http://127.0.0.1:8000 in your browser. Changes to markdown files will auto-reload.

4. **Build static site:**
   ```bash
   mkdocs build
   # Output in ./site/
   ```

## Deployment

Documentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch via GitHub Actions.

No manual build or deployment steps needed!
