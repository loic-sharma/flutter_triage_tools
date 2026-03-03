# [Android] Fix emoji insertion corruption by using grapheme-aware text operations

**Link**: [flutter#183112](https://github.com/flutter/flutter/pull/183112)

**Summary**: Fixes a bug where inserting emojis between existing emojis in an RTL `TextField` on Android would corrupt the text. The Android IME sends text updates using UTF-16 code unit positions, which can split surrogate pairs. The fix updates `TextEditingValue.replaced()` to use grapheme cluster boundaries and introduces `TextInput._validateAndCorrectTextEditingValue()` to fix broken surrogate pairs before they reach the text input client.

**Screenshot or video**:

https://github.com/user-attachments/assets/701c78cb-f2c0-4cec-91fc-455f9490a6c3
https://github.com/user-attachments/assets/409cfbd2-ecae-4368-b508-fe674f43f8a2

# [Web/Desktop] Fix SelectableText right-click selecting word on web/desktop

**Link**: [flutter#183110](https://github.com/flutter/flutter/pull/183110)

**Summary**: On macOS and web, right-clicking on `SelectableText` incorrectly selected the word at the click position. This PR adds an `onSecondaryTap` override to `_SelectableTextSelectionGestureDetectorBuilder` to prevent word selection on right-click, as `SelectableText` is read-only. The selection toolbar is now only shown if text is already selected.

# Replace BorderRadius.circular with const BorderRadius.all and update documentation examples

**Link**: [flutter#183074](https://github.com/flutter/flutter/pull/183074)

**Summary**: This PR replaces usages of `BorderRadius.circular(double radius)` with `const BorderRadius.all(Radius.circular(radius))` across the framework and its documentation. This change improves code consistency and enables the use of `const` constructors where applicable.

# [Impeller] Update comments to reflect new info about 2-pass rendering

**Link**: [flutter#183050](https://github.com/flutter/flutter/pull/183050)

**Summary**: Updates Impeller's source code comments to reflect new discoveries regarding the 2-pass rendering system and glyph caching. It also removes an obsolete method declaration and moves a internal structure to a more appropriate header file.

# TextField: add code-point mode for maxLength counting

**Link**: [flutter#182920](https://github.com/flutter/flutter/pull/182920)

**Summary**: Introduces `MaxLengthCountType` to `TextField`, allowing developers to choose between counting maximum length by user-perceived grapheme clusters (default) or by Unicode code points. This enables applications to align client-side character limits with server-side validation rules that may depend on code point counts.

# Add await or ignore lint to invokeMethod callsites

**Link**: [flutter#182870](https://github.com/flutter/flutter/pull/182870)

**Summary**: This PR addresses `unawaited_futures` lint warnings by adding `await` or `// ignore: unawaited_futures` to `invokeMethod` callsites. It includes refactoring some methods to be asynchronous and ensures that unawaited production errors are reported to `FlutterError`.

# Respect per-field autovalidateMode priority

**Link**: [flutter#182752](https://github.com/flutter/flutter/pull/182752)

**Summary**: Implements a hierarchical validation priority where `FormField.autovalidateMode` takes precedence over the parent `Form` settings. If the field-level mode is unspecified, it inherits from the form, with a final fallback to `AutovalidateMode.disabled`.

# [iOS] Enable inline text prediction on iOS

**Link**: [flutter#182728](https://github.com/flutter/flutter/pull/182728)

**Summary**: Adds support for inline predictive text (the gray suggestions appearing after the cursor) on iOS 17+. Developers can now enable or disable this feature per field via `enableInlinePrediction` and customize the appearance of the prediction region using the new `composingStyle` parameter.

# Refactor: remove material from widget_inspector_test, sliver_cross_axis_group_test, editable_text_show_on_screen_test, scrollable_fling_test, selection_container_test

**Link**: [flutter#182702](https://github.com/flutter/flutter/pull/182702)

**Summary**: Removes Material library dependencies from several widget tests to ensure they only depend on the library code they are testing. This involved replacing Material widgets with generic test implementations and moving Material-specific test cases to the appropriate Material test files.

# Unify text direction handling in InputDecorator and TextField/TextFormField

**Link**: [flutter#182477](https://github.com/flutter/flutter/pull/182477)

**Summary**: Adds a unified `textDirection` property to `InputDecoration` to ensure `labelText` and `hintText` resolve correctly in RTL scenarios. This change aligns `InputDecorator` behavior with `TextField` and `TextFormField`, eliminating the need for redundant layout configuration.

# [Web] Fix autofill in iOS 26 Safari

**Link**: [flutter#182024](https://github.com/flutter/flutter/pull/182024)

**Summary**: Resolves autofill issues on iOS 26 Safari by reusing existing autofill forms and fields instead of recreating them on every connection. It also implements a `refocus` mechanism to handle Safari's new behavior of blurring and then immediately re-focusing fields before performing an autofill.

# Remove Material Dependency from semantics_debugger_test

**Link**: [flutter#181722](https://github.com/flutter/flutter/pull/181722)

**Summary**: Refactors `semantics_debugger_test.dart` to eliminate its dependency on Material widgets. Material-specific components like `ElevatedButton`, `Slider`, and `Checkbox` were replaced with minimal test widgets (`TestButton`, `TestSlider`, `TestCheckbox`) that support the required semantic actions.

# Expose computeLineMetrics on RenderParagraph

**Link**: [flutter#181240](https://github.com/flutter/flutter/pull/181240)

**Summary**: Exposes the `computeLineMetrics()` method through `RenderParagraph`. This allow callers that only have access to the render object to retrieve line metrics without duplicating layout logic or accessing internal state.

# [iOS] Add Translate to iOS selection context menu

**Link**: [flutter#180021](https://github.com/flutter/flutter/pull/180021)

**Summary**: Adds a "Translate" action to the iOS selection context menu using the SwiftUI translation API introduced in iOS 18. This implementation includes support for both iPhone and iPad and handles the necessary embedding of SwiftUI components within the Flutter iOS embedder.

**Screenshot or video**:

https://github.com/user-attachments/assets/8c508f93-2341-498a-b494-c83fafa878f4
https://github.com/user-attachments/assets/61025f9c-f937-4043-bee5-ee31761cf5c0
https://github.com/user-attachments/assets/3a7e851f-c892-4b9f-b77d-e09588dec63f

# Fix text selection two handles directionality

**Link**: [flutter#179928](https://github.com/flutter/flutter/pull/179928)

**Summary**: Fixes an issue where text selection handles would point the wrong way when the text direction differed from the ambient application direction (e.g., selecting LTR text in an RTL app). Handle types are now determined based on the visual horizontal position of the endpoints rather than logical indices.

**Screenshot or video**:

https://github.com/user-attachments/assets/7de61b60-c1dd-44bb-a5c8-34ff5d451350
https://github.com/user-attachments/assets/bbe200c1-7733-41ad-9917-4d1982d273ff
https://github.com/user-attachments/assets/15d25ff7-47f3-439f-9efd-f82a4a890cbd

# [Android] Fix text selection handle alignment, cursor width updates, and Android handle auto-dismissal

**Link**: [flutter#178551](https://github.com/flutter/flutter/pull/178551)

**Summary**: Fixes a slight horizontal misalignment of text selection handles in input fields. It also ensures that updates to `cursorWidth` in `EditableText` reflect immediately and implements native Android behavior where selection handles automatically dismiss after 4 seconds of inactivity.

**Screenshot or video**:

https://github.com/user-attachments/assets/99d69ea0-9559-4b79-8402-aa7657dc47b9
https://github.com/user-attachments/assets/d89d6a99-f026-4e59-bb17-ad8950aea6f0

# Use glyph boundaries for horizontal character traversal

**Link**: [flutter#178258](https://github.com/flutter/flutter/pull/178258)

**Summary**: Implements horizontal caret traversal using actual glyph information from the text layout. This ensures correct arrow-key navigation in RTL text and complex scripts (such as Indic) where visual character boundaries may not align with underlying UTF-16 code units.

**Screenshot or video**:

https://github.com/user-attachments/assets/57296793-6fcd-4ae8-a835-35eb95572c62
https://github.com/user-attachments/assets/b00a55d4-ca21-4ab8-8681-5c095288223d

# Expose buttons accessor on Tap Details events

**Link**: [flutter#176968](https://github.com/flutter/flutter/pull/176968)

**Summary**: Exposes the `buttons` bitfield on `TapDownDetails`, `TapUpDetails`, and several other gesture detail classes to provide information about which pointer buttons were pressed. It also ensures that the device `kind` is consistently available across gesture detail objects.
