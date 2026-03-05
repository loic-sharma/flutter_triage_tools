# [Android] Fix emoji insertion corruption by using grapheme-aware text operations

**Link**: [flutter#183112](https://github.com/flutter/flutter/pull/183112)

**Summary**: Fixes a bug where inserting emojis into an RTL `TextField` on Android would cause text corruption and render `?` characters. The issue stemmed from the Android IME sending updates using UTF-16 code unit positions, which could split surrogate pairs. The fix updates `TextEditingValue.replaced()` and `TextInput` to use grapheme cluster boundaries, ensuring surrogate pairs are preserved and corrected when received from the platform.

**Screenshot or video**:

https://github.com/user-attachments/assets/701c78cb-f2c0-4cec-91fc-455f9490a6c3

https://github.com/user-attachments/assets/409cfbd2-ecae-4368-b508-fe674f43f8a2


# [Web/Desktop] Fix SelectableText right-click selecting word

**Link**: [flutter#183110](https://github.com/flutter/flutter/pull/183110)

**Summary**: On macOS and web, right-clicking on `SelectableText` incorrectly selected the word at the click position. Since `SelectableText` is a read-only widget, selection should only occur through deliberate gestures. The fix overrides `onSecondaryTap` to skip word selection, ensuring the context menu is shown without modifying the existing selection state.


# Replace BorderRadius.circular with const BorderRadius.all and update documentation

**Link**: [flutter#183074](https://github.com/flutter/flutter/pull/183074)

**Summary**: This PR replaces usages of `BorderRadius.circular` with `const BorderRadius.all(Radius.circular(...))` across the framework. This change promotes the use of compile-time constants for border radii, improving performance. All code examples in the documentation were also updated to reflect this recommended style.


# Add code-point mode for TextField maxLength counting

**Link**: [flutter#182920](https://github.com/flutter/flutter/pull/182920)

**Summary**: Introduces `MaxLengthCountType` to `TextField`, allowing developers to choose between counting characters (grapheme clusters) or Unicode code points for `maxLength` enforcement. This helps apps align client-side validation with backend rules that use code point counting. The change also updates `LengthLimitingTextInputFormatter` to handle truncation and counter display consistently under the selected mode.


# Add await or ignore lint to invokeMethod callsites

**Link**: [flutter#182870](https://github.com/flutter/flutter/pull/182870)

**Summary**: Addresses `unawaited_futures` lint warnings at `MethodChannel.invokeMethod` call sites across the framework. It adds `await` where appropriate or `// ignore: unawaited_futures` for intentional fire-and-forget calls to avoid breaking public API signatures. It also corrects several tests where futures were incorrectly awaited before checking for expected exceptions.


# Respect per-field autovalidateMode priority in forms

**Link**: [flutter#182752](https://github.com/flutter/flutter/pull/182752)

**Summary**: Implements hierarchical validation logic where `FormField.autovalidateMode` now takes precedence over the parent `Form` settings. If the field-level mode is unspecified, it inherits from the form; otherwise, it defaults to disabled. This allows granular control over validation behavior for individual fields within a single form.


# [iOS] Enable inline text prediction support

**Link**: [flutter#182728](https://github.com/flutter/flutter/pull/182728)

**Summary**: Adds support for iOS 17+ inline predictive text (the gray suggestions appearing after the cursor). It introduces an `enableInlinePrediction` parameter to toggle the feature and a `composingStyle` parameter to `EditableText` for styling the suggestion text. The engine implementation was updated to handle the native `UITextInlinePredictionType` and marked text protocols.


# Remove Material dependencies from various widget and sliver tests

**Link**: [flutter#182702](https://github.com/flutter/flutter/pull/182702)

**Summary**: Refactors several test files, including `widget_inspector_test` and `scrollable_fling_test`, to remove dependencies on the Material library. Material-specific widgets are replaced with basic widgets or custom test implementations to ensure that framework tests only depend on the specific libraries they are intended to exercise.


# Unify text direction handling in InputDecorator and text fields

**Link**: [flutter#182477](https://github.com/flutter/flutter/pull/182477)

**Summary**: Adds a `textDirection` property to `InputDecoration` and aligns its behavior with `TextField` and `TextFormField`. This ensures that `labelText` and `hintText` are correctly resolved, particularly in RTL contexts, without requiring redundant configuration across the input widgets and their decorations.


# [Web] Fix autofill for Safari on iOS 26

**Link**: [flutter#182024](https://github.com/flutter/flutter/pull/182024)

**Summary**: Fixes Safari autofill issues on iOS 26 by reusing existing autofill forms/fields instead of recreating them. It also introduces an `onFocusReceived` notification to re-establish text input connections when Safari briefly blurs and refocuses a field during the autofill process, ensuring the framework remains in sync with the browser.


# Remove Material dependency from semantics_debugger_test

**Link**: [flutter#181722](https://github.com/flutter/flutter/pull/181722)

**Summary**: Refactors `semantics_debugger_test.dart` to eliminate its dependency on Material widgets. Components like `ElevatedButton` and `TextField` are replaced with minimal test widgets (`TestButton`, `TestTextField`) that support the necessary semantic actions. This ensures the test is properly decoupled from the Material library.


# Expose computeLineMetrics on RenderParagraph

**Link**: [flutter#181240](https://github.com/flutter/flutter/pull/181240)

**Summary**: Exposes `TextPainter.computeLineMetrics()` through a new forwarding method on `RenderParagraph`. This allows callers with access to the render object to retrieve detailed line metrics without needing to duplicate layout logic or access internal state, following the pattern of existing query methods.


# [iOS] Add Translate action to text selection context menu

**Link**: [flutter#180021](https://github.com/flutter/flutter/pull/180021)

**Summary**: Adds a "Translate" action to the iOS text selection context menu using the SwiftUI translation API introduced in WWDC 2024. This allows users to translate selected text using the system's native interface. The implementation includes a toggle to enable/disable the feature and handles the presentation of the system translation view.

**Screenshot or video**:

https://github.com/user-attachments/assets/8c508f93-2341-498a-b494-c83fafa878f4

https://github.com/user-attachments/assets/61025f9c-f937-4043-bee5-ee31761cf5c0

https://github.com/user-attachments/assets/3a7e851f-c892-4b9f-b77d-e09588dec63f


# Use glyph boundaries for horizontal character traversal

**Link**: [flutter#178258](https://github.com/flutter/flutter/pull/178258)

**Summary**: Implements horizontal caret traversal (arrow keys) using actual glyph information from text layout instead of estimating boundaries from the underlying text. This fix ensures correct caret movement through RTL text and complex scripts (like Indic) where text shaping affects visual character positioning.

**Screenshot or video**:

https://github.com/user-attachments/assets/57296793-6fcd-4ae8-a835-35eb95572c62

https://github.com/user-attachments/assets/b00a55d4-ca21-4ab8-8681-5c095288223d


# Expose buttons accessor on tap detail events

**Link**: [flutter#176968](https://github.com/flutter/flutter/pull/176968)

**Summary**: Adds a `buttons` property to `TapDownDetails` and `TapUpDetails` to identify which mouse buttons were used during a tap gesture. The PR also generalizes this by adding `buttons` and `kind` (device type) to various other gesture detail classes, providing better support for multi-button mouse interactions on desktop and web.
