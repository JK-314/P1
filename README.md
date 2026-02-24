# Eatsence

Anonymous persona-based social matching app built with Flutter.

## Core Concept: 3-Step Bridge Matching System

1. **Step 1 — Persona Profile (페르소나 프로필):** Users create a fully anonymous persona across 4 categories. No personal identifiers (name, age, photo) are ever exposed.
2. **Step 2 — Bridge Matching (브릿지 매칭):** System matches personas based on compatibility scores across all dimensions.
3. **Step 3 — Connection (커넥션):** Mutual consent required before any identity sharing. Users control the gradual reveal.

## Persona Categories

| Category | Korean | Description |
|----------|--------|-------------|
| Economic Capacity | 경제력 | Spending habits, financial goals, lifestyle tier |
| Health | 건강 | Fitness habits, dietary preferences, wellness priorities |
| Life Rhythm | 생활 리듬 | Daily routines, sleep schedule, work-life balance |
| Values & Philosophy | 가치관/철학 | Beliefs, relationship values, life priorities |

## Tech Stack

- **Flutter** — Cross-platform UI framework
- **Riverpod** — State management (Notifier/AsyncNotifier)
- **Supabase** — Backend (auth, database, realtime, storage)
- **Material 3** — Clean & minimalist UI design
- **go_router** — Declarative routing
- **freezed** — Immutable data models
- **fpdart** — Functional error handling (Either pattern)

## Architecture

Clean Architecture with 3 layers per feature module:

```
lib/
├── core/               # Shared utilities, theme, routing
├── features/
│   ├── auth/           # Authentication
│   ├── persona/        # Persona profile management
│   ├── matching/       # Bridge matching system
│   └── connection/     # Post-match connections
└── main.dart
```

Each feature contains:
- `presentation/` — Screens, widgets, Riverpod providers
- `domain/` — Entities, use cases, repository interfaces
- `data/` — Models, repository implementations, data sources

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app (provide Supabase credentials)
flutter run \
  --dart-define=SUPABASE_URL=your_url \
  --dart-define=SUPABASE_ANON_KEY=your_key
```

## Development

```bash
# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Run tests
flutter test

# Format code
dart format .

# Analyze code
dart analyze
```
