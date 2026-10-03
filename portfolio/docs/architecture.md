# Portfolio System Architecture

## Why this exists

The Flutter app codebase remains the product implementation. The `portfolio/` directory is a separate, machine-readable content system for project case studies.

## Boundaries

1. Product code: `lib/`, `assets/`, platform folders.
2. Portfolio data: `portfolio/projects/<slug>/`.
3. Analysis artifacts: `portfolio/analysis/<slug>/`.
4. Automation scripts: `scripts/*.dart`.

## Current repository integration

- Framework: Flutter (Dart)
- Package manager: pub (`dart run`, `flutter test`)
- Data layer in app: Firebase Auth + Cloud Firestore
- Navigation: GetX imperative routing
- No repository API server/database service for portfolio data

Because no backend API exists for this repository, portfolio content uses versioned files and explicit review/publish transitions.

## Versioning model

- Generate draft: `case-study/drafts/`
- Mark reviewed: updates draft metadata
- Publish approved: writes `case-study/published/case-study.approved.json`
- Preserve previous approved revisions: `case-study/revisions/`
