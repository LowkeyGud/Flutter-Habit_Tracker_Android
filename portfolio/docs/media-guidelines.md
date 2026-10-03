# Media Guidelines

## Naming convention

`<section>-<subject>-<variant>.<ext>`

Examples:

- `hero-main-interface.webp`
- `feature-habit-list-mobile.png`
- `architecture-data-flow.svg`

## Media classification

Choose one:

- `real-product-screenshot`
- `design-artifact`
- `mockup`
- `illustration`
- `generated-visual`
- `architecture-diagram`
- `video`

Never label generated visuals as real screenshots.

## Validation

```bash
dart run scripts/validate_media.dart --project <slug>
```

Checks:

- missing files
- duplicate IDs
- duplicate paths
- unsupported formats
