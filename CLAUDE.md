# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Marketplace-ready GitHub Action (composite) that turns GitHub Issues into guestbook entries. When an issue with the configured label is opened, the action appends a formatted entry into README markers and optionally thanks/closes the issue.

## Commands

```bash
just check                        # Run all validation checks (action, readme, marketplace)
just release-tag v1.2.3           # Create and push a semver tag
just release-tag-major v1 v1.2.3  # Force-move major tag to a semver ref
```

There is no build step, test suite, or linter — the action is a single `action.yml` with inline JavaScript via `actions/github-script@v7`.

## Architecture

This is a single-file composite action (`action.yml`). All logic lives inline in two `actions/github-script` steps plus one bash step:

1. **Sign step** (`id: sign`): Reads the README, checks the issue label, sanitizes input, appends a blockquote entry between `<!-- GUESTBOOK:START -->` / `<!-- GUESTBOOK:END -->` markers, updates the `## 📖 GuestBook — N Entries` header count, and sets outputs (`signed`, `guest_user`, `entry_number`).
2. **Commit step**: Configures git as `guestbook[bot]`, commits the README change, and pushes.
3. **Close step**: Posts a thank-you comment and closes the issue.

## Constraints

- No `.github/workflows/` directory allowed — `just check-marketplace` enforces this for Marketplace listing.
- The README must contain `uses: your-org/gha-guestbook@v1` for `just check-readme` to pass.
- Entry count is derived by counting lines starting with `> **` between the guestbook markers, not stored separately.
