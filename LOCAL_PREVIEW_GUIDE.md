# Local Preview Guide - MkDocs Development

**Project:** Mitchell Lesser Resume Site  
**Location:** `/my-project/`  
**Framework:** MkDocs with Material theme

---

## Quick Start

### Start Local Development Server

```bash
# Navigate to project directory
cd my-project

# Start the development server
mkdocs serve

# Server will start at:
# http://127.0.0.1:8000/
```

The development server will:
- ✅ Auto-reload when you save changes
- ✅ Show live preview in your browser
- ✅ Display build warnings in terminal
- ✅ Hot-reload CSS and JavaScript changes

---

## First Time Setup

### 1. Install Python (if not already installed)

**macOS/Linux:**
```bash
python3 --version
# Should show Python 3.8 or higher
```

**Windows:**
```bash
python --version
# Should show Python 3.8 or higher
```

If Python is not installed, download from [python.org](https://www.python.org/downloads/)

---

### 2. Install Dependencies

```bash
# Navigate to project directory
cd my-project

# Install MkDocs and plugins
pip install -r requirements.txt

# Verify installation
mkdocs --version
# Should show: mkdocs, version 1.5.3 or higher
```

**Using Virtual Environment (Recommended):**
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

---

## Development Workflow

### Typical Development Session

```bash
# 1. Navigate to project
cd my-project

# 2. (Optional) Activate virtual environment
source venv/bin/activate  # macOS/Linux
# OR
venv\Scripts\activate     # Windows

# 3. Start development server
mkdocs serve

# 4. Open browser to http://127.0.0.1:8000/

# 5. Edit files in docs/ directory
# - index.md (Home page)
# - resume.md (Resume page)
# - contact.md (Contact page)

# 6. Save changes - browser auto-refreshes!

# 7. When done, stop server with Ctrl+C
```

---

## Common Tasks

### Edit Content

**Edit the home page:**
```bash
nano docs/index.md
# OR use your preferred editor
code docs/index.md
vim docs/index.md
```

**Edit the resume:**
```bash
nano docs/resume.md
```

**Edit contact information:**
```bash
nano docs/contact.md
```

After saving, changes appear immediately in browser!

---

### Preview Production Build

The development server (`mkdocs serve`) shows draft content.  
To test the exact build that CI/CD will create:

```bash
# Build in production mode
mkdocs build --strict --clean

# This creates the site/ directory
# View output:
ls -la site/

# Open in browser (macOS):
open site/index.html

# Open in browser (Linux):
xdg-open site/index.html

# Open in browser (Windows):
start site/index.html
```

**What `--strict --clean` does:**
- `--strict`: Treats warnings as errors (matches CI/CD)
- `--clean`: Removes old files before building

---

### Check for Build Errors

```bash
# Build with strict error checking
mkdocs build --strict --clean

# If successful, you'll see:
# INFO - Cleaning site directory
# INFO - Building documentation to directory: .../site
# INFO - Documentation built in X.XX seconds

# If errors exist, they'll be displayed and build will fail
```

---

### Test Configuration Changes

```bash
# Edit the configuration
nano mkdocs.yml

# Test with build
mkdocs build --strict --clean

# If successful, start dev server to preview
mkdocs serve
```

---

## Customization

### Change Theme Colors

Edit `mkdocs.yml`:
```yaml
theme:
  palette:
    - scheme: default
      primary: blue      # Change to: indigo, teal, green, etc.
      accent: cyan       # Change to: orange, pink, etc.
```

Save and refresh browser to see changes instantly!

**Available colors:**
- Primary: red, pink, purple, indigo, blue, cyan, teal, green, lime, amber, orange, brown
- Accent: red, pink, purple, indigo, blue, cyan, teal, green, lime, amber, orange

---

### Add New Pages

**1. Create new Markdown file:**
```bash
# Create new page
nano docs/projects.md
```

**2. Add content:**
```markdown
# My Projects

## Project 1
Description here...

## Project 2
Description here...
```

**3. Add to navigation in `mkdocs.yml`:**
```yaml
nav:
  - Home: index.md
  - Resume: resume.md
  - Projects: projects.md    # <- Add this line
  - Contact: contact.md
```

**4. Preview:**
```bash
mkdocs serve
# New page appears in navigation!
```

---

### Add Images

**1. Add image to docs/images/:**
```bash
# Create images directory (if not exists)
mkdir -p docs/images

# Copy your image
cp ~/path/to/photo.jpg docs/images/

# OR download from URL
curl -o docs/images/photo.jpg https://example.com/photo.jpg
```

**2. Reference in Markdown:**
```markdown
![Profile Photo](images/photo.jpg)

<!-- Or with attributes: -->
![Profile Photo](images/photo.jpg){ width="300" }
```

**3. Preview:**
```bash
mkdocs serve
# Image appears on page!
```

---

## Troubleshooting

### Port Already in Use

**Error:** `[Errno 48] Address already in use`

**Solution:** Use different port:
```bash
mkdocs serve --dev-addr=127.0.0.1:8001
# Open: http://127.0.0.1:8001/
```

**OR** Kill existing server:
```bash
# Find process
lsof -i :8000

# Kill process
kill -9 <PID>
```

---

### Changes Not Appearing

**Solution 1:** Hard refresh browser:
- Chrome/Firefox: `Ctrl+Shift+R` (Windows/Linux) or `Cmd+Shift+R` (macOS)

**Solution 2:** Restart development server:
```bash
# Stop server: Ctrl+C
# Start again:
mkdocs serve
```

**Solution 3:** Clear MkDocs cache:
```bash
rm -rf .cache/
mkdocs serve
```

---

### Module Not Found Error

**Error:** `ModuleNotFoundError: No module named 'mkdocs'`

**Solution:** Install dependencies:
```bash
pip install -r requirements.txt
```

**OR** Activate virtual environment:
```bash
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows
```

---

### Build Warnings

**Warning:** `WARNING - A relative path to 'xyz' is included in the 'nav'...`

**Solution:** Check paths in `mkdocs.yml` nav section match actual file names

**Warning:** `WARNING - Doc file 'file.md' contains a link 'broken.md', but...`

**Solution:** Fix broken link in Markdown file

---

## Keyboard Shortcuts (in Terminal)

| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Stop the development server |
| `Ctrl+Z` | Pause server (not recommended) |
| `↑` (Up arrow) | Previous command |
| `Ctrl+L` | Clear terminal screen |

---

## File Locations

```
my-project/
├── mkdocs.yml              # Main configuration
├── requirements.txt        # Python dependencies
├── docs/                   # Content directory
│   ├── index.md           # Home page
│   ├── resume.md          # Resume page
│   ├── contact.md         # Contact page
│   └── images/            # Images directory
│       └── (your images)
├── site/                   # Build output (generated)
└── .cache/                 # MkDocs cache (generated)
```

**Edit these:**
- ✅ `docs/*.md` - Page content
- ✅ `docs/images/` - Images
- ✅ `mkdocs.yml` - Configuration

**Don't edit these:**
- ❌ `site/` - Auto-generated by build
- ❌ `.cache/` - Auto-generated cache

---

## Useful Commands

```bash
# Start development server
mkdocs serve

# Start on different port
mkdocs serve --dev-addr=127.0.0.1:8001

# Build site (production)
mkdocs build

# Build with strict error checking (matches CI)
mkdocs build --strict --clean

# Show MkDocs version
mkdocs --version

# Show help
mkdocs --help

# Clean build output
rm -rf site/ .cache/
```

---

## Next Steps

### Ready to Deploy?

1. ✅ Test locally: `mkdocs serve`
2. ✅ Test production build: `mkdocs build --strict --clean`
3. ✅ Commit changes: `git add . && git commit -m "Update docs"`
4. ✅ Push to GitHub: `git push`
5. ✅ Merge to `main` branch
6. ✅ GitHub Actions automatically deploys!

### Learn More

- **MkDocs Documentation:** https://www.mkdocs.org/
- **Material Theme:** https://squidfunk.github.io/mkdocs-material/
- **Markdown Guide:** https://www.markdownguide.org/

---

## Support Files

- **CI/CD Verification:** `CI_CD_VERIFICATION_REPORT.md`
- **GitHub Setup:** `GITHUB_PAGES_SETUP_CHECKLIST.md`
- **MkDocs Config:** `my-project/mkdocs.yml`

---

## Quick Reference Card

```
┌─────────────────────────────────────────────┐
│  LOCAL MKDOCS PREVIEW - QUICK REFERENCE     │
├─────────────────────────────────────────────┤
│                                             │
│  Start Server:   mkdocs serve               │
│  Open Browser:   http://127.0.0.1:8000/    │
│  Stop Server:    Ctrl+C                     │
│                                             │
│  Production:     mkdocs build --strict      │
│  View Build:     open site/index.html      │
│                                             │
│  Edit Content:   docs/*.md                  │
│  Edit Config:    mkdocs.yml                 │
│  Add Images:     docs/images/               │
│                                             │
│  Auto-reload:    ✅ Enabled                 │
│  Live Preview:   ✅ Enabled                 │
│                                             │
└─────────────────────────────────────────────┘
```

---

**Last Updated:** 2024-02-13  
**MkDocs Version:** 1.5.3+  
**Material Version:** 9.5.0+
