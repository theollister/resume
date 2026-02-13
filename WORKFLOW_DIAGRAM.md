# CI/CD Workflow Diagram

**Repository:** theollister/resume  
**Workflow:** MkDocs (Material) → GitHub Pages

---

## Workflow Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                         GitHub Repository                             │
│                        theollister/resume                             │
└──────────────────────────────────────────────────────────────────────┘
                                  │
                                  │
                    ┌─────────────┴──────────────┐
                    │                            │
              ┌─────▼─────┐              ┌──────▼──────┐
              │    PR      │              │  Push to    │
              │  Created/  │              │    main     │
              │  Updated   │              │   branch    │
              └─────┬─────┘              └──────┬──────┘
                    │                            │
                    │                            │
    ┌───────────────▼────────────────────────────▼───────────────┐
    │                                                             │
    │              GitHub Actions Workflow Triggers               │
    │         .github/workflows/mkdocs-pages.yml                  │
    │                                                             │
    │  Trigger Condition:                                         │
    │  - Changes in: my-project/**                                │
    │  - OR changes in: .github/workflows/mkdocs-pages.yml        │
    │                                                             │
    └───────────────┬────────────────────────────┬───────────────┘
                    │                            │
                    │                            │
    ┌───────────────▼───────────────┐  ┌────────▼────────────────┐
    │        BUILD JOB (PR)          │  │   BUILD JOB (Main)      │
    │                                │  │                         │
    │  Permissions: contents: read   │  │  Permissions:           │
    │                                │  │    contents: read       │
    └────────────────────────────────┘  └─────────────────────────┘
                    │                            │
                    │                            │
    ┌───────────────▼───────────────┐  ┌────────▼────────────────┐
    │  1. Checkout code              │  │  1. Checkout code       │
    │     actions/checkout@v4        │  │     actions/checkout@v4 │
    └───────────────┬────────────────┘  └────────┬────────────────┘
                    │                            │
    ┌───────────────▼───────────────┐  ┌────────▼────────────────┐
    │  2. Setup Python 3.12          │  │  2. Setup Python 3.12   │
    │     actions/setup-python@v5    │  │     actions/setup...@v5 │
    │     - Enable pip cache         │  │     - Enable pip cache  │
    └───────────────┬────────────────┘  └────────┬────────────────┘
                    │                            │
    ┌───────────────▼───────────────┐  ┌────────▼────────────────┐
    │  3. Install dependencies       │  │  3. Install deps        │
    │     cd my-project              │  │     cd my-project       │
    │     pip install -r req...txt   │  │     pip install -r ...  │
    └───────────────┬────────────────┘  └────────┬────────────────┘
                    │                            │
    ┌───────────────▼───────────────┐  ┌────────▼────────────────┐
    │  4. Build site                 │  │  4. Build site          │
    │     cd my-project              │  │     cd my-project       │
    │     mkdocs build --strict      │  │     mkdocs build ...    │
    │                                │  │                         │
    │     ┌─────────────────┐        │  │     ┌─────────────────┐│
    │     │ SUCCESS?        │        │  │     │ SUCCESS?        ││
    │     └────┬───────┬────┘        │  │     └────┬───────┬────┘│
    │          │       │             │  │          │       │     │
    │        ✅│       │❌            │  │        ✅│       │❌    │
    └──────────┼───────┼─────────────┘  └──────────┼───────┼─────┘
               │       │                           │       │
               │       │                           │       │
    ┌──────────▼───────▼─────────────┐  ┌────────▼───────▼──────┐
    │   PR Status Check               │  │  Continue / Fail      │
    │                                 │  │                       │
    │   ✅ Build Success              │  │  ✅→ Upload artifact  │
    │      → Merge allowed            │  │  ❌→ Stop (no deploy) │
    │                                 │  │                       │
    │   ❌ Build Failed               │  └────────┬──────────────┘
    │      → Merge blocked            │           │
    │                                 │           │ (if ✅)
    │   ❌ NO DEPLOYMENT              │           │
    │                                 │  ┌────────▼──────────────┐
    └─────────────────────────────────┘  │  5. Upload artifact   │
                                         │     actions/upload-   │
                                         │     pages-artifact@v3 │
                                         │     path: my-proj/site│
                                         └────────┬──────────────┘
                                                  │
                                         ┌────────▼──────────────┐
                                         │    DEPLOY JOB         │
                                         │                       │
                                         │  Depends on: build    │
                                         │  Condition: main push │
                                         │                       │
                                         │  Permissions:         │
                                         │    pages: write       │
                                         │    id-token: write    │
                                         │                       │
                                         │  Environment:         │
                                         │    github-pages       │
                                         └────────┬──────────────┘
                                                  │
                                         ┌────────▼──────────────┐
                                         │  Deploy to Pages      │
                                         │  actions/deploy-      │
                                         │  pages@v4             │
                                         └────────┬──────────────┘
                                                  │
                                         ┌────────▼──────────────┐
                                         │   GitHub Pages        │
                                         │                       │
                                         │  URL: https://        │
                                         │  theollister.github   │
                                         │  .io/resume/          │
                                         │                       │
                                         │  ✅ LIVE SITE         │
                                         └───────────────────────┘
```

---

## Workflow States

### State 1: Pull Request
```
PR Created → Build → Report Status → ❌ NO DEPLOY
   │           │
   │           ├─ ✅ Success → Merge allowed
   │           └─ ❌ Failure → Merge blocked
   │
   └─ Purpose: Validate changes before merge
```

### State 2: Push to Main
```
Push to main → Build → Upload → Deploy → Live Site
    │            │        │       │         │
    │            │        │       │         └─ https://theollister.github.io/resume/
    │            │        │       │
    │            │        │       └─ actions/deploy-pages@v4
    │            │        │
    │            │        └─ my-project/site/ artifact
    │            │
    │            └─ mkdocs build --strict --clean
    │
    └─ Purpose: Deploy validated changes
```

### State 3: Build Failure
```
Any trigger → Build Fails → ❌ STOP
                  │
                  ├─ PR: Merge blocked
                  └─ Main: No deployment
```

---

## Decision Flow

```
                    ┌─────────────────┐
                    │  Code Changed?  │
                    └────────┬────────┘
                             │
                    ┌────────▼─────────┐
                    │ In my-project/** │
                    │      OR          │
                    │  workflow file?  │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │ PR or Push?      │
                    └────┬────────┬────┘
                         │        │
                   ┌─────▼──┐  ┌──▼─────┐
                   │   PR   │  │  Push  │
                   └─────┬──┘  └──┬─────┘
                         │        │
                         │   ┌────▼─────┐
                         │   │To main?  │
                         │   └────┬─────┘
                         │        │
                         │    ┌───▼────┐
                         │    │  YES   │
                         │    └───┬────┘
                         │        │
                    ┌────▼────────▼────┐
                    │   BUILD SITE      │
                    └────┬──────────────┘
                         │
                    ┌────▼─────┐
                    │Success?  │
                    └────┬─────┘
                         │
                ┌────────┼─────────┐
                │                  │
            ┌───▼───┐          ┌───▼───┐
            │  YES  │          │  NO   │
            └───┬───┘          └───┬───┘
                │                  │
        ┌───────▼───────┐     ┌────▼─────┐
        │ From main?    │     │   FAIL   │
        └───────┬───────┘     │  - Stop  │
                │             │  - Block │
        ┌───────┼──────┐      └──────────┘
        │              │
    ┌───▼───┐      ┌───▼───┐
    │  YES  │      │  NO   │
    └───┬───┘      └───┬───┘
        │              │
    ┌───▼────┐     ┌───▼──────┐
    │ DEPLOY │     │  Report  │
    │        │     │  Success │
    └───┬────┘     └──────────┘
        │
    ┌───▼─────┐
    │  LIVE   │
    │  SITE   │
    └─────────┘
```

---

## Path Filter Logic

```
┌────────────────────────────────────────────┐
│          File Changed                       │
└────────────────┬───────────────────────────┘
                 │
                 ▼
    ┌────────────────────────────┐
    │  Path matches pattern?     │
    │  - my-project/**           │
    │  - .github/workflows/      │
    │    mkdocs-pages.yml        │
    └────────────┬───────────────┘
                 │
        ┌────────┼────────┐
        │                 │
    ┌───▼───┐         ┌───▼───┐
    │  YES  │         │  NO   │
    └───┬───┘         └───┬───┘
        │                 │
    ┌───▼───────┐     ┌───▼────────┐
    │  Trigger  │     │  Skip      │
    │ Workflow  │     │  Workflow  │
    └───────────┘     └────────────┘

Examples:
✅ my-project/docs/index.md         → Triggers
✅ my-project/mkdocs.yml            → Triggers
✅ my-project/requirements.txt      → Triggers
✅ .github/workflows/mkdocs-*.yml   → Triggers
❌ README.md                        → Skips
❌ src/app.js                       → Skips
❌ .github/dependabot.yml           → Skips
```

---

## Concurrency Control

```
┌─────────────────────────────────────────────────┐
│        Multiple Pushes to Main                  │
│                                                 │
│   Push 1 (9:00 AM) → Deploy starts...          │
│   Push 2 (9:01 AM) → Deploy queued...          │
│                                                 │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
    ┌────────────────────────────┐
    │   Concurrency Group:       │
    │      "pages"               │
    │   cancel-in-progress: true │
    └────────────┬───────────────┘
                 │
                 ▼
    ┌────────────────────────────┐
    │   Push 1 deployment        │
    │   ❌ CANCELLED             │
    │                            │
    │   Push 2 deployment        │
    │   ✅ RUNS                  │
    └────────────────────────────┘

Result: Only latest changes deployed
Benefit: Avoids deployment conflicts
```

---

## Permissions Model

```
┌────────────────────────────────────────────────┐
│               BUILD JOB                         │
├────────────────────────────────────────────────┤
│  Permissions:                                  │
│    contents: read   ← Read repository only     │
│                                                │
│  Can:                                          │
│    ✅ Checkout code                            │
│    ✅ Read files                               │
│    ✅ Run build                                │
│                                                │
│  Cannot:                                       │
│    ❌ Write to repository                      │
│    ❌ Deploy to Pages                          │
│    ❌ Modify workflow                          │
└────────────────────────────────────────────────┘

┌────────────────────────────────────────────────┐
│               DEPLOY JOB                        │
├────────────────────────────────────────────────┤
│  Permissions:                                  │
│    pages: write      ← Deploy to Pages         │
│    id-token: write   ← OIDC authentication     │
│                                                │
│  Can:                                          │
│    ✅ Deploy to GitHub Pages                   │
│    ✅ Update Pages deployment                  │
│    ✅ Authenticate with OIDC                   │
│                                                │
│  Cannot:                                       │
│    ❌ Modify repository code                   │
│    ❌ Access secrets beyond deployment         │
└────────────────────────────────────────────────┘

Principle: Least privilege ✅
Each job has only the permissions it needs.
```

---

## File Locations

```
resume/                          (repository root)
│
├── .github/
│   └── workflows/
│       └── mkdocs-pages.yml     ← Workflow definition
│
├── my-project/                  ← MkDocs site root
│   ├── mkdocs.yml              ← MkDocs configuration
│   ├── requirements.txt        ← Python dependencies
│   ├── .gitignore              ← Excludes site/ and .cache/
│   │
│   ├── docs/                   ← Content directory
│   │   ├── index.md           ← Home page
│   │   ├── resume.md          ← Resume page
│   │   ├── contact.md         ← Contact page
│   │   └── images/            ← Images
│   │
│   ├── site/                   ← Build output (gitignored)
│   │   ├── index.html
│   │   ├── resume/
│   │   ├── contact/
│   │   └── assets/
│   │
│   └── .cache/                 ← MkDocs cache (gitignored)
│
└── Documentation files
    ├── CI_CD_VERIFICATION_REPORT.md
    ├── GITHUB_PAGES_SETUP_CHECKLIST.md
    ├── LOCAL_PREVIEW_GUIDE.md
    └── WORKFLOW_DIAGRAM.md (this file)
```

---

## Timeline: Typical Deployment

```
Time    Event                           Status
──────────────────────────────────────────────────────────
00:00   Push to main branch             ⏳ Triggered
00:05   Workflow starts                 ⏳ Queued
00:10   Build job: Checkout             ⏳ Running
00:15   Build job: Setup Python         ⏳ Running
00:25   Build job: Install deps         ⏳ Running
00:45   Build job: Build site           ⏳ Running
01:00   Build job: Upload artifact      ⏳ Running
01:10   Build job: Complete             ✅ Success
01:10   Deploy job: Start               ⏳ Running
01:15   Deploy job: Deploy to Pages     ⏳ Running
01:30   Deploy job: Complete            ✅ Success
01:35   GitHub Pages: Processing        ⏳ Building
01:50   GitHub Pages: Live              ✅ Live
02:00   Site accessible                 ✅ https://theollister.github.io/resume/

Total time: ~2 minutes
```

---

## Error Handling

```
┌──────────────────────────────────────────────┐
│            Build Error Detected               │
│  (e.g., broken link, missing file)           │
└────────────────┬─────────────────────────────┘
                 │
                 ▼
    ┌────────────────────────┐
    │  mkdocs build --strict │
    │  exits with error      │
    └────────────┬───────────┘
                 │
                 ▼
    ┌────────────────────────┐
    │  Build job FAILS       │
    │  Exit code: 1          │
    └────────────┬───────────┘
                 │
        ┌────────┼────────┐
        │                 │
    ┌───▼───┐         ┌───▼───┐
    │  PR   │         │  Main │
    └───┬───┘         └───┬───┘
        │                 │
    ┌───▼────────┐    ┌───▼───────┐
    │ ❌ Status  │    │ ❌ Deploy │
    │   check    │    │   skipped │
    │   fails    │    │           │
    │            │    │ No changes│
    │ Merge      │    │ to live   │
    │ blocked    │    │ site      │
    └────────────┘    └───────────┘

Result: Bad builds never reach production ✅
```

---

## Legend

```
✅  Success / Enabled / Correct
❌  Failure / Disabled / Blocked
⏳  In Progress / Waiting
⚠️  Warning / Action Required
│   Flow / Connection
▼   Direction / Next Step
```

---

**Last Updated:** 2024-02-13  
**Workflow Version:** mkdocs-pages.yml (current)  
**Status:** ✅ Verified and Documented
