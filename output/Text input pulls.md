# [Web] Unify CanvasKit and Skwasm garbage collection

**Link**: [flutter#183867](https://github.com/flutter/flutter/pull/183867)

**Summary**: This pull request introduces a shared memory management system in `lib/src/engine/native_memory.dart` that both the CanvasKit and Skwasm renderers now utilize. It replaces renderer-specific finalization logic with unified `NativeMemoryFinalizer`, `UniqueRef`, and `CountedRef` abstractions, improving efficiency and enabling proper reference counting for objects like `ui.Image` and `ui.Picture`.

# [iOS] Skip interactive keyboard tests for iOS 26+

**Link**: [flutter#183757](https://github.com/flutter/flutter/pull/183757)

**Summary**: This pull request skips interactive keyboard tests that are no longer applicable to iOS 26+. This serves as a temporary measure while a more comprehensive refactoring of the keyboard test logic is tracked separately.

# Use Material.of(context) to clean up tests

**Link**: [flutter#183698](https://github.com/flutter/flutter/pull/183698)

**Summary**: This pull request cleans up Material-related tests by using `Material.of(context)` instead of manual element lookups. This is a preliminary step toward moving `MaterialInkController` out of the Material library as part of a larger effort to better layer Material widgets.

# [iOS] Add opt-in inline prediction text input support

**Link**: [flutter#183650](https://github.com/flutter/flutter/pull/183650)

**Summary**: This pull request adds an `enableInlinePrediction` option to text fields, allowing applications to explicitly control iOS 17's inline predictive text behavior. It updates the engine to map this setting to `UITextInlinePredictionType` and ensures that attributed marked text is handled correctly so that predictions are processed as expected.

# Fix selection highlight artifacts for faded selectable text

**Link**: [flutter#183628](https://github.com/flutter/flutter/pull/183628)

**Summary**: This pull request fixes a rendering bug where selecting text in a `SelectionArea` with `TextOverflow.fade` produced dark border artifacts. The fix separates the selection highlight painting from the fade overflow shader's `saveLayer`, ensuring the shader only applies to the text content itself.

**Screenshot or video**:

https://github.com/user-attachments/assets/22c3c8a1-3d17-40f3-8b77-fc48e9e91a25

https://github.com/user-attachments/assets/dbca31d9-edb0-4dea-a617-0bf8c2b809a8

# [iOS] Keep multiline CupertinoTextField placeholders in bounds

**Link**: [flutter#183622](https://github.com/flutter/flutter/pull/183622)

**Summary**: This pull request fixes a regression where multiline placeholders in `CupertinoTextField` could be positioned partially outside the text field's bounds when `maxLines` was null. The fix vertically aligns the combined group of the placeholder and editable text rather than just the editable child.

# Prevent last character from remaining visible when toggling obscureText

**Link**: [flutter#183488](https://github.com/flutter/flutter/pull/183488)

**Summary**: This pull request fixes an issue where the most recently entered character remains briefly visible if `obscureText` is toggled quickly (e.g., true -> false -> true). It ensures that all characters are immediately obscured when the property is set to true by resetting the pending character reveal timer.

**Screenshot or video**:

https://github.com/user-attachments/assets/94d2ba56-c551-4385-8f88-3dd746c8dc09

https://github.com/user-attachments/assets/992e0473-059c-4c7a-a1b1-8ca6bf222538

# [iOS] Reland platform view hitTest approach with 2026 updates

**Link**: [flutter#183484](https://github.com/flutter/flutter/pull/183484)

**Summary**: This pull request relands an improved hit testing approach for iOS platform views to fix issues where touches were incorrectly blocked or fell through. It enables hit testing directly regardless of policy and renames the `hitTestOnly` policy to `doNotBlockGesture` for clarity.

# Remove Material library dependencies from several widget tests

**Link**: [flutter#183309](https://github.com/flutter/flutter/pull/183309)

**Summary**: This pull request refactors several test files (including `absorb_pointer_test`, `container_test`, and `page_view_test`) to remove imports and dependencies on the Material library. This involves replacing Material widgets and constants with design-agnostic alternatives to better isolate widget-level testing.

# [Web][Desktop] Fix SelectableText word selection on right-click

**Link**: [flutter#183110](https://github.com/flutter/flutter/pull/183110)

**Summary**: This pull request addresses an issue where right-clicking `SelectableText` on macOS and web would incorrectly select the word at the click position. The update ensures that word selection matches native behavior (selecting the word on macOS/iOS but not on other platforms) and fixes a web-specific issue where the engine incorrectly sent word-selection ranges.

# Add await or ignore lint to invokeMethod callsites

**Link**: [flutter#182870](https://github.com/flutter/flutter/pull/182870)

**Summary**: This pull request adds `await` or `// ignore: unawaited_futures` to various `invokeMethod` calls throughout the framework to satisfy lint requirements. It also involves refactoring some methods to be asynchronous or handling errors via `.catchError` to ensure robust platform communication.

# Respect per-field autovalidateMode priority in forms

**Link**: [flutter#182752](https://github.com/flutter/flutter/pull/182752)

**Summary**: This pull request implements hierarchical validation logic where `FormField.autovalidateMode` takes precedence over the parent `Form` settings. It also fixes a bug where `AutovalidateMode.onUserInteraction` would trigger validation without actual user interaction.

# [macOS] Implement popup windows support

**Link**: [flutter#182371](https://github.com/flutter/flutter/pull/182371)

**Summary**: This pull request introduces support for popup windows on macOS. It includes a new `PopupWindowController` for managing these windows, handles positioning relative to an anchor element, and ensures the popup tracks the anchor even during window resizing.

# [Web] Fix autofill in iOS 26 Safari

**Link**: [flutter#182024](https://github.com/flutter/flutter/pull/182024)

**Summary**: This pull request fixes autofill issues in Safari on iOS 26 by reusing existing autofill forms instead of recreating them on every connection. It also introduces an `onFocusReceived` notification to re-establish text input connections when a field receives focus from the browser, accounting for iOS 26's new blur-then-focus behavior.

# Fix text selection handle directionality in mixed-directionality text

**Link**: [flutter#179928](https://github.com/flutter/flutter/pull/179928)

**Summary**: This pull request fixes an issue where selection handles would point the wrong way when selecting text with a different directionality than the app's ambient direction (e.g., LTR text in an RTL app). The logic was updated to determine handle types based on their visual horizontal position rather than purely on the logical selection range.

**Screenshot or video**:

https://github.com/user-attachments/assets/7de61b60-c1dd-44bb-a5c8-34ff5d451350

# [macOS] Run tests using Xcode 26 and iOS 26 simulator

**Link**: [flutter#179810](https://github.com/flutter/flutter/pull/179810)

**Summary**: This pull request updates the CI configuration to run macOS tests using Xcode 26 and the iOS 26 simulator. This ensures compatibility with the latest Apple platform versions.

# [Android] Fix selection handle alignment and implement auto-dismissal

**Link**: [flutter#178551](https://github.com/flutter/flutter/pull/178551)

**Summary**: This pull request fixes minor misalignments in the text selection handles and ensures that `EditableText` rebuilds its selection overlay when `cursorWidth` is updated. Additionally, it implements native Android behavior where selection handles automatically dismiss after 4 seconds of inactivity when the selection is collapsed.

**Screenshot or video**:

https://github.com/user-attachments/assets/99d69ea0-9559-4b79-8402-aa7657dc47b9

https://github.com/user-attachments/assets/d89d6a99-f026-4e59-bb17-ad8950aea6f0

# Use glyph boundaries for horizontal character traversal

**Link**: [flutter#178258](https://github.com/flutter/flutter/pull/178258)

**Summary**: This pull request implements horizontal character traversal using actual glyph information from the text layout instead of guessing boundaries. This ensures the caret correctly moves through RTL text and positions itself accurately between characters in complex scripts (like Indic) that involve text shaping.

**Screenshot or video**:

https://github.com/user-attachments/assets/57296793-6fcd-4ae8-a835-35eb95572c62

https://github.com/user-attachments/assets/b00a55d4-ca21-4ab8-8681-5c095288223d

# Expose buttons accessor on tap and drag details events

**Link**: [flutter#176968](https://github.com/flutter/flutter/pull/176968)

**Summary**: This pull request exposes the `buttons` bitfield and `kind` of device on several details classes, including `TapDownDetails`, `TapUpDetails`, and `DragStartDetails`. This allows developers to determine which mouse buttons were pressed during a gesture and ensures consistency across various gesture recognizers.
