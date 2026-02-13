# Quick Reference: Material Theme Configuration

## Current Configuration Values

### Colors
```yaml
primary: blue          # Azure professional
accent: cyan           # Modern tech highlight
```

### Logo & Favicon
```yaml
icon:
  logo: material/cloud        # Cloud icon from Material icons
favicon: images/favicon.png   # Path (falls back to default if not present)
```

### Typography
```yaml
font:
  text: Roboto
  code: Roboto Mono
```

### Social Links
```yaml
- icon: fontawesome/brands/linkedin
  link: https://www.linkedin.com/in/mitchelllesser
  name: Connect on LinkedIn

- icon: fontawesome/brands/github
  link: https://github.com/mitchelllesser
  name: View GitHub Profile
```

### Enabled Navigation Features
- `navigation.instant` - Fast SPA-like transitions
- `navigation.instant.progress` - Loading indicator
- `navigation.tracking` - URL updates with scroll
- `navigation.tabs` - Tab-based navigation
- `navigation.tabs.sticky` - Tabs stay visible
- `navigation.top` - Back-to-top button
- `search.suggest` - Search suggestions
- `search.highlight` - Highlight search results
- `content.code.copy` - Copy button for code blocks

### Disabled Features (Not Needed)
- `navigation.sections` - Overkill for 3 pages
- `search.share` - Simplified UI
- `content.action.edit` - Not appropriate for resume
- `content.action.view` - Not needed

## Key File Locations

```
my-project/
├── mkdocs.yml                    # Main config (lines 18-65: theme section)
├── docs/
│   ├── images/                   # Assets directory
│   │   ├── favicon.png           # Custom favicon (optional)
│   │   └── logo.png              # Custom logo (optional)
│   ├── index.md                  # Home page
│   ├── resume.md                 # Resume page
│   └── contact.md                # Contact page
└── site/                         # Built site (generated)
```

## Quick Commands

### Local Preview
```bash
cd /home/runner/work/resume/resume/my-project
mkdocs serve
# Open: http://127.0.0.1:8000
```

### Build Site
```bash
mkdocs build
```

### Build with Validation
```bash
mkdocs build --strict
```

## Common Customizations

### Change Primary Color
```yaml
palette:
  - scheme: default
    primary: indigo  # or: red, pink, purple, deep-purple, blue, 
                     #     light-blue, cyan, teal, green, light-green,
                     #     lime, yellow, amber, orange, deep-orange
```

### Add Email to Social Links
Uncomment in `mkdocs.yml`:
```yaml
- icon: fontawesome/solid/envelope
  link: mailto:your.email@example.com
  name: Send Email
```

### Enable Google Analytics
Uncomment and configure in `mkdocs.yml`:
```yaml
extra:
  analytics:
    provider: google
    property: G-XXXXXXXXXX  # Your GA4 ID
```

### Use Custom Logo Image
1. Place image in `docs/images/logo.png`
2. Update `mkdocs.yml`:
```yaml
theme:
  logo: images/logo.png  # Instead of icon.logo
```

### Add Custom CSS
1. Create `docs/stylesheets/extra.css`
2. Uncomment in `mkdocs.yml`:
```yaml
extra_css:
  - stylesheets/extra.css
```

## Color Palette Options

Material supports these primary colors:
- `red`, `pink`, `purple`, `deep-purple`
- `indigo`, `blue`, `light-blue`, `cyan`
- `teal`, `green`, `light-green`, `lime`
- `yellow`, `amber`, `orange`, `deep-orange`
- `brown`, `grey`, `blue-grey`
- `black`, `white`

**Current choice: `blue`** (Azure/cloud alignment)

## Available Material Icons

Browse all icons at:
https://squidfunk.github.io/mkdocs-material/reference/icons-emojis/

Common cloud/tech icons:
- `material/cloud`
- `material/cloud-upload`
- `material/cloud-download`
- `material/server`
- `material/code-tags`
- `material/database`

## Responsive Breakpoints

Material automatically handles:
- Mobile: `< 960px` (single column, hamburger menu)
- Tablet: `960px - 1220px` (collapsible sidebar)
- Desktop: `> 1220px` (full layout)

## Documentation Files

| File | Purpose | Lines |
|------|---------|-------|
| `THEME_DELIVERY.md` | Comprehensive delivery report | 500+ |
| `THEME_CONFIG.md` | Full theme documentation | 350+ |
| `THEME_SUMMARY.md` | Quick reference & checklist | 200+ |
| `THEME_CHANGES.md` | Change log (before/after) | 230+ |
| `THEME_QUICK_REF.md` | This file - quick lookup | ~150 |
| `docs/images/README.md` | Favicon/logo guide | 100+ |

## Support Resources

- **Material Docs:** https://squidfunk.github.io/mkdocs-material/
- **Setup Guide:** https://squidfunk.github.io/mkdocs-material/setup/
- **Customization:** https://squidfunk.github.io/mkdocs-material/customization/
- **Reference:** https://squidfunk.github.io/mkdocs-material/reference/

---

**Last Updated:** 2024
**Configuration Status:** ✅ Production Ready
**Build Status:** ✅ Validated (strict mode)
