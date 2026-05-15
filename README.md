# gha-guestbook

Issue-powered guestbook GitHub Action.

This repository is Marketplace-ready and exposes one root `action.yml`.

## What it does

- Runs on issue events in the caller workflow.
- Requires a label (default: `guestbook`).
- Appends a guestbook entry into README markers.
- Updates `## 📖 GuestBook — N Entries` header count.
- Optionally comments and closes the issue.

## Required README markers

```md
<!-- GUESTBOOK:START -->
<!-- GUESTBOOK:END -->
```

And a count header:

```md
## 📖 GuestBook — 0 Entries
```

## Usage

```yaml
name: Guestbook
on:
  issues:
    types: [opened]

permissions:
  contents: write
  issues: write

jobs:
  sign:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Sign guestbook
        uses: z19r/gha-guestbook@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          guestbook_label: guestbook
          readme_path: README.md
          close_issue: 'true'
```

## Inputs

- `github_token` (required): token with `contents:write`, `issues:write`
- `guestbook_label` (optional): trigger label, default `guestbook`
- `readme_path` (optional): README path, default `README.md`
- `close_issue` (optional): `true`/`false`, default `true`

## Outputs

- `signed`: `true` if an entry was written
- `guest_user`: issue author login for signed entry
- `entry_number`: computed guestbook count after write

## Publish flow

- Keep this action in its own public repository.
- Keep a single root `action.yml` and no workflow files.
- Create immutable semver tags like `v1.0.0`.
- Move major tag `v1` to the latest compatible release.

Commands:

```bash
just check
just release-tag v1.0.0
just release-tag-major v1
```
