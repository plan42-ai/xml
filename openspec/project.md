# Project Context

## Purpose
Fork of Go's `encoding/xml` package (Go 1.25.5) with modifications to support behaviors needed by Plan42, such as emitting empty tags for plist generation.

## Tech Stack
- Go 1.25 fork of the standard library `encoding/xml`
- Tests and examples mirroring upstream behavior with added features

## Project Conventions

### Code Style
Maintain upstream Go stdlib style and formatting (gofmt). Keep changes minimal and clearly separated from upstream logic to ease future rebases.

### Architecture Patterns
Structure mirrors the original `encoding/xml` package with additional functionality layered into marshal/read helpers. Branching follows Go version numbers, with patches applied on top.

### Testing Strategy
`go test ./...` runs upstream-derived tests plus additional coverage for forked behavior (e.g., empty tag emission). Keep tests deterministic and aligned with stdlib expectations.

### Git Workflow
Branches are named after the upstream Go version used for extraction (e.g., `1.25.5`). Apply fixes as patch-level releases and document deviations in the README. Use feature branches + PRs for new changes.

## Domain Context
Fork exists to generate XML compatible with Apple launchctl plist requirements (empty tags like `<true/>`). Upstream Go team has not accepted this behavior, so changes must be maintained locally while preserving compatibility with standard XML encoding semantics.

## Important Constraints
- Preserve upstream behavior wherever possible to minimize divergence.
- Avoid introducing security regressions when handling untrusted XML data.
- Document any non-standard behaviors clearly for consumers.

## External Dependencies
None beyond Go tooling; forked from upstream Go source.
