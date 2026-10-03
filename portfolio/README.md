# Portfolio Project System

This directory stores machine-readable, AI-ready project documentation separate from Flutter UI code.

## Structure

- `schemas/`: JSON Schemas for project metadata, case-study sections, and media assets.
- `projects/<slug>/`: project-specific content, evidence, media manifest, and case-study versions.
- `analysis/<slug>/`: generated repository analysis output.
- `docs/`: authoring and workflow guidance.

## Commands

Run from repository root:

- Create project entry from template: `dart run scripts/create_project_entry.dart --slug my-project --title "My Project"`
- Analyze repository: `dart run scripts/analyze_project.dart --project habit-tracker`
- Validate project + media + content rules: `dart run scripts/validate_project.dart`
- Validate media only: `dart run scripts/validate_media.dart`
- Generate draft case study: `dart run scripts/generate_case_study.dart --project habit-tracker`
- Mark latest draft reviewed: `dart run scripts/review_case_study.dart --project habit-tracker`
- Publish latest reviewed draft: `dart run scripts/publish_case_study.dart --project habit-tracker`

## Data Separation Rules

- Verified facts must remain evidence-backed.
- AI-generated narrative must remain in draft/reviewed workflow states.
- Published case-study output is only created after explicit review + publish step.
- Media manifest metadata distinguishes real screenshots from generated visuals and design artifacts.
