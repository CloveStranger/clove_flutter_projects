# Smart Commit Workflow

This document defines the standard workflow for an AI agent to assist with git commits in this workspace.

## Goal
Automatically summarize code changes, generate a commit message adhering to `@prompt_database/workspace_commit_guidelines.md`, review it with the user, and execute the commit.

## Workflow Steps

### 1. Analyze Context & Changes
*   **Command**: Run `git status` to see the state of the working directory.
*   **Command**: Run `git diff HEAD` to view all changes (staged and unstaged) OR `git diff --staged` if the user explicitly focuses on staged files.
*   **Action**: specific file content reading (`read_file`) may be required if the diff is too large or ambiguous, to fully understand the semantic meaning of the change.

### 2. Generate Commit Message
*   **Reference**: Strictly follow the format in `prompt_database/workspace_commit_guidelines.md`.
*   **Format Construction**:
    *   **Header**: `<type>(<scope dir>)[<package name>]: <subject>`
        *   *Example*: `feat(apps)[clove_todo]: add login screen`
        *   Ensure the scope correctly uses `()` for the directory category (e.g., apps, packages) and `[]` for the specific project/package name.
    *   **Body**: specific bullet points explaining *why* and *what* changed.
    *   **Footer**: Reference issues if applicable (e.g., `Closes #123`).

### 3. User Review
*   **Output**: Present the generated commit message to the user in a code block.
*   **Prompt**: Ask the user for confirmation: "Does this commit message look correct? Should I proceed with the commit?"

### 4. Execution
*   **Condition**: ONLY proceed if the user explicitly agrees (e.g., "yes", "y", "confirm").
*   **Command**: Execute `git commit -m "<header>" -m "<body>"`.
*   **Post-Commit**: Run `git status` to confirm the clean state.

## Example Interaction

**User**: "Commit these changes."

**Agent**:
> I see you've modified `apps/clove_todo/lib/main.dart`.
>
> **Proposed Commit:**
> ```text
> fix(apps)[clove_todo]: resolve null pointer exception in startup
>
> - Added null check for `userSession` in `main()`
> - Initialized default theme settings to prevent crash
> ```
>
> Shall I commit this?

**User**: "Yes."

**Agent**: (Executes `git commit ...`)
