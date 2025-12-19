# Version Bump Workflow

This document defines the standard workflow for an AI agent to assist with versioning and release management in this workspace.

## Goal
To safely increment the application version or build number, update the configuration files, and commit the change using the standard workspace guidelines.

## Workflow Steps

### 1. Identify Target Project
*   **Context**: The workspace may contain multiple apps or packages (e.g., in `apps/` or `packages/`).
*   **Prompt**: "Which project or package would you like to bump? (e.g., `clove_todo`, `ui_kit`)"
*   **Action**: Locate the correct directory for the specified project.

### 2. Analyze Current Version
*   **Command**: Read `pubspec.yaml` (or equivalent config file like `package.json`, `build.gradle`) in the target project/package.
*   **Action**: Identify the current `version` string (e.g., `1.0.0+1`).

### 3. User Consultation
*   **Prompt**: "The current version of `<project>` is `<current_version>`. Should I bump the **Version** (Major/Minor/Patch) or the **Build Number**?"
*   **Wait**: Await user input.

### 4. Apply Changes
*   **Action**: Modify the configuration file with the new version number.
    *   *Version Bump*: `1.0.0+1` -> `1.0.1+1` (reset build number? Optional, usually keep incrementing or reset depending on project policy. Default: keep build number or increment it too).
    *   *Build Bump*: `1.0.0+1` -> `1.0.0+2`.
*   **Verification**: `grep` or `read_file` to confirm the change.

### 5. Generate Commit Message
*   **Reference**: `prompt_database/workspace_commit_guidelines.md`.
*   **Format**: `bump(<scope dir>)[<package name>]: <subject>`
*   **Example**:
    *   `bump(apps)[clove_todo]: upgrade to v1.0.1+2`
    *   `bump(packages)[ui_kit]: increment build number to 15`

### 6. Execute Commit (Smart Commit Workflow)
*   **Reference**: `prompt_database/smart_commit_workflow.md`.
*   **Action**:
    1.  Show the diff and the proposed commit message.
    2.  Ask for confirmation.
    3.  Run `git add <config_file>`.
    4.  Run `git commit ...`.
    5.  (Optional) Run `git tag v<new_version>`.

## Example Interaction

**User**: "Bump the version."

**Agent**:
> Which project would you like to bump?

**User**: "clove_todo"

**Agent**:
> Checked `apps/clove_todo/pubspec.yaml`. Current version is `1.0.0+1`.
> Do you want to bump the **version** (to 1.0.1) or just the **build number** (to +2)?

**User**: "Build number."

**Agent**:
> Updating `apps/clove_todo/pubspec.yaml` to `1.0.0+2`.
>
> **Proposed Commit:**
> ```text
> bump(apps)[clove_todo]: increment build number to 1.0.0+2
> ```
>
> Shall I proceed?

**User**: "Yes."

**Agent**: (Executes git commit)