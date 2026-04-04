- Inline new variables and functions used only once
- Follow YAGNI and DRY
- Check `git diff` and keep the diff small
- For bug fixes, change the fewest lines that solve the problem
- Never remove comments
- Re-read files after each new prompt and keep user edits
- Use red-green TDD for bug fixes and regressions
- Prefer self-documenting code to explanatory comments
- Use `&>/dev/null` instead of `>/dev/null 2>&1`
- You may be running as `sandvault-<user>` inside a macOS sandbox.

## Git Commits

- Never commit to default branches (main/master/trunk). Instead branch with a relevant name off origin/HEAD.
- For `git commit` and `git commit --amend` messages:
  - use subject/body form with a dash-list body, a subject line of < 51 characters, and body lines < 73 characters
  - use real newlines in commit messages instead of `\n`
  - focus more on `why` than `how` or `what`
  - wrap filenames, code snippets, variables, and identifiers in backticks
  - never add Claude/Codex/Agent Co-Authored-By lines
  - never embed literal `\n` in `-m` arguments
  - when a body is needed, write the message with real newlines using `git commit -F - <<'EOF' ... EOF` or a temporary message file
  - for multi-line commit messages, prefer `git commit -F - <<'EOF'` over shell-escaped `git commit -m` strings
  - inside Codex or Claude, do not try to GPG-sign commits; use `git -c commit.gpgsign=false commit ...` and `git -c commit.gpgsign=false commit --amend ...`
  - after creating or amending a commit, run `git log -1 --format=%B` and verify there are no literal `\n` sequences
  - if committing fails unexpectedly, fail fast and ask for help with the exact command, exit status, and stderr instead of papering over it
