# MVP Product Spec and UX Flows

## Audience and principles
- Primary users are ages 7-12.
- Parents/teachers can switch local profiles.
- All in-app flows are kid-safe by default: no external browsing links, no chat, no public identity.

## Key screens
- `Profile Select/Create`: choose profile icon/name, create local profile.
- `Home`: start puzzle, daily puzzle, progress/badges.
- `Puzzle Type Gallery`: six MVP puzzle types.
- `Difficulty Select`: Easy/Medium/Hard entry points.
- `Puzzle Player`: board interaction, undo/redo, hint ladder, show solution gate.
- `Hint Modal/Card`: Hint 1 -> Hint 2 -> Hint 3 progression.
- `Explanation Screen`: summary + 3-6 reasoning steps + strategy tip.
- `Progress/Badges`: completion by puzzle type/tier and achievements.
- `Daily Puzzle`: daily entry and streak display.

## Navigation map and back behavior
- Bottom nav root tabs: Home, Profile, Settings.
- Home actions push to puzzle select, daily, and progress screens.
- Puzzle select pushes puzzle player.
- Puzzle player can push tutorial and explanation screens.
- Back behavior:
  - Child screens pop to previous screen.
  - Root tabs do not pop app state on tab switches.

## Interaction standards
- Minimum body text size: 16sp equivalent.
- Minimum touch target: 48x48 logical pixels.
- Clear icon + text labels for all primary actions.

## Error and support states
- Invalid move feedback: maintain board state and show non-blocking message.
- Stuck flow: Hint button available at all times in puzzle player.
- Give up flow: show solution button enabled only after 2 hints (or explicit confirmation if adapted).
- Content loading failure: show retry message and return path to home.

## Success metrics
- Tutorial completion rate by puzzle type.
- Hint usage distribution (hint1/hint2/hint3).
- Daily puzzle completion and streak continuation.
- Solve rate and average time by difficulty tier.
