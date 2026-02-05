# Don't duplicate semantics logic in TextField and CupertinoTextField

**Issue ID**: [flutter#181873](https://github.com/flutter/flutter/issues/181873)

**Summary**: This issue proposes moving common semantics logic for gestures and focus from the design-specific `TextField` and `CupertinoTextField` widgets into the underlying `EditableText` widget. This change aims to reduce code duplication and ensure that developers using `EditableText` directly can easily implement correct semantics.

# [iOS] Add a Cupertino version of SelectableText

**Issue ID**: [flutter#181682](https://github.com/flutter/flutter/issues/181682)

**Summary**: Currently, there is no Cupertino-styled equivalent to the `SelectableText` widget. This has led to cross-imports of Material libraries in Cupertino tests. Adding a `CupertinoSelectableText` widget would resolve these testing issues and provide a native-looking selectable text option for iOS-styled applications.

# WidgetSpan is not correctly aligned with TextSpans in Text.rich during line wraps

**Issue ID**: [flutter#181532](https://github.com/flutter/flutter/issues/181532)

**Summary**: When using `Text.rich` with a combination of `TextSpan` and `WidgetSpan`, the widget span does not always align correctly with the surrounding text during line wraps. The `WidgetSpan` behaves as a single atomic rectangle, which can result in unexpected line breaks and gaps when the text container is resized.

# [iOS] TextField remains focused after keyboard dismissal on iPadOS, preventing keyboard from reappearing

**Issue ID**: [flutter#181474](https://github.com/flutter/flutter/issues/181474)

**Summary**: On iPadOS, when using a numeric keyboard, dismissing the "floating" keypad by tapping outside does not always unfocus the `TextField`. Because the field remains focused, subsequent taps on it fail to trigger the keyboard again, requiring the user to manually unfocus and refocus the field to bring back the input method.

# [Android] View inset discontinuity causes a jump at the end of keyboard animations

**Issue ID**: [flutter#180484](https://github.com/flutter/flutter/issues/180484)

**Summary**: On certain Android devices, opening the software keyboard results in a visual "jump" at the end of the animation. This is caused by a discontinuity in the `MediaQuery.viewInsetOf(context).bottom` value, which appears to jump by a value related to the height of the home indicator once the keyboard is fully shown.

# [iOS] Emoji selection highlight height is inconsistent with alphanumeric characters

**Issue ID**: [flutter#137817](https://github.com/flutter/flutter/issues/137817)

**Summary**: On iOS, the text selection highlight for emojis is taller than the highlight for standard English characters, creating an uneven visual appearance. While `selectionHeightStyle` can be adjusted for `TextField` or `SelectableText`, this issue also affects `SelectionArea` where these styles are not yet configurable.
