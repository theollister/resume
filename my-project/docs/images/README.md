# Favicon & Logo Assets

## Current Status
- **Logo:** Using Material Design cloud icon (`material/cloud`)
- **Favicon:** Configured to use `images/favicon.png`, falling back to Material default

## To Add Custom Favicon

### Option 1: Generate from Text (Quickest)
1. Visit https://favicon.io/favicon-generator/
2. Settings:
   - Text: `ML` (your initials)
   - Background: `#2196F3` (matches blue theme)
   - Font: Roboto or similar professional font
   - Shape: Square or rounded
3. Download the PNG
4. Save as `favicon.png` in this directory

### Option 2: Generate from Icon
1. Visit https://realfavicongenerator.net/
2. Upload a cloud icon or Azure-themed graphic
3. Generate all sizes
4. Download and save the main favicon.png here

### Option 3: Use Emoji
1. Visit https://favicon.io/emoji-favicons/cloud/
2. Download the cloud emoji favicon ☁️
3. Save as `favicon.png` in this directory

### Option 4: Create in Canva (Free)
1. Create 512x512px design
2. Use blue background (#2196F3)
3. Add cloud icon or "ML" text in white
4. Export as PNG
5. Save here as `favicon.png`

## File Specifications
- **Format:** PNG (preferred) or ICO
- **Size:** At least 32x32px, ideally 512x512px for high-DPI displays
- **Transparency:** Optional (solid blue background also looks professional)
- **Color scheme:** Should complement the blue theme (#2196F3)

## Logo Image (Optional)
If you want to replace the Material icon with a custom logo:
1. Create/obtain your logo (PNG or SVG)
2. Recommended size: 128x128px or SVG
3. Save as `logo.png` or `logo.svg` in this directory
4. Update `mkdocs.yml`:
   ```yaml
   theme:
     logo: images/logo.png
   ```

## Current Configuration
In `mkdocs.yml`:
```yaml
theme:
  icon:
    logo: material/cloud        # Material icon (no file needed)
  favicon: images/favicon.png   # Your custom favicon goes here
```

---
**No action required** - site works with Material defaults until you're ready to customize!
