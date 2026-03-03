# [Android] Fix emoji insertion corruption by using grapheme-aware text operations

**Link**: [flutter#183112](https://github.com/flutter/flutter/pull/183112)

**Summary**: Fixes a bug on Android where inserting emojis into existing emoji text in an RTL `TextField` would break the text and render `?` characters. The fix ensures `TextEditingValue` uses grapheme cluster boundaries instead of raw UTF-16 code unit positions to avoid splitting surrogate pairs.

**Screenshot or video**:
* [Before fix](https://github.com/user-attachments/assets/701c78cb-f2c0-4cec-91fc-455f9490a6c3)
* [After fix](https://github.com/user-attachments/assets/409cfbd2-ecae-4368-b508-fe674f43f8a2)

# [Web/macOS] Prevent SelectableText right-click from selecting words

**Link**: [flutter#183110](https://github.com/flutter/flutter/pull/183110)

**Summary**: Fixes an issue on macOS and web where right-clicking `SelectableText` would incorrectly select the word at the click position. Since `SelectableText` is read-only, right-clicking now only shows the context menu if text is already selected, without triggering new selections.

# Replace BorderRadius.circular with const BorderRadius.all and update documentation examples

**Link**: [flutter#183074](https://github.com/flutter/flutter/pull/183074)

**Summary**: Replaces usages of `BorderRadius.circular` with `const BorderRadius.all(Radius.circular(...))` to improve code consistency and enable more `const` constructors. Documentation examples were also updated to promote this recommended style.

# [Impeller] Update comments to reflect new info about 2-pass rendering

**Link**: [flutter#183050](https://github.com/flutter/flutter/pull/183050)

**Summary**: Updates internal documentation and comments within the Impeller engine to reflect recent discoveries regarding the 2-pass rendering system and glyph caching. It also cleans up an obsolete method declaration and reorganizes internal structures for better clarity.

# TextField: add code-point mode for maxLength counting

**Link**: [flutter#182920](https://github.com/flutter/flutter/pull/182920)

**Summary**: Introduces `MaxLengthCountType` to `TextField`, allowing length limits to be enforced based on Unicode code points instead of the default grapheme clusters. This helps applications align client-side validation with backend systems that use code-point-based constraints.

# Add await or ignore lint to invokeMethod callsites

**Link**: [flutter#182870](https://github.com/flutter/flutter/pull/182870)

**Summary**: Addresses `unawaited_futures` lint warnings for platform channel `invokeMethod` calls. The changes include adding `await` where appropriate, using `// ignore` for intentional unawaited calls, and ensuring errors are properly reported to `FlutterError` via `.catchError`.

# Respect per-field autovalidateMode priority

**Link**: [flutter#182752](https://github.com/flutter/flutter/pull/182752)

**Summary**: Implements hierarchical validation logic where `FormField.autovalidateMode` takes precedence over the parent `Form` settings. If the field's mode is unspecified, it inherits the form's configuration, falling back to disabled by default.

# [iOS] Enable and style inline text prediction

**Link**: [flutter#182728](https://github.com/flutter/flutter/pull/182728)

**Summary**: Adds support for iOS 17+ inline predictive text (gray suggestions following the cursor). It introduces `enableInlinePrediction` to toggle the feature and `composingStyle` to allow developers to customize the appearance of uncommitted predictive text to match native iOS aesthetics.

# Remove material from core widget and inspector tests

**Link**: [flutter#182702](https://github.com/flutter/flutter/pull/182702)

**Summary**: Refactors several framework tests to remove dependencies on the Material library. This ensures that tests for core components like `Scrollable`, `Sliver`, and the `WidgetInspector` only depend on the library code they are specifically testing.

# Unify text direction handling in InputDecorator and TextField/TextFormField

**Link**: [flutter#182477](https://github.com/flutter/flutter/pull/182477)

**Summary**: Adds a unified `textDirection` property to `InputDecoration` to ensure that labels and hint text are resolved correctly in RTL scenarios. This aligns the decoration's behavior with the parent `TextField` or `TextFormField` to prevent redundant configuration.

# [Web/iOS] Fix form autofill in Safari on iOS 26

**Link**: [flutter#182024](https://github.com/flutter/flutter/pull/182024)

**Summary**: Fixes two issues with web autofill in Safari: it reuses existing DOM forms to prevent Safari from breaking the autofill sequence and adds a `refocus` mechanism to handle Safari's new focus-blur-focus behavior during autofill events.

# Remove Material dependency from semantics_debugger_test

**Link**: [flutter#181722](https://github.com/flutter/flutter/pull/181722)

**Summary**: Refactors `semantics_debugger_test.dart` to eliminate its dependency on the Material library. It introduces minimal test widgets (like `TestSlider` and `TestCheckbox`) that support the required semantics actions without pulling in Material widgets.

# Expose computeLineMetrics on RenderParagraph

**Link**: [flutter#181240](https://github.com/flutter/flutter/pull/181240)

**Summary**: Exposes the `computeLineMetrics` method on `RenderParagraph`, allowing callers with a reference to the render object to retrieve detailed line information without needing direct access to the internal `TextPainter`.

# [iOS] Add Translate to iOS selection context menu

**Link**: [flutter#180021](https://github.com/flutter/flutter/pull/180021)

**Summary**: Integrates the native iOS system translation API into the selection context menu for iOS 17.4+. Users can now select text in Flutter apps and trigger the native system translation overlay.

**Screenshot or video**:
https://github.com/user-attachments/assets/8c508f93-2341-498a-b494-c83fafa878f4

# Fix text selection handle directionality for mixed-directionality text

**Link**: [flutter#179928](https://github.com/flutter/flutter/pull/179928)

**Summary**: Fixes an issue where text selection handles would face the wrong direction when selecting LTR text within an RTL application (or vice versa). Handles are now assigned based on their visual horizontal position to ensure they always correctly "hug" the selection.

**Screenshot or video**:
https://github.com/user-attachments/assets/7de61b60-c1dd-44bb-a5c8-34ff5d451350

# [Android] Fix selection handle alignment and implement auto-dismissal

**Link**: [flutter#178551](https://github.com/flutter/flutter/pull/178551)

**Summary**: Corrects a misalignment where selection handles were slightly offset from the cursor and ensures they rebuild when `cursorWidth` changes. It also implements native Android behavior where selection handles automatically dismiss after 4 seconds of inactivity.

**Screenshot or video**:
[Handle alignment fix](https://github.com/user-attachments/assets/d89d6a99-f026-4e59-bb17-ad8950aea6f0)

# Use glyph boundaries for horizontal character traversal

**Link**: [flutter#178258](https://github.com/flutter/flutter/pull/178258)

**Summary**: Implements horizontal caret movement (arrow keys) using actual glyph information from the text layout rather than logical character positions. This ensures correct traversal in RTL text and complex scripts (like Indic) where multiple characters form a single visual cluster.

**Screenshot or video**:
[Glyph-based traversal behavior](https://github.com/user-attachments/assets/b00a55d4-ca21-4ab8-8681-5c095288223d)

# Expose buttons accessor on Tap Details events

**Link**: [flutter#176968](https://github.com/flutter/flutter/pull/176968)

**Summary**: Adds a `buttons` field to `TapDownDetails` and `TapUpDetails` to identify which mouse buttons were pressed during a tap. It also exposes the `kind` of pointer device (mouse, touch, stylus) across various gesture detail classes.
