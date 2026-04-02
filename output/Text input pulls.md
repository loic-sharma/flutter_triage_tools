# Add more error handling to unawaited callsites

**Link**: [flutter#184526](https://github.com/flutter/flutter/pull/184526)

**Summary**: This pull request adds error handling to unawaited callsites, specifically within `SemanticsService.sendAnnouncement`. It is part of a larger effort to improve error reporting and maintainability across the framework.

# Remove editable_text_utils cross-imports from material and cupertino tests

**Link**: [flutter#184519](https://github.com/flutter/flutter/pull/184519)

**Summary**: This PR removes cross-directory test imports of `editable_text_utils.dart` by duplicating the utility into the Material and Cupertino test directories. This follows project guidelines for small test utilities and unblocks future cleanup of other test utility imports.

# Remove live_text_utils cross-imports from material and cupertino tests

**Link**: [flutter#184517](https://github.com/flutter/flutter/pull/184517)

**Summary**: This PR duplicates the `live_text_utils.dart` test utility into the Material and Cupertino test folders to eliminate cross-directory imports. While review comments suggested improving the mock handler's return values, the implementation was kept consistent with the original version to stay within the PR's scope.

# Reland "Even more awaits"

**Link**: [flutter#184467](https://github.com/flutter/flutter/pull/184467)

**Summary**: This PR relands a previously reverted change that adds `await` to various asynchronous callsites. It resolves a specific issue (#184315) and is part of a broader effort to ensure proper asynchronous execution within the framework.

# [Fuchsia] Work in progress for VMEX resource

**Link**: [flutter#184422](https://github.com/flutter/flutter/pull/184422)

**Summary**: This is a work-in-progress PR related to obtaining VMEX resources on Fuchsia. Review feedback identified that the implementation needs platform-specific guards to prevent build failures on other operating systems like Android and iOS.

# Fix visual misalignment of WidgetSpan when text alignment changes

**Link**: [flutter#184347](https://github.com/flutter/flutter/pull/184347)

**Summary**: This PR fixes a bug where `WidgetSpan` children within a `RenderParagraph` would remain at stale positions when `textAlign` changed (e.g., during window resizing). It ensures that inline child offsets are synchronized with the text's paint offset on every repaint and includes a fix for Z-axis scaling in `_RenderScaledInlineWidget`.

# Remove trivial test utility cross-imports from material and cupertino tests

**Link**: [flutter#184295](https://github.com/flutter/flutter/pull/184295)

**Summary**: This PR duplicates four small test utilities (`test_border.dart`, `sliver_test_utils.dart`, `process_text_utils.dart`, and `list_tile_tester.dart`) into the Material and Cupertino test suites to remove cross-directory imports. It also adds documentation to all public members of these utilities based on reviewer feedback.

# Remove feedback_tester cross-imports from material tests

**Link**: [flutter#184279](https://github.com/flutter/flutter/pull/184279)

**Summary**: This PR removes cross-directory imports of the `feedback_tester.dart` utility by duplicating it into the Material test directory. The utility is validated implicitly by the tests that utilize it.

# Remove clipboard_utils cross-imports from material and cupertino tests

**Link**: [flutter#184278](https://github.com/flutter/flutter/pull/184278)

**Summary**: This PR duplicates the `clipboard_utils.dart` test utility into the Material and Cupertino test directories. The duplication includes improvements to type safety for clipboard data and a fix for a missing `break` statement in the mock method call handler.

# [Android] Remove unused variable in ProcessTextPlugin.java

**Link**: [flutter#184161](https://github.com/flutter/flutter/pull/184161)

**Summary**: This PR simplifies the Android `ProcessTextPlugin` implementation by removing an unused variable.
