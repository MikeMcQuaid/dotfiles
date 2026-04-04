# Dotfiles Repository Notes

- Avoid changing `IFS` when a pipe-based command stays readable.
- Prefer the most readable shell over defensive parsing or micro-optimizations.
- Make reasonable simplifying assumptions when they keep scripts obvious.
- Temporary regression checks are fine while developing a fix.
- Do not keep repository-specific regression scripts checked in under places like `script/`.
