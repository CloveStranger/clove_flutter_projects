# clove_flutter_workspace Context

## Project Overview
This is a Dart/Flutter monorepo workspace managed by **Melos**. It houses the `clove_todo` application and the `auto_go_router` ecosystem (runtime + builder). The project documentation and workflows are centralized in a git submodule.

**Key Technologies:**
*   **Language:** Dart (SDK ^3.8.0)
*   **Framework:** Flutter (managed via FVM)
*   **Workspace Manager:** Melos (configured in root `pubspec.yaml`)
*   **Code Generation:** `build_runner`, `source_gen`

## Directory Structure
*   `apps/`
    *   `clove_todo/`: The main Todo application.
*   `packages/`
    *   `auto_go_router/`: Runtime library for the router.
    *   `auto_go_router_builder/`: Code generator for type-safe routing.
*   `import/prompt_database/`: **Critical**. Contains project documentation, commit guidelines, and workflow specifications.
    *   `git_documents/`: Commit workflows and guidelines.
    *   `project_documents/`: Architecture and release specs.

## Building and Running (Melos Scripts)
This project uses `melos` to orchestrate commands across the workspace.

| Command | Description |
| :--- | :--- |
| `melos run bootstrap` | Install dependencies for all packages (`flutter pub get`). |
| `melos run clean` | Clean build artifacts (`flutter clean`). |
| `melos run test` | Run tests for all packages (`flutter test`). |
| `melos run analyze` | Run static analysis (`flutter analyze`). |
| `melos run format` | Format code (`dart format .`). |
| `melos run build_runner` | Run code generation (`dart run build_runner build`). |
| `melos run build_runner:watch` | Watch mode for code generation. |

## Development Conventions

### 1. Commit Messages
**Strict adherence required.** Refer to `import/prompt_database/git_documents/workspace_commit_guidelines.md`.

*   **Format:** `<type>(<scope>): <subject>`
*   **Scopes:**
    *   `[project_name]` for project-wide changes.
    *   `(package_name)` for package-specific changes.
    *   `global` for workspace-wide changes.
*   **Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`, `bump`.

### 2. Architecture
See `import/prompt_database/project_documents/ca_architecture_spec.md` for Clean Architecture rules.

### 3. Workflows
*   **Smart Commit:** `import/prompt_database/git_documents/smart_commit_workflow.md`
*   **Version Bump:** `import/prompt_database/project_documents/version_bump_workflow.md`

## Setup
1.  Ensure **FVM** is installed.
2.  Run `melos run bootstrap` to install dependencies.
3.  To run the app: `cd apps/clove_todo && fvm flutter run`.
