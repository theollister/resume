# Build Instructions

## Overview

This document describes the build process for the Mitchell Lesser professional resume site using Material for MkDocs.

## Build Environment Requirements

### Python Version
- **Required:** Python 3.8+
- **Recommended:** Python 3.12 (as used in CI/CD)
- **Package Manager:** pip 23.0+

### System Dependencies

For full functionality including social cards generation:
- **libcairo2** - Cairo graphics library
- **libfreetype6** - Font rendering
- **libffi-dev** - Foreign function interface
- **libjpeg-dev** - JPEG image support
- **libpng-dev** - PNG image support
- **libz-dev** - Compression library

On Ubuntu/Debian:
```bash
apt-get update
apt-get install -y libcairo2-dev libfreetype6-dev libffi-dev libjpeg-dev libpng-dev libz-dev
```

## Local Build Process

### Step 1: Install Python Dependencies

```bash
cd my-project
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

**Expected Output:**
- All packages install successfully
- No dependency conflicts
- MkDocs version 1.5.3 or higher

### Step 2: Verify Installation

```bash
mkdocs --version
```

**Expected Output:**
```
mkdocs, version 1.6.x from ... (Python 3.x)
```

### Step 3: Build Site

```bash
mkdocs build --strict --clean
```

**Build Flags:**
- `--strict` - Treat warnings as errors (fails build on any warning)
- `--clean` - Remove old site directory before building

**Expected Output:**
```
INFO - Cleaning site directory
INFO - Building documentation to directory: .../site
INFO - Documentation built in X.XX seconds
```

### Step 4: Verify Build

```bash
# Check site directory was created
ls -la site/

# Verify key files exist
test -f site/index.html && echo "✓ Home page built"
test -f site/resume/index.html && echo "✓ Resume page built"
test -f site/contact/index.html && echo "✓ Contact page built"
test -f site/sitemap.xml && echo "✓ Sitemap generated"
test -f site/search/search_index.json && echo "✓ Search index created"
```

## CI/CD Build Process (GitHub Actions)

### Workflow File
`.github/workflows/mkdocs-pages.yml`

### Build Steps

1. **Checkout Repository**
   ```yaml
   - uses: actions/checkout@v4
   ```

2. **Setup Python**
   ```yaml
   - uses: actions/setup-python@v5
     with:
       python-version: "3.12"
       cache: pip
       cache-dependency-path: my-project/requirements.txt
   ```

3. **Install Dependencies**
   ```bash
   cd my-project
   python -m pip install --upgrade pip
   python -m pip install -r requirements.txt
   ```

4. **Build Site**
   ```bash
   cd my-project
   mkdocs --version
   mkdocs build --strict --clean
   ```

5. **Upload Artifact**
   ```yaml
   - uses: actions/upload-pages-artifact@v3
     with:
       path: my-project/site
   ```

6. **Deploy to GitHub Pages**
   ```yaml
   - uses: actions/deploy-pages@v4
   ```

## Build Validation

### Pre-Build Checks

```bash
# Validate mkdocs.yml syntax
python -c "import yaml; yaml.safe_load(open('mkdocs.yml'))"

# Check all nav files exist
python -c "
import yaml
config = yaml.safe_load(open('mkdocs.yml'))
for item in config['nav']:
    for key, path in item.items():
        assert open(f'docs/{path}').read(), f'Missing: {path}'
print('✓ All navigation files exist')
"
```

### Post-Build Checks

```bash
# Verify HTML is valid (basic check)
grep -r "<!DOCTYPE html>" site/ | wc -l

# Check for broken internal links (basic)
# Note: Use a proper link checker for production

# Verify search index
test -s site/search/search_index.json && echo "✓ Search index not empty"

# Check sitemap
grep -q "https://" site/sitemap.xml && echo "✓ Sitemap contains URLs"
```

## Build Troubleshooting

### Common Issues

#### 1. Missing Dependencies

**Error:**
```
ERROR - Config value 'plugins': Plugin 'search' not found
```

**Solution:**
```bash
pip install --upgrade mkdocs
```

#### 2. Navigation File Not Found

**Error:**
```
ERROR - Doc file 'resume.md' not found
```

**Solution:**
- Verify file exists in `docs/` directory
- Check filename matches exactly (case-sensitive)
- Update `nav` in `mkdocs.yml` if needed

#### 3. Strict Mode Warnings

**Error:**
```
WARNING - [some warning message]
ERROR - Aborted with a warning in strict mode.
```

**Solution:**
- Fix the underlying issue causing the warning
- Temporarily disable strict mode: `mkdocs build --clean` (not recommended for CI)

#### 4. Social Cards Plugin Failure

**Error:**
```
ERROR - Error building page: Failed to resolve 'fonts.google.com'
```

**Solution:**
- Ensure internet connectivity
- Or disable social plugin in `mkdocs.yml`:
  ```yaml
  plugins:
    - search
    # - social  # Commented out
  ```

#### 5. Python Version Mismatch

**Error:**
```
ERROR - Python version X.X is not supported
```

**Solution:**
```bash
# Check Python version
python --version

# Upgrade if needed
sudo apt-get install python3.12
```

## Build Optimization

### Speed Improvements

1. **Use pip cache:**
   ```bash
   pip install --cache-dir=.pip-cache -r requirements.txt
   ```

2. **Skip unnecessary files:**
   - Use `.mkdocsignore` for large files not needed in docs

3. **Parallel builds:**
   - MkDocs uses Python asyncio for concurrent operations

### Size Optimization

1. **Minimize assets:**
   - Compress images before adding to `docs/`
   - Use web-optimized formats (WebP for images)

2. **Remove unused features:**
   - Comment out unused markdown extensions
   - Disable plugins not in use

## Build Artifacts

### Generated Files

After successful build, the `site/` directory contains:

```
site/
├── index.html              # Home page
├── resume/
│   └── index.html          # Resume page
├── contact/
│   └── index.html          # Contact page
├── assets/
│   ├── stylesheets/        # CSS files
│   ├── javascripts/        # JS files
│   └── images/             # Theme images
├── search/
│   └── search_index.json   # Search index
├── sitemap.xml             # Site map
├── sitemap.xml.gz          # Compressed sitemap
└── 404.html                # Error page
```

## Maintenance

### Dependency Updates

**Monthly Check:**
```bash
pip list --outdated
```

**Update Strategy:**
1. Test updates in development
2. Update `requirements.txt` with new versions
3. Run full build test: `mkdocs build --strict --clean`
4. Commit if successful

### Version Pinning Strategy

Current approach:
- **Major versions:** Pinned (prevent breaking changes)
- **Minor/Patch:** Allow updates (e.g., `>=1.5.3,<2.0.0`)
- **Security patches:** Auto-applied via dependabot

## Performance Metrics

### Build Time Targets

- **Local development:** < 1 second
- **CI/CD build:** < 2 minutes (including dependency installation)
- **Page load time:** < 1 second (first contentful paint)

### Monitoring

Track these metrics:
- Build duration
- Site size
- Number of pages
- Dependency installation time

## References

- [MkDocs Build Documentation](https://www.mkdocs.org/user-guide/cli/#mkdocs-build)
- [Material Theme Configuration](https://squidfunk.github.io/mkdocs-material/setup/)
- [GitHub Pages Deployment](https://squidfunk.github.io/mkdocs-material/publishing-your-site/)

---

**Document Version:** 1.0  
**Last Updated:** 2024  
**Maintained By:** Config Engineer Agent
