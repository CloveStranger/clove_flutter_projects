# Workspace Commit Guidelines

This document outlines the guidelines for committing changes within this workspace. Adhering to these guidelines ensures a clear, consistent, and traceable commit history.

## Commit Message Format

Each commit message should consist of a header, a body, and a footer.

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

### Type

The type describes the kind of change that this commit is introducing.

-   **feat**: A new feature
-   **fix**: A bug fix
-   **docs**: Documentation only changes
-   **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc.)
-   **refactor**: A code change that neither fixes a bug nor adds a feature
-   **perf**: A code change that improves performance
-   **test**: Adding missing tests or correcting existing tests
-   **build**: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
-   **ci**: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
-   **chore**: Other changes that don't modify src or test files
-   **revert**: Reverts a previous commit
-   **bump**: Version changes or build number increments

### Scope

The scope should identify the affected part of the codebase. It uses square brackets `[]` for projects (e.g., `apps`, `packages`) and parentheses `()` for individual packages or modules within those projects.

-   **Project Scope**: Use `[project_name]` for changes affecting the project structure or multiple packages within a project.
-   **Package Scope**: Use `(package_name)` for changes specific to a single package or module.

If the change affects multiple packages, you can use "global" or a comma-separated list of package names.

### Subject

The subject contains a succinct description of the change:

-   Use the imperative, present tense: "change" not "changed" nor "changes"
-   Don't capitalize the first letter
-   No period (.) at the end

### Body

Just as in the subject, use the imperative, present tense: "fix" not "fixed."
The body should include the motivation for the change and contrast this with previous behavior.

### Footer

The footer should contain any information about Breaking Changes and reference issues by their ID.

## Examples

```
feat(apps)[clove_todo]: add new task creation feature

This commit introduces a new feature that allows users to create new tasks
directly from the main screen. The new task form includes fields for
title, description, and due date.

Closes #123
```

```
fix(apps)[clove_todo]: correct task due date display bug

The previous implementation incorrectly displayed the due date by off-by-one error
when parsing from the database. This commit corrects the parsing logic.
```
