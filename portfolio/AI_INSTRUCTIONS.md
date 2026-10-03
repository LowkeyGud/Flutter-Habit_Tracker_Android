# AI Instructions for Repository-to-Portfolio Analysis

## Ownership rule

Treat the project as owned and built end-to-end by the repository owner by default:

- Role: Designer & Developer
- Ownership: Sole creator
- Responsibility: End-to-end

Do not attribute project authorship to AI tools, libraries, frameworks, or APIs.

## Repository analysis checklist

1. Read `README.md`, `pubspec.yaml`, and Flutter entry points.
2. Inspect `lib/` architecture (features, repositories, controllers, models, widgets).
3. Identify dependencies from `pubspec.yaml` and verify actual usage in source code.
4. Inspect assets (`assets/`) and project media files under `portfolio/projects/<slug>/media/`.
5. Inspect tests under `test/` and static analysis config (`analysis_options.yaml`).
6. Analyze build/deployment targets from Flutter platform directories (`android/`, `ios/`, `linux/`, `macos/`).
7. Review generated analysis artifacts under `portfolio/analysis/<slug>/` when available.

## Feature detection rules

- Detect features from implemented code paths and models.
- Never infer feature existence only from dependency presence.
- Map each feature to source files and evidence references.

## Technical analysis expectations

Capture:

- Architecture and module boundaries
- Routing/navigation approach
- State management
- Database/data persistence model
- Authentication and integrations
- Performance or UX-related implementation details
- Testing and validation infrastructure

## Content generation rules

Generate:

- `project.json` updates (verified facts only)
- case-study draft sections under `case-study/drafts/`
- media mappings via `media.yml`

## Truthfulness constraints

- Never fabricate metrics, users, testimonials, timelines, or outcomes.
- Mark unknown values as `unknown` or leave null placeholders.
- Keep claims traceable via `evidence` references.

## Workflow states

Use these states for case-study content:

`generated -> draft -> human_review -> approved -> published`

Always preserve existing approved content when creating new drafts.
