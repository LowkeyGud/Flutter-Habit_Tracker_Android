# Project Authoring Guide

## Add a project

1. Create `portfolio/projects/<slug>/`.
2. Add `project.json`, `README.md`, `story.md`, `media.yml`.
3. Add media files in `media/` folders.
4. Reference evidence paths in `project.json` section `evidence` arrays.

## `project.json` rules

- Keep facts evidence-backed.
- Use stable IDs for project, features, challenges, and sections.
- Keep ownership as solo unless explicitly changed.
- Unknown values should be `unknown` or null.

## Validate

```bash
dart run scripts/validate_project.dart --project <slug>
```
