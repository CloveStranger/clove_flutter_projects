# Build & Release Workflow

This document defines the standard workflow for an AI agent to assist with building release artifacts for applications in this workspace.

## Goal
To guide the user through versioning and building the application for a specific platform, ensuring a consistent release process.

## Workflow Steps

### 1. Identify Target Project & Platform
*   **Pre-computation**: Scan `apps/` directory to identify available projects and read their `pubspec.yaml` to find the current version.
*   **Prompt**: 
    1.  List available applications and their current versions.
    2.  Ask the user to provide input in the specific format: `{App Name} {Platform} {Bump Type}`.
        *   **Bump Type Options**: `version` (Major/Minor/Patch logic handled next), `build` (increment build number), `none` (skip bump).
    *   *Prompt Text*: 
        ```text
        Available Apps:
        - [App Name] (Current: vX.Y.Z+N)
        
        Please input target: {App Name} {Platform} {Bump Type (version/build/none)}
        ```
*   **Action**: Verify the input validity (Project exists, Platform supported).

### 2. Version Bump (Prerequisite)
*   **Condition**: If Bump Type is `version` or `build`.
*   **Action**: Invoke the workflow defined in `@prompt_database/version_bump_workflow.md`.
    *   Skip the "Identify Target" step of that workflow since it's already known.
    *   If `none` was selected, skip this step.

### 3. Execute Build
*   **Context**: Ensure the agent is in the correct project directory or uses the `-C` flag (if supported) or changes directory context.
*   **Command Construction**:
    *   **Android**: 
        1.  `flutter build apk --release`
        2.  `flutter build appbundle --release`
    *   **iOS**: `flutter build ipa --release` (Export method may be required, e.g., `--export-options-plist`)
    *   **Web**: `flutter build web --release`
    *   **MacOS**: `flutter build macos --release`
*   **Action**: Run the constructed command.
*   **Monitor**: Watch for build errors. If errors occur, stop and report them.

### 4. Verify Output
*   **Action**: Check the standard output directory for the artifact.
    *   *Android*: `build/app/outputs/flutter-apk/` AND `build/app/outputs/bundle/release/`
    *   *iOS*: `build/ios/ipa/` (or similar depending on export)
    *   *Web*: `build/web/`
*   **Report**: Inform the user of the successful build and the path to the artifact.

## Example Interaction

**User**: "Build the app."

**Agent**:
> **Available Apps:**
> - `clove_todo` (Current: v1.0.0+1)
>
> Please input target: `{App Name} {Platform} {Bump Type (version/build/none)}`

**User**: "clove_todo android build"

**Agent**:
> **Step 1: Version Check**
> (Executes Version Bump Workflow for `build` bump...)
> *...Version updated to 1.0.0+2...*
>
> **Step 2: Building Artifacts**
> Running `flutter build apk --release`...
> Running `flutter build appbundle --release`...
>
> (Build completes)
>
> **Build Successful!**
> - APK: `apps/clove_todo/build/app/outputs/flutter-apk/app-release.apk`
> - Bundle: `apps/clove_todo/build/app/outputs/bundle/release/app-release.aab`