# GitHub Pages Setup Checklist

**Repository:** theollister/resume  
**Branch:** main  
**Workflow:** `.github/workflows/mkdocs-pages.yml`

---

## Required Repository Settings

Before the workflow can deploy successfully, verify these settings in the GitHub repository.

### 1. Enable GitHub Pages with GitHub Actions

**Location:** `Settings` → `Pages`

- [ ] **Source:** Set to **"GitHub Actions"**
  - ⚠️ **NOT** "Deploy from a branch"
  - This allows the workflow to deploy directly

**How to verify:**
1. Go to `https://github.com/theollister/resume/settings/pages`
2. Under "Build and deployment"
3. Source should show: **GitHub Actions**

---

### 2. Workflow Permissions

**Location:** `Settings` → `Actions` → `General` → `Workflow permissions`

- [ ] **Permissions:** Set to **"Read and write permissions"**
  - OR ensure the workflow has explicit `pages: write` permission (already configured in workflow)

- [ ] **Allow GitHub Actions to create and approve pull requests** (Optional)
  - Only needed if you want automated PR creation

**How to verify:**
1. Go to `https://github.com/theollister/resume/settings/actions`
2. Scroll to "Workflow permissions"
3. Select "Read and write permissions"
4. Click "Save"

---

### 3. Actions Enabled

**Location:** `Settings` → `Actions` → `General` → `Actions permissions`

- [ ] **Actions permissions:** Set to **"Allow all actions and reusable workflows"**
  - OR at minimum: "Allow [organization] and select non-[organization] actions and reusable workflows"
  - Required actions:
    - `actions/checkout@v4`
    - `actions/setup-python@v5`
    - `actions/upload-pages-artifact@v3`
    - `actions/deploy-pages@v4`

**How to verify:**
1. Go to `https://github.com/theollister/resume/settings/actions`
2. Under "Actions permissions"
3. Ensure GitHub Actions are enabled

---

### 4. Branch Protection (Recommended)

**Location:** `Settings` → `Branches` → Add rule for `main`

- [ ] **Require pull request reviews before merging**
  - Recommended: 1 approval required

- [ ] **Require status checks to pass before merging**
  - Add status check: **"Build"** (from MkDocs workflow)
  - This ensures docs build successfully before merge

- [ ] **Require branches to be up to date before merging**
  - Prevents stale merges

**How to set up:**
1. Go to `https://github.com/theollister/resume/settings/branches`
2. Click "Add rule" or "Add branch protection rule"
3. Branch name pattern: `main`
4. Enable desired protections
5. Click "Create" or "Save changes"

---

## Verification Steps

### Step 1: Check Workflow File

```bash
# Verify workflow exists
ls -la .github/workflows/mkdocs-pages.yml
# Should show: .github/workflows/mkdocs-pages.yml
```

✅ **Confirmed:** Workflow file exists

---

### Step 2: Merge to Main

```bash
# From branch: copilot/build-site-with-resume
git checkout main
git merge copilot/build-site-with-resume
git push origin main
```

**OR** Create a Pull Request and merge via GitHub UI (recommended)

---

### Step 3: Monitor Workflow

1. Go to: `https://github.com/theollister/resume/actions`
2. Click on the workflow run: "MkDocs (Material) -> GitHub Pages"
3. Watch the progress:
   - **Build** job should complete first
   - **Deploy** job should run after build succeeds
4. Check for any errors

---

### Step 4: Verify Deployment

1. **Check deployment URL:**
   - Navigate to: `https://github.com/theollister/resume/deployments`
   - Look for "github-pages" environment
   - Click "View deployment"
   - OR directly visit: `https://theollister.github.io/resume/`

2. **Verify pages load:**
   - Home: `https://theollister.github.io/resume/`
   - Resume: `https://theollister.github.io/resume/resume/`
   - Contact: `https://theollister.github.io/resume/contact/`

3. **Check navigation:**
   - Top navigation tabs work
   - Search functionality works
   - Theme toggle (light/dark mode) works

---

## Troubleshooting

### Issue: Workflow doesn't trigger

**Cause:** GitHub Actions not enabled  
**Solution:** Check Settings → Actions → Enable Actions

---

### Issue: Build fails with "Permission denied"

**Cause:** Insufficient workflow permissions  
**Solution:** 
1. Go to Settings → Actions → General → Workflow permissions
2. Select "Read and write permissions"
3. Save and re-run workflow

---

### Issue: Deploy step skipped

**Cause:** Not pushing to `main` branch or PR instead of push  
**Solution:**
- Ensure you're pushing directly to `main` branch
- OR merge PR to `main` branch
- Deploy only runs on push to main, not on PRs

---

### Issue: "Deploy from a branch" still shows in Pages settings

**Cause:** Old Pages configuration  
**Solution:**
1. Go to Settings → Pages
2. Under "Source", select "GitHub Actions"
3. Wait a few minutes for settings to update
4. Re-run workflow

---

### Issue: 404 error when visiting site

**Possible causes:**
1. **Deployment in progress** - Wait for workflow to complete
2. **Wrong URL** - Verify: `https://<username>.github.io/<repo-name>/`
3. **Pages not enabled** - Check Settings → Pages source is set

**Solution:**
- Wait 1-2 minutes after deployment completes
- Clear browser cache
- Check Actions tab for workflow status

---

## After First Successful Deployment

### Verify Environment Created

**Location:** `Settings` → `Environments`

- [ ] Environment **"github-pages"** should be listed
  - Created automatically by workflow
  - Shows deployment history
  - Shows deployment URL

**How to check:**
1. Go to `https://github.com/theollister/resume/settings/environments`
2. You should see "github-pages" environment
3. Click on it to see deployment history

---

### Update README (Optional)

Add build status badge to README.md:

```markdown
[![MkDocs Build](https://github.com/theollister/resume/actions/workflows/mkdocs-pages.yml/badge.svg)](https://github.com/theollister/resume/actions/workflows/mkdocs-pages.yml)

View the live site: https://theollister.github.io/resume/
```

---

## Quick Command Reference

```bash
# Local development server
cd my-project
mkdocs serve
# Opens: http://127.0.0.1:8000/

# Test production build (matches CI)
cd my-project
mkdocs build --strict --clean

# Check build output
ls -la my-project/site/

# View workflow logs (using gh CLI)
gh workflow view "MkDocs (Material) -> GitHub Pages"
gh run list --workflow=mkdocs-pages.yml
gh run view <run-id> --log
```

---

## Support

### Workflow Configuration
- File: `.github/workflows/mkdocs-pages.yml`
- Documentation: This checklist and `CI_CD_VERIFICATION_REPORT.md`

### MkDocs Configuration
- File: `my-project/mkdocs.yml`
- Documentation: [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)

### GitHub Pages Documentation
- [GitHub Pages with Actions](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#publishing-with-a-custom-github-actions-workflow)

---

## Summary

Once these settings are configured, the workflow will:

1. ✅ Build documentation on every PR (validation)
2. ✅ Deploy documentation on merge to `main`
3. ✅ Block deployment if build fails
4. ✅ Update site automatically on every merge

**Estimated setup time:** 5 minutes  
**First deployment time:** 2-3 minutes

---

**Last Updated:** 2024-02-13  
**Workflow Version:** mkdocs-pages.yml (current)
