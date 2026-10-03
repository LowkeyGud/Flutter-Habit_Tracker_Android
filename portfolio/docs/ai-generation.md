# AI Generation Workflow

## Analyze

```bash
dart run scripts/analyze_project.dart --project <slug>
```

This writes machine-readable files under `portfolio/analysis/<slug>/`.

## Generate draft case study

```bash
dart run scripts/generate_case_study.dart --project <slug>
```

## Review and approve flow

```bash
dart run scripts/review_case_study.dart --project <slug>
dart run scripts/publish_case_study.dart --project <slug>
```

Publishing requires reviewed status and preserves the previous approved file under `case-study/revisions/`.
