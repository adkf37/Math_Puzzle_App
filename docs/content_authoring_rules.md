# Content Authoring Rules

## Required puzzle fields
- `id`, `type`, `difficulty`, `recommended_age_band`
- `prompt`, `rules`
- `initial_state`, `solution`
- `hints` (exactly 3 levels recommended)
- `explanation` (`summary`, `steps`, `strategy_tip`)
- `tags`

## Hint ladder guidance
- Hint 1: broad strategy and where to look.
- Hint 2: directional, points to a region/cell/cage.
- Hint 3: near-solution step or forced move.
- Keep each hint to one short sentence for readability.

## Explanation template
- Summary: one sentence of what logic solved the puzzle.
- Steps: 3-6 short bullet-ready statements.
- Strategy tip: reusable idea for future puzzles.

## Tone and age fit
- Use plain language for grades 2-6.
- Prefer positive guidance over punitive phrasing.
- Avoid jargon unless defined in tutorial.

## Quality gates
- Each puzzle must pass `tool/validate_content.dart`.
- Solution state must satisfy validator.
- Each puzzle must include tutorial-compatible steps and a valid hint ladder.
