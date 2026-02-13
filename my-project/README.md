# Mitchell Lesser - Professional Resume Site

This is a professional resume and portfolio site built with [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).

## 🚀 Quick Start

### Prerequisites

- Python 3.8 or higher
- pip (Python package installer)

### Local Development

1. **Install dependencies:**
   ```bash
   cd my-project
   pip install -r requirements.txt
   ```

2. **Start development server:**
   ```bash
   mkdocs serve
   ```
   
   The site will be available at `http://127.0.0.1:8000`

3. **Build site:**
   ```bash
   mkdocs build --strict --clean
   ```
   
   The static site will be generated in the `site/` directory.

## 📁 Project Structure

```
my-project/
├── docs/                  # Documentation source files
│   ├── index.md          # Home page
│   ├── resume.md         # Resume/CV page
│   └── contact.md        # Contact information page
├── mkdocs.yml            # MkDocs configuration
├── requirements.txt      # Python dependencies
└── site/                 # Generated static site (after build)
```

## ⚙️ Configuration

### Site Metadata

The site configuration is in `mkdocs.yml`:

- **Site Name:** Mitchell Lesser | Azure Cloud Leader
- **Theme:** Material for MkDocs with professional color scheme
- **Features:** Search, responsive design, dark mode, social links

### Customization

To customize the site:

1. **Content:** Edit Markdown files in the `docs/` directory
2. **Theme colors:** Modify `theme.palette` in `mkdocs.yml`
3. **Navigation:** Update `nav` section in `mkdocs.yml`
4. **Social links:** Edit `extra.social` in `mkdocs.yml`

## 🔧 Build Commands

### Development

```bash
# Start live-reload server
mkdocs serve

# Start on specific port
mkdocs serve --dev-addr=127.0.0.1:8080
```

### Production Build

```bash
# Build with strict mode (fails on warnings)
mkdocs build --strict --clean

# Build without strict mode
mkdocs build --clean
```

### Deployment

The site automatically deploys to GitHub Pages via GitHub Actions when changes are pushed to the `main` branch.

**GitHub Actions Workflow:** `.github/workflows/mkdocs-pages.yml`

## 📦 Dependencies

Core dependencies (see `requirements.txt` for versions):

- **mkdocs** - Static site generator
- **mkdocs-material** - Material theme for MkDocs
- **pymdown-extensions** - Markdown extensions
- **pillow** & **cairosvg** - For social cards generation (CI only)
- **pygments** - Syntax highlighting

## 🎨 Features

### Material Theme Features

- ✅ **Responsive Design** - Mobile-friendly layout
- ✅ **Dark Mode** - Light/dark theme toggle
- ✅ **Search** - Full-text search functionality
- ✅ **Navigation** - Sticky tabs and instant navigation
- ✅ **Admonitions** - Callout blocks for important information
- ✅ **Icons** - Material icons and emoji support
- ✅ **Code Highlighting** - Syntax highlighting for code blocks
- ✅ **Social Links** - LinkedIn, GitHub integration

### Markdown Extensions

- **Admonitions** - Call-out boxes (info, tip, warning, etc.)
- **Icons & Emojis** - Material Design icons and emoji support
- **Code Blocks** - Syntax highlighting with copy button
- **Tables** - Markdown table support
- **Task Lists** - Checkboxes and task lists
- **Tabbed Content** - Organize content in tabs

## 🌐 Deployment

### GitHub Pages (Automated)

The site automatically deploys to GitHub Pages via GitHub Actions:

1. Push changes to `main` branch
2. GitHub Actions builds the site
3. Site deploys to `https://<username>.github.io/<repo>/`

### Manual Deployment

You can also deploy manually using:

```bash
mkdocs gh-deploy
```

This command builds the site and pushes to the `gh-pages` branch.

## 📝 Content Management

### Updating Resume

1. Edit `docs/resume.md` with your professional experience
2. Use Markdown formatting for structure
3. Add admonitions for highlights:
   ```markdown
   !!! success "Key Achievement"
       Your achievement here
   ```

### Adding New Pages

1. Create a new `.md` file in `docs/`
2. Add the page to navigation in `mkdocs.yml`:
   ```yaml
   nav:
     - Home: index.md
     - Resume: resume.md
     - New Page: new-page.md
     - Contact: contact.md
   ```

## 🔍 Testing

### Local Testing

```bash
# Test build process
mkdocs build --strict --clean

# Verify no broken links
mkdocs build --strict

# Check configuration
mkdocs --version
```

### CI/CD Testing

The GitHub Actions workflow tests the build on every push to ensure:

- Dependencies install correctly
- Site builds without errors in strict mode
- Generated site is valid

## 🛠️ Maintenance

### Updating Dependencies

To update to the latest compatible versions:

```bash
# Update pip
pip install --upgrade pip

# Update all packages
pip install --upgrade -r requirements.txt

# Test after updates
mkdocs build --strict --clean
```

### Version Pinning

Dependencies in `requirements.txt` use compatible version ranges:
- `mkdocs>=1.5.3,<2.0.0` - Allows minor updates, prevents breaking changes
- This ensures build reproducibility while allowing security patches

## 📚 Resources

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [PyMdown Extensions](https://facelessuser.github.io/pymdown-extensions/)
- [Markdown Guide](https://www.markdownguide.org/)

## 📄 License

Content © 2024 Mitchell Lesser. All rights reserved.

## 🤝 Contributing

This is a personal resume site. For suggestions or issues, please open an issue on GitHub.

---

**Built with:** Material for MkDocs  
**Last Updated:** 2024
