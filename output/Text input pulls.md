# [Android] Remove unused variable in ProcessTextPlugin.java

**Link**: [flutter#184161](https://github.com/flutter/flutter/pull/184161)

**Summary**: This pull request removes an unused variable in the Android engine's `ProcessTextPlugin.java` file.

# Remove hitTestable so hint will not be ignored in TextContrastGuideline

**Link**: [flutter#184158](https://github.com/flutter/flutter/pull/184158)

**Summary**: This fix addresses an issue where `TextField` hints were ignored by the `MinimumTextContrastGuideline`. It removes the use of `.hitTestable()` in the contrast algorithm to decouple visual visibility from touch hit-testing, ensuring that hints are correctly evaluated even when layered beneath the text editor.

# Update golden images to 26.4

**Link**: [flutter#184143](https://github.com/flutter/flutter/pull/184143)

**Summary**: This pull request updates the project's golden images to version 26.4.

# Sixth group of tests for zero-area crashes in transitions

**Link**: [flutter#184049](https://github.com/flutter/flutter/pull/184049)

**Summary**: This PR adds a series of tests to ensure that various transition widgets, such as `RotationTransition`, `SizeTransition`, and `FadeTransition`, do not crash when rendered with a zero area.

# Add awaits to benchmark tap gestures

**Link**: [flutter#184042](https://github.com/flutter/flutter/pull/184042)

**Summary**: Part of a larger refactoring effort, this PR adds `await` keywords to tap gestures in benchmarks to ensure that the gestures are fully processed before the benchmark proceeds, reducing potential flakiness.

# [iOS] Migrate Cupertino API examples to use dot shorthands

**Link**: [flutter#183964](https://github.com/flutter/flutter/pull/183964)

**Summary**: This pull request migrates Cupertino API examples to use the "dot shorthand" style (e.g., using `.circular` instead of `Radius.circular`) to reduce redundant information and align with the updated Flutter style guide.

# [Web] Implement image support for wimp in Impeller

**Link**: [flutter#183913](https://github.com/flutter/flutter/pull/183913)

**Summary**: This PR implements image support for the "wimp" renderer in the Web engine's Impeller implementation. It introduces a texture cache and allows images to lazily create textures on the raster thread, enabling the use of external textures and pixels in wimp.

# [Web] Unify CanvasKit and Skwasm garbage collection

**Link**: [flutter#183867](https://github.com/flutter/flutter/pull/183867)

**Summary**: This pull request introduces a shared memory management system for both the CanvasKit and Skwasm renderers. It replaces renderer-specific finalization logic with a consistent, reference-counted approach for native resources like images and pictures.

# [iOS] Skip interactive keyboard tests for iOS 26+

**Link**: [flutter#183757](https://github.com/flutter/flutter/pull/183757)

**Summary**: This PR skips interactive keyboard tests that are no longer applicable to iOS version 26 and above.

# Use Material.of(context) to clean up Material tests

**Link**: [flutter#183698](https://github.com/flutter/flutter/pull/183698)

**Summary**: This cleanup PR refactors Material tests to use `Material.of(context)` for retrieving ink features, moving away from manual `RenderObject` lookups as part of a larger effort to decouple Material ink controllers.

# [iOS] Add opt-in inline prediction text input support

**Link**: [flutter#183650](https://github.com/flutter/flutter/pull/183650)

**Summary**: This pull request exposes a new `enableInlinePrediction` configuration for text fields on iOS 17+. This allows apps to opt into native iOS inline predictive text, with the engine now correctly handling the attributed marked text flow required for this feature.

# Fix selection highlight artifacts for faded selectable text

**Link**: [flutter#183628](https://github.com/flutter/flutter/pull/183628)

**Summary**: This fix separates the painting of selection highlights from the text layer when `TextOverflow.fade` is used. Previously, the selection highlights were being affected by the fade shader, resulting in dark border artifacts during selection.

**Screenshot or video**:

https://github.com/user-attachments/assets/22c3c8a1-3d17-40f3-8b77-fc48e9e91a25

https://github.com/user-attachments/assets/dbca31d9-edb0-4dea-a617-0bf8c2b809a8

# [iOS] Keep multiline CupertinoTextField placeholders in bounds

**Link**: [flutter#183622](https://github.com/flutter/flutter/pull/183622)

**Summary**: This PR fixes a layout regression in `CupertinoTextField` where multiline placeholders could be positioned partially outside the text field's bounds. The fix ensures the entire group of placeholder and editable text is correctly vertically aligned within the field.

# Prevent last character visibility when toggling obscureText

**Link**: [flutter#183488](https://github.com/flutter/flutter/pull/183488)

**Summary**: This fix prevents a bug where the most recently entered character remains visible if `obscureText` is quickly toggled from true to false and back to true. All characters are now immediately obscured when the property is set to true.

**Screenshot or video**:

https://github.com/user-attachments/assets/94d2ba56-c551-4385-8f88-3dd746c8dc09

https://github.com/user-attachments/assets/992e0473-059c-4c7a-a1b1-8ca6bf222538

# [iOS] Reland platform view hitTest approach

**Link**: [flutter#183484](https://github.com/flutter/flutter/pull/183484)

**Summary**: This PR relands a hit-testing mechanism for iOS platform views. It allows the framework to explicitly instruct the engine whether a platform view should accept a touch at a given location, fixing issues where gestures could fall through native views unexpectedly.

# Remove Material imports from various widget tests

**Link**: [flutter#183309](https://github.com/flutter/flutter/pull/183309)

**Summary**: This refactoring PR removes Material library dependencies from several core widget tests (such as `Container`, `PageView`, and `Text`), moving toward a more design-system agnostic testing infrastructure for the widgets library.

# [Web] [Desktop] Fix SelectableText right-click behavior

**Link**: [flutter#183110](https://github.com/flutter/flutter/pull/183110)

**Summary**: This PR updates `SelectableText` to match native behavior on macOS and Web, where a right-click selects the word at the click position. It also ensures the selection toolbar is correctly displayed when text is already selected.

# Add awaits or ignores to invokeMethod callsites

**Link**: [flutter#182870](https://github.com/flutter/flutter/pull/182870)

**Summary**: This pull request addresses `unawaited_futures` lints across the codebase by adding `await` to `invokeMethod` calls or using `ignore` comments where awaiting would change established public API signatures.

# Respect per-field autovalidateMode priority

**Link**: [flutter#182752](https://github.com/flutter/flutter/pull/182752)

**Summary**: This PR implements hierarchical validation logic for forms, ensuring that a `FormField`'s specific `autovalidateMode` takes precedence over the global `Form` setting. It also fixes an issue where `onUserInteraction` validation could be triggered without actual user interaction.

# Add textDirection handling in InputDecorator

**Link**: [flutter#182477](https://github.com/flutter/flutter/pull/182477)

**Summary**: This PR introduces a `textDirection` property to `InputDecoration`, allowing label and hint text to resolve correctly in RTL layouts. This centralizes text direction behavior and reduces the need for redundant manual configuration.

# [macOS] Implement popup windows

**Link**: [flutter#182371](https://github.com/flutter/flutter/pull/182371)

**Summary**: This PR implements support for native-style popup windows on macOS. It includes a new `PopupWindowController` and an anchor-tracking mechanism to ensure that popups correctly track their parent element even during window resizing.

# [Web] Fix autofill in iOS 26 Safari

**Link**: [flutter#182024](https://github.com/flutter/flutter/pull/182024)

**Summary**: This fix addresses autofill issues in Safari on iOS 26 by reusing autofill forms and re-establishing the text input connection when the browser refocuses a field. This accounts for the new blur-then-focus behavior introduced in iOS 26.

# Fix text selection handle directionality in mixed-directionality text

**Link**: [flutter#179928](https://github.com/flutter/flutter/pull/179928)

**Summary**: This fix ensures that text selection handles always correctly "hug" the selection, even when the text direction differs from the ambient application direction. Handle types are now determined by the visual horizontal position of the endpoints rather than just the logical selection range.

**Screenshot or video**:

https://github.com/user-attachments/assets/7de61b60-c1dd-44bb-a5c8-34ff5d451350

# [macOS] Run macOS tests using Xcode 26 and iOS 26 simulator

**Link**: [flutter#179810](https://github.com/flutter/flutter/pull/179810)

**Summary**: This PR updates the CI configuration to run all macOS-hosted tests using Xcode 26 and the iOS 26 simulator.

# [Android] Fix selection handle alignment and implement auto-dismissal

**Link**: [flutter#178551](https://github.com/flutter/flutter/pull/178551)

**Summary**: This PR fixes a misalignment of the selection handle in `InputField`, ensures that `cursorWidth` changes are reflected immediately, and implements native-like auto-dismissal of handles on Android after 4 seconds of inactivity.

**Screenshot or video**:

https://github.com/user-attachments/assets/99d69ea0-9559-4b79-8402-aa7657dc47b9

https://github.com/user-attachments/assets/d89d6a99-f026-4e59-bb17-ad8950aea6f0

# Use glyph boundaries for horizontal character traversal

**Link**: [flutter#178258](https://github.com/flutter/flutter/pull/178258)

**Summary**: This PR implements horizontal character traversal using actual glyph information from the text layout. This allows for correct caret movement through RTL text and complex scripts (like Indic) where Shaping is required, rather than relying on underlying character offsets.

**Screenshot or video**:

https://github.com/user-attachments/assets/57296793-6fcd-4ae8-a835-35eb95572c62

https://github.com/user-attachments/assets/b00a55d4-ca21-4ab8-8681-5c095288223d
