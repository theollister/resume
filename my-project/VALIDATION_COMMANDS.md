# MkDocs Validation Command Reference

Quick reference for validating the MkDocs site before deployment.

---

## Quick Validation (30 seconds)

Run this before every push to ensure site integrity:

```bash
cd /home/runner/work/resume/resume/my-project
mkdocs build --strict --clean
```

**Expected Output:**
```
INFO - Cleaning site directory
INFO - Building documentation to directory: .../site
INFO - Documentation built in 0.XX seconds
```

**Exit Code:** 0 = Success ✅

---

## Comprehensive Validation (Full Test Suite)

### 1. Build Validation

```bash
# Clean strict build
cd /home/runner/work/resume/resume/my-project
mkdocs build --strict --clean

# Verbose output for debugging
mkdocs build --strict --clean --verbose
```

### 2. Navigation Check

```bash
# Verify nav entries match files
grep -A 5 "^nav:" mkdocs.yml
ls -l docs/index.md docs/resume.md docs/contact.md
```

### 3. Link Validation

```bash
# Find all internal markdown links
grep -r "\[.*\](.*\.md)" docs/*.md

# Validate link targets exist
python3 << 'EOF'
import re
from pathlib import Path

docs_dir = Path("docs")
links_found = []
broken = []

for md_file in docs_dir.glob("*.md"):
    with open(md_file, 'r') as f:
        content = f.read()
        pattern = r'\[([^\]]+)\]\(([^)]+\.md[^)]*)\)'
        matches = re.findall(pattern, content)
        for text, link in matches:
            target = link.split('#')[0]
            target_path = docs_dir / target
            if not target_path.exists():
                broken.append(f"{md_file.name} -> {link}")

if broken:
    print("❌ Broken links found:")
    for link in broken:
        print(f"  {link}")
    exit(1)
else:
    print("✅ All internal links valid")
    exit(0)
EOF
```

### 4. File Structure Check

```bash
# Verify all expected files exist
test -f docs/index.md && echo "✅ index.md exists" || echo "❌ index.md missing"
test -f docs/resume.md && echo "✅ resume.md exists" || echo "❌ resume.md missing"
test -f docs/contact.md && echo "✅ contact.md exists" || echo "❌ contact.md missing"
test -f mkdocs.yml && echo "✅ mkdocs.yml exists" || echo "❌ mkdocs.yml missing"
test -f requirements.txt && echo "✅ requirements.txt exists" || echo "❌ requirements.txt missing"
```

### 5. Site Output Validation

```bash
# Check site directory was created
test -d site && echo "✅ Site directory exists" || echo "❌ Site directory missing"

# Verify HTML pages generated
test -f site/index.html && echo "✅ index.html generated" || echo "❌ index.html missing"
test -f site/resume/index.html && echo "✅ resume page generated" || echo "❌ resume page missing"
test -f site/contact/index.html && echo "✅ contact page generated" || echo "❌ contact page missing"
```

### 6. Configuration Validation

```bash
# Check strict mode enabled
grep "^strict:" mkdocs.yml

# Verify Material theme
grep "name: material" mkdocs.yml

# Check navigation structure
grep -A 5 "^nav:" mkdocs.yml
```

---

## Local Preview

Test site locally before deployment:

```bash
cd /home/runner/work/resume/resume/my-project
mkdocs serve
```

**Access at:** http://127.0.0.1:8000

**What to Test:**
- Navigation between pages
- Internal links work
- Search functionality
- Light/dark mode toggle
- Mobile responsive view (resize browser)

**Stop Server:** Ctrl+C

---

## CI Simulation

Simulate what CI will do:

```bash
cd /home/runner/work/resume/resume/my-project

# Clean previous build
rm -rf site/

# Install dependencies (if needed)
pip install -r requirements.txt

# Build with strict mode (CI command)
mkdocs build --strict --clean

# Check exit code
echo "Exit code: $?"
# 0 = success, non-zero = failure
```

---

## Troubleshooting Commands

### Check MkDocs Version

```bash
mkdocs --version
# Expected: mkdocs, version 1.5.3+ from ...
```

### Verify Dependencies Installed

```bash
pip list | grep -E "(mkdocs|material|pymdown)"
# Should show:
# mkdocs                    1.6.x
# mkdocs-material           9.5.x
# pymdown-extensions        10.x
```

### Check for Syntax Errors

```bash
# Validate mkdocs.yml syntax
python3 -c "import yaml; yaml.safe_load(open('mkdocs.yml'))" 2>&1 | head
```

### Find Broken Reference Candidates

```bash
# Find all .md references
grep -rn "\.md" docs/*.md

# Find all http/https links
grep -rn "https\?://" docs/*.md
```

### Check Build Logs

```bash
# Build with maximum verbosity
mkdocs build --strict --clean --verbose 2>&1 | tee build.log

# Check for warnings/errors
grep -E "(WARNING|ERROR)" build.log
```

---

## Validation Checklist Script

Save this as `validate.sh`:

```bash
#!/bin/bash
set -e

echo "================================"
echo "MkDocs Site Validation"
echo "================================"
echo ""

cd /home/runner/work/resume/resume/my-project

echo "1. Checking file structure..."
test -f docs/index.md && echo "  ✅ index.md" || exit 1
test -f docs/resume.md && echo "  ✅ resume.md" || exit 1
test -f docs/contact.md && echo "  ✅ contact.md" || exit 1
test -f mkdocs.yml && echo "  ✅ mkdocs.yml" || exit 1
echo ""

echo "2. Running strict build..."
mkdocs build --strict --clean
echo "  ✅ Build succeeded"
echo ""

echo "3. Checking generated site..."
test -f site/index.html && echo "  ✅ index.html" || exit 1
test -f site/resume/index.html && echo "  ✅ resume page" || exit 1
test -f site/contact/index.html && echo "  ✅ contact page" || exit 1
echo ""

echo "4. Validating internal links..."
python3 << 'PYEOF'
import re
from pathlib import Path

docs_dir = Path("docs")
broken = []

for md_file in docs_dir.glob("*.md"):
    with open(md_file, 'r') as f:
        content = f.read()
        pattern = r'\[([^\]]+)\]\(([^)]+\.md[^)]*)\)'
        matches = re.findall(pattern, content)
        for text, link in matches:
            target = link.split('#')[0]
            target_path = docs_dir / target
            if not target_path.exists():
                broken.append(f"{md_file.name} -> {link}")

if broken:
    print("  ❌ Broken links:")
    for link in broken:
        print(f"    {link}")
    exit(1)
else:
    print("  ✅ All links valid")
PYEOF
echo ""

echo "================================"
echo "✅ ALL CHECKS PASSED"
echo "================================"
echo ""
echo "Site is ready for deployment!"
```

**Usage:**

```bash
chmod +x validate.sh
./validate.sh
```

---

## Automated Link Checker

For ongoing validation:

```bash
#!/bin/bash
# check_links.sh

cd /home/runner/work/resume/resume/my-project

echo "Checking internal links..."

python3 << 'EOF'
import re
from pathlib import Path

docs_dir = Path("docs")
all_links = []
broken_links = []

for md_file in docs_dir.glob("*.md"):
    with open(md_file, 'r', encoding='utf-8') as f:
        content = f.read()
        pattern = r'\[([^\]]+)\]\(([^)]+\.md[^)]*)\)'
        matches = re.findall(pattern, content)
        
        for text, link in matches:
            target = link.split('#')[0]
            target_path = docs_dir / target
            exists = target_path.exists()
            
            all_links.append({
                'source': md_file.name,
                'text': text,
                'target': link,
                'exists': exists
            })
            
            if not exists:
                broken_links.append((md_file.name, text, link))

print(f"Total internal links: {len(all_links)}")
print(f"Valid links: {len(all_links) - len(broken_links)}")
print(f"Broken links: {len(broken_links)}")
print()

if broken_links:
    print("❌ BROKEN LINKS FOUND:")
    for source, text, target in broken_links:
        print(f"  {source}: [{text}]({target})")
    exit(1)
else:
    print("✅ ALL LINKS VALID")
    exit(0)
EOF
```

---

## Pre-Commit Hook

Install as `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Running pre-commit validation..."

cd /home/runner/work/resume/resume/my-project

# Quick build check
if ! mkdocs build --strict --clean > /dev/null 2>&1; then
    echo "❌ MkDocs build failed. Run 'mkdocs build --strict --clean' to see errors."
    exit 1
fi

echo "✅ MkDocs validation passed"
exit 0
```

**Install:**

```bash
chmod +x .git/hooks/pre-commit
```

---

## Common Validation Scenarios

### Before Committing Changes

```bash
cd my-project
mkdocs build --strict --clean
```

### Before Creating Pull Request

```bash
cd my-project
mkdocs build --strict --clean --verbose
mkdocs serve  # Manual testing
```

### After Updating Dependencies

```bash
pip install -r requirements.txt --upgrade
mkdocs build --strict --clean
```

### When Adding New Page

```bash
# 1. Create new .md file in docs/
# 2. Add to nav in mkdocs.yml
# 3. Run validation
mkdocs build --strict --clean
```

---

## Quick Status Check

One-liner to check if site is valid:

```bash
cd /home/runner/work/resume/resume/my-project && mkdocs build --strict --clean && echo "✅ SITE VALID" || echo "❌ SITE INVALID"
```

---

## CI Validation Reference

What GitHub Actions runs:

```yaml
# Working directory
working-directory: my-project

# Commands executed
mkdocs --version
mkdocs build --strict --clean
```

**Simulate locally:**

```bash
cd /home/runner/work/resume/resume/my-project
mkdocs --version
mkdocs build --strict --clean
```

---

## Validation Success Indicators

### ✅ Good Signs

- Exit code 0
- "Documentation built in X.XX seconds"
- No ERROR or WARNING messages (except informational about images/README.md)
- site/ directory created with HTML files

### ❌ Bad Signs

- Non-zero exit code
- "ERROR" messages in output
- "WARNING" messages about broken links
- Missing site/ directory
- Build fails with exception

---

## Maintenance Commands

### Clean Build Artifacts

```bash
cd /home/runner/work/resume/resume/my-project
rm -rf site/ .cache/
mkdocs build --strict --clean
```

### Update Dependencies

```bash
cd /home/runner/work/resume/resume/my-project
pip install -r requirements.txt --upgrade
mkdocs build --strict --clean
```

### Check for Outdated Packages

```bash
pip list --outdated | grep -E "(mkdocs|material|pymdown)"
```

---

## Support & Debugging

### Get Detailed Error Information

```bash
mkdocs build --strict --clean --verbose 2>&1 | tee debug.log
```

### Check Configuration Syntax

```bash
mkdocs build --config-file mkdocs.yml 2>&1 | head -20
```

### Validate Specific Page

```bash
# Build and check specific page in site output
mkdocs build --strict --clean
cat site/resume/index.html | grep "<title>"
```

---

## Validation Frequency

| When | Command | Time |
|------|---------|------|
| Before each commit | `mkdocs build --strict --clean` | ~1 sec |
| Before pull request | `mkdocs build --strict --clean --verbose` | ~1 sec |
| After content changes | `mkdocs serve` (manual test) | 2-3 min |
| After dependency update | Full validation + preview | 3-5 min |
| Before deployment | Trust CI build (automated) | ~30 sec |

---

**Last Updated:** 2025-02-13  
**MkDocs Version:** 1.6.1  
**Material Version:** 9.5.0+  
**Python Version:** 3.12
