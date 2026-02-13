#!/bin/bash
#
# MkDocs Site Validation Script
# Validates configuration and build before deployment
#

set -e  # Exit on error

echo "🔍 MkDocs Site Validation"
echo "========================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track errors
ERRORS=0

# Function to print success
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Function to print error
error() {
    echo -e "${RED}✗${NC} $1"
    ERRORS=$((ERRORS + 1))
}

# Function to print warning
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# 1. Check Python version
echo "1️⃣  Checking Python version..."
PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

if [ "$PYTHON_MAJOR" -ge 3 ] && [ "$PYTHON_MINOR" -ge 8 ]; then
    success "Python $PYTHON_VERSION (>= 3.8 required)"
else
    error "Python $PYTHON_VERSION (>= 3.8 required)"
fi
echo ""

# 2. Check if in correct directory
echo "2️⃣  Checking project structure..."
if [ ! -f "mkdocs.yml" ]; then
    error "mkdocs.yml not found. Are you in the my-project directory?"
    exit 1
fi
success "mkdocs.yml found"

if [ ! -f "requirements.txt" ]; then
    error "requirements.txt not found"
else
    success "requirements.txt found"
fi

if [ ! -d "docs" ]; then
    error "docs/ directory not found"
else
    success "docs/ directory found"
fi
echo ""

# 3. Validate YAML syntax
echo "3️⃣  Validating mkdocs.yml syntax..."
if mkdocs build --help &>/dev/null && python -c "import yaml; yaml.load(open('mkdocs.yml'), Loader=yaml.FullLoader)" 2>/dev/null; then
    success "YAML syntax valid"
else
    # If full loader fails, try building which is the real test
    if mkdocs build --strict --clean --quiet 2>/dev/null; then
        success "YAML syntax valid (verified via build)"
    else
        error "YAML syntax invalid"
    fi
fi
echo ""

# 4. Check required fields
echo "4️⃣  Checking required configuration..."
if grep -q "^site_name:" mkdocs.yml; then
    SITE_NAME=$(grep "^site_name:" mkdocs.yml | cut -d'"' -f2)
    success "site_name: $SITE_NAME"
else
    error "site_name not found in mkdocs.yml"
fi

if grep -q "^nav:" mkdocs.yml; then
    success "nav structure defined"
else
    error "nav structure not found in mkdocs.yml"
fi

if grep -q "name: material" mkdocs.yml; then
    success "Material theme configured"
else
    warning "Material theme not configured"
fi
echo ""

# 5. Check navigation files exist
echo "5️⃣  Checking navigation files..."
NAV_FILES=$(grep -A 10 "^nav:" mkdocs.yml | grep "\.md$" | sed 's/.*: //' | tr -d ' ')
for file in $NAV_FILES; do
    if [ -f "docs/$file" ]; then
        success "docs/$file exists"
    else
        error "docs/$file not found"
    fi
done
echo ""

# 6. Check dependencies
echo "6️⃣  Checking dependencies..."
if command -v mkdocs &> /dev/null; then
    MKDOCS_VERSION=$(mkdocs --version | awk '{print $3}')
    success "MkDocs installed (version $MKDOCS_VERSION)"
else
    error "MkDocs not installed. Run: pip install -r requirements.txt"
fi

if python -c "import material" 2>/dev/null; then
    success "Material theme installed"
else
    error "Material theme not installed"
fi

if python -c "import pymdownx" 2>/dev/null; then
    success "PyMdown Extensions installed"
else
    warning "PyMdown Extensions not installed"
fi
echo ""

# 7. Test build
echo "7️⃣  Testing build process..."
if mkdocs build --strict --clean --quiet 2>&1; then
    success "Build successful (strict mode)"
else
    error "Build failed"
fi
echo ""

# 8. Check build output
echo "8️⃣  Checking build output..."
if [ -d "site" ]; then
    success "site/ directory created"
    
    if [ -f "site/index.html" ]; then
        success "index.html generated"
    else
        error "index.html not found"
    fi
    
    if [ -f "site/sitemap.xml" ]; then
        success "sitemap.xml generated"
    else
        warning "sitemap.xml not found"
    fi
    
    if [ -f "site/search/search_index.json" ]; then
        success "search index generated"
    else
        warning "search index not found"
    fi
    
    # Check site size
    SITE_SIZE=$(du -sh site/ | awk '{print $1}')
    success "Site size: $SITE_SIZE"
else
    error "site/ directory not found"
fi
echo ""

# 9. Check for common issues
echo "9️⃣  Checking for common issues..."

# Check for TODO markers
TODO_COUNT=$(grep -r "TODO\|FIXME\|XXX" docs/ 2>/dev/null | wc -l)
if [ "$TODO_COUNT" -gt 0 ]; then
    warning "$TODO_COUNT TODO/FIXME markers found in docs"
else
    success "No TODO markers found"
fi

# Check for placeholder content
if grep -q "your.email@example.com" docs/*.md 2>/dev/null; then
    warning "Placeholder email found - update contact information"
fi

if grep -q "Company Name" docs/*.md 2>/dev/null; then
    warning "Placeholder company names found - update resume"
fi

# Check for large files
LARGE_FILES=$(find docs/ -type f -size +1M 2>/dev/null | wc -l)
if [ "$LARGE_FILES" -gt 0 ]; then
    warning "$LARGE_FILES files larger than 1MB found"
else
    success "No large files in docs/"
fi
echo ""

# 10. Summary
echo "📊 Validation Summary"
echo "===================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "🚀 Ready to deploy!"
    echo "   Run: git add . && git commit -m 'Deploy site' && git push"
    exit 0
else
    echo -e "${RED}✗ $ERRORS error(s) found${NC}"
    echo ""
    echo "❌ Please fix the errors before deploying"
    exit 1
fi
