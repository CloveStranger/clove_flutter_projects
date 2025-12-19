# clove_flutter_workspace Context

## Project Overview
This is a Dart/Flutter monorepo workspace managed by **Melos**. It primarily houses the `auto_go_router` ecosystem, which consists of a runtime package and a code generator for type-safe routing using `go_router`.

**Key Technologies:**
*   **Language:** Dart (SDK ^3.8.0)
*   **Framework:** Flutter (managed via FVM)
*   **Workspace Manager:** Melos
*   **Code Generation:** `build_runner`, `source_gen`

## Directory Structure
*   `packages/`
    *   `auto_go_router`: Runtime library for the router.
    *   `auto_go_router_builder`: Code generator (builder) for the router.
*   `prompt_database/`: Contains critical project documentation and guidelines.
    *   `workspace_commit_guidelines.md`: Strict commit message rules.
    *   `ca_architecture_spec.md`: Clean Architecture specifications.

## Building and Running (Melos Scripts)
This project uses `melos` to run commands across all packages.

| Command | Description |
| :--- | :--- |
| `melos bootstrap` | Install dependencies for all packages (`flutter pub get`). |
| `melos run clean` | Clean build artifacts (`flutter clean`). |
| `melos run test` | Run tests for all packages (`flutter test`). |
| `melos run analyze` | Run static analysis (`flutter analyze`). |
| `melos run format` | Format code (`dart format .`). |
| `melos run build_runner` | Run code generation (`dart run build_runner build`). |
| `melos run build_runner:watch` | Watch mode for code generation. |

## Development Conventions

### 1. Commit Messages
**Strict adherence required.** See `prompt_database/workspace_commit_guidelines.md`.

*   **Format:** `<type>(<scope>): <subject>`
*   **Scopes:**
    *   `[project_name]` for project-wide changes.
    *   `(package_name)` for package-specific changes (e.g., `(auto_go_router)`).
*   **Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`, `bump`.

### 2. Architecture & Testing
See `prompt_database/ca_architecture_spec.md` for detailed Clean Architecture and testing guidelines.

*   **Domain Layer:** Pure Dart, 100% test coverage required.
*   **Data Layer:** Repositories & Data Sources, ≥ 80% coverage.
*   **Presentation Layer:** BLoC (≥ 90%) & Widgets (≥ 70%).
*   **Dependency Injection:** `get_it` / `injectable` (recommended).
*   **Routing:** `go_router` + `auto_go_router_builder` (Type-safe).

## Setup
1.  Ensure **FVM** is installed.
2.  Run `fvm flutter pub get` in the root (or `melos bootstrap` if melos is globally installed).
