# [Android] Fix emoji insertion corruption using grapheme-aware text operations

**Link**: [flutter#183112](https://github.com/flutter/flutter/pull/183112)

**Summary**: This PR fixes a bug on Android where inserting emojis into an RTL `TextField` caused text corruption, such as rendering `?` characters. The issue occurred because the Android IME sends text updates using UTF-16 code unit positions, which could split surrogate pairs. The fix uses grapheme cluster boundaries for text replacement and adds validation logic to correct broken surrogate pairs before they reach the text input client.

**Screenshot or video**:

https://github.com/user-attachments/assets/701c78cb-f2c0-4cec-91fc-455f9490a6c3

https://github.com/user-attachments/assets/409cfbd2-ecae-4368-b508-fe674f43f8a2


# [Web][macOS] Fix SelectableText right-click selecting word

**Link**: [flutter#183110](https://github.com/flutter/flutter/pull/183110)

**Summary**: On macOS and web, right-clicking on `SelectableText` incorrectly selected the word at the click position. This PR overrides `onSecondaryTap` in `_SelectableTextSelectionGestureDetectorBuilder` to prevent this behavior. For read-only text, right-clicking should not expand the selection; the toolbar is now only shown if text is already selected.


# Replace BorderRadius.circular with const BorderRadius.all

**Link**: [flutter#183074](https://github.com/flutter/flutter/pull/183074)

**Summary**: This PR replaces usages of `BorderRadius.circular` with `const BorderRadius.all(Radius.circular(...))` across the codebase and documentation. This change enables the use of `const` constructors for widgets containing border radii, improving performance and consistency.


# [Impeller] Update comments regarding two-pass rendering discoveries

**Link**: [flutter#183050](https://github.com/flutter/flutter/pull/183050)

**Summary**: This PR updates comments in the Impeller engine to reflect new discoveries regarding the two-pass rendering system and its application to glyph caching. It also includes minor cleanup, such as removing an obsolete method declaration and moving a structure to a more appropriate header file.


# Add code-point mode for TextField maxLength counting

**Link**: [flutter#182920](https://github.com/flutter/flutter/pull/182920)

**Summary**: This PR introduces `MaxLengthCountType` to `TextField`, allowing developers to choose between counting characters (grapheme clusters) or Unicode code points for `maxLength` enforcement. This helps align client-side validation with server-side constraints that may rely on code point counts.


# Add await or ignore lint to invokeMethod callsites

**Link**: [flutter#182870](https://github.com/flutter/flutter/pull/182870)

**Summary**: As part of an effort to improve asynchronous code safety, this PR adds `await` to `invokeMethod` calls or applies `// ignore: unawaited_futures` where appropriate. In some cases, error handling was improved by reporting unawaited future errors to `FlutterError`.


# Respect per-field autovalidateMode priority in forms

**Link**: [flutter#182752](https://github.com/flutter/flutter/pull/182752)

**Summary**: This PR implements hierarchical validation logic where `FormField.autovalidateMode` takes precedence over the parent `Form` settings. If the field-level mode is null, it inherits the form-level configuration, falling back to `AutovalidateMode.disabled`.


# [iOS] Enable inline text prediction support

**Link**: [flutter#182728](https://github.com/flutter/flutter/pull/182728)

**Summary**: This PR adds support for inline predictive text on iOS 17+. It introduces an `enableInlinePrediction` parameter to `TextField` and `CupertinoTextField` and a `composingStyle` parameter to allow apps to style the suggested text (e.g., matching the native gray look).


# Remove material dependencies from several widget tests

**Link**: [flutter#182702](https://github.com/flutter/flutter/pull/182702)

**Summary**: This PR continues the effort to decouple the widgets library from the material library by removing material imports and widgets from various tests. It replaces them with minimal test-specific widgets or base `WidgetsApp` configurations.


# Unify text direction handling in InputDecorator and text fields

**Link**: [flutter#182477](https://github.com/flutter/flutter/pull/182477)

**Summary**: This PR adds a `textDirection` property to `InputDecoration` to ensure `labelText` and `hintText` are correctly resolved in RTL scenarios. This aligns the behavior of `InputDecorator` with `TextField` and `TextFormField`, improving consistency and reducing redundant configuration.


# [Web][iOS] Fix autofill in Safari for iOS 26

**Link**: [flutter#182024](https://github.com/flutter/flutter/pull/182024)

**Summary**: This fix addresses autofill issues in iOS 26 Safari by reusing existing autofill forms and fields instead of recreating them on every connection. It also introduces a `refocus` mechanism to re-establish text input connections when a field is blurred and then focused by the browser during an autofill operation.


# Remove material dependency from semantics debugger tests

**Link**: [flutter#181722](https://github.com/flutter/flutter/pull/181722)

**Summary**: This PR refactors `semantics_debugger_test.dart` to remove dependencies on Material widgets. It introduces minimal test widgets like `TestSlider`, `TestCheckbox`, and `TestTextField` to verify semantics behavior without pulling in the entire Material library.


# Expose computeLineMetrics on RenderParagraph

**Link**: [flutter#181240](https://github.com/flutter/flutter/pull/181240)

**Summary**: This PR adds a `computeLineMetrics` method to `RenderParagraph`, which forwards the call to the underlying `TextPainter`. This allows callers with access to the render object to retrieve line metrics without needing to duplicate layout logic or access private state.


# [iOS] Add translate action to selection context menu

**Link**: [flutter#180021](https://github.com/flutter/flutter/pull/180021)

**Summary**: This PR integrates the SwiftUI Translation API into Flutter's iOS text selection menu. Users can now select text and trigger the system "Translate" action, which opens a system-managed translation sheet.

**Screenshot or video**:

https://github.com/user-attachments/assets/8c508f93-2341-498a-b494-c83fafa878f4

https://github.com/user-attachments/assets/61025f9c-f937-4043-bee5-ee31761cf5c0

https://github.com/user-attachments/assets/3a7e851f-c892-4b9f-b77d-e09588dec63f


# Fix text selection handle directionality in mixed-directionality text

**Link**: [flutter#179928](https://github.com/flutter/flutter/pull/179928)

**Summary**: This PR fixes an issue where text selection handles pointed the wrong way when selecting text with directionality different from the ambient environment (e.g., LTR text in an RTL app). The logic now determines handle types based on their visual horizontal position rather than just logical selection range.

**Screenshot or video**:

https://github.com/user-attachments/assets/7de61b60-c1dd-44bb-a5c8-34ff5d451350

https://github.com/user-attachments/assets/bbe200c1-7733-41ad-9917-4d1982d273ff

https://github.com/user-attachments/assets/15d25ff7-47f3-439f-9efd-f82a4a890cbd


# [Android] Fix selection handle alignment and implement auto-dismissal

**Link**: [flutter#178551](https://github.com/flutter/flutter/pull/178551)

**Summary**: This PR improves text selection on Android by fixing a slight misalignment of selection handles, ensuring `cursorWidth` updates reflect immediately, and implementing a 4-second auto-dismissal for handles during inactivity to match native behavior.

**Screenshot or video**:

https://github.com/user-attachments/assets/99d69ea0-9559-4b79-8402-aa7657dc47b9

https://github.com/user-attachments/assets/d89d6a99-f026-4e59-bb17-ad8950aea6f0


# Use glyph boundaries for horizontal character traversal

**Link**: [flutter#178258](https://github.com/flutter/flutter/pull/178258)

**Summary**: This PR implements horizontal character traversal using actual glyph information from text layout instead of guessing boundaries from underlying text. This ensures correct caret movement in RTL text and complex scripts where text shaping affects character positioning.

**Screenshot or video**:

https://github.com/user-attachments/assets/57296793-6fcd-4ae8-a835-35eb95572c62

https://github.com/user-attachments/assets/b00a55d4-ca21-4ab8-8681-5c095288223d


# Expose buttons accessor on tap and drag details

**Link**: [flutter#176968](https://github.com/flutter/flutter/pull/176968)

**Summary**: This PR adds a `buttons` field and `kind` (device type) to various gesture details classes, including `TapDownDetails`, `TapUpDetails`, and drag details. This allows developers to identify which mouse buttons triggered a gesture and what type of device was used.
