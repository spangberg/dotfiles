# Agent Instructions

These are common instructions for agents across all scenarios

## General Guidelines
* Never use the em dash "—". Use plain dash "-" instead
* When writing commit messages, NEVER auto-add your agent name as co-author
* Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
* When writing or substantially editing long Markdown files, put each full sentence on its own line.  
Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.
* When making technical decisions, do not give much weight to development cost.  
Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
* When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it.  
This makes sure you find the real problem so your fix will actually solve it.
* When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.  
If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
* Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.  
If you see one, even if it is not caused by what you are working on right now, still get it fixed.

## Shell Environment

### Preferred Tools
The following tools are available and preferred over standard Unix equivalents:
* `rg` (ripgrep) — prefer over `grep`
* `fd` — prefer over `find`
* `bat` — prefer over `cat`; use `bat --style=plain --pager=never` when piping
* `eza` — prefer over `ls`; use `eza -lah --git` for detailed listings
* `jq` — prefer for JSON processing over `awk`/`sed`
* `yq` — prefer for YAML processing over `awk`/`sed`
* `gh` — GitHub CLI; prefer over curl-based GitHub API calls
* `delta` — configured as git pager; affects `git diff` and `git log -p` output

### Python (uv)
* `uv` is the Python package and environment manager; do not use `pip` directly
* Python versions are managed by 'uv'; do not assume a system Python at a fixed path
* Always use `uv run <command>` to execute Python scripts and tools
* Always use `uv add <package>` to add dependencies, never `pip install`
* Always use `uv sync` to restore environments from lockfile
* Project environments live in `.venv/` in the project root
* Global CLI tools are installed via `uv tool isntall` and available on PATH

### Node (Volta)
* `volta` managers Node and npm versions; do not assume a fixed Node version
* Node/npm versions are pinned per-prjoect in `package.json` under the `volta` key
* Use `node`, `npm`, `npx` as normal — Volta handles version routing transparently
* Do not run `npm install -g` for project dependencies; use `volta install` for global tools

### Shell Behavior Notes
* `rm`, `cp`, `mv` have interactive safety prompts configured; use `command rm` etc. to bypass if needed in scripts
* `find` is aliased to `fd`; if you need POSIX `find` behavior use `command find`
* `grep` is aliased to `rg`; if you need POSIX `grep` behavior use `command grep`
* `cat` is aliased to `bat`; if you need raw output use `command cat` or `bat --style=plain --pager=never`