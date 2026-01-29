# [Windows] TextField cannot completely disable system IME

**Issue ID**: [flutter#181487](https://github.com/flutter/flutter/issues/181487)

**Summary**: Flutter's `TextField` lacks a mechanism to completely prevent Input Method Editor (IME) activation. This is particularly problematic in CJK language environments where IMEs automatically engage, disrupting fields that require direct keyboard input only, such as OTP/PIN entry or terminals.

# [iPadOS] Keyboard fails to reappear after tapping TextField while it still has focus

**Issue ID**: [flutter#181474](https://github.com/flutter/flutter/issues/181474)

**Summary**: On iPadOS 26.2, when a `TextField` with a numeric keyboard is dismissed by tapping outside, the widget incorrectly retains focus. Because the framework believes the field is still focused, subsequent taps on the `TextField` fail to re-trigger the keyboard presentation.

# Incorrect context menu displayed when SelectionArea is nested

**Issue ID**: [flutter#181231](https://github.com/flutter/flutter/issues/181231)

**Summary**: When `SelectionArea` widgets are nested, right-clicking within the inner area occasionally triggers the context menu of the parent `SelectionArea` instead of the child. The issue persists even when attempting to disable the nested container via `SelectionContainer.disabled`.

# [Android] MediaQuery viewInset bottom discontinuity when opening keyboard

**Issue ID**: [flutter#180484](https://github.com/flutter/flutter/issues/180484)

**Summary**: Flutter apps on Android exhibit a visible "jump" at the end of the keyboard opening animation. This is caused by a discontinuity in `MediaQuery.viewInsetOf(context).bottom` values, where the inset abruptly shifts (e.g., a 24-point jump) at the conclusion of the animation, possibly related to the system home indicator's height.

# Action.overridable cannot be overridden by a DoNothingAction

**Issue ID**: [flutter#180435](https://github.com/flutter/flutter/issues/180435)

**Summary**: `Action.overridable` fails to work correctly when the intended override is a `DoNothingAction`. The framework's internal type check expects the override action's `Intent` type to match the default action's specific `Intent` type; however, `DoNothingAction` does not satisfy this check despite its documentation stating it should bind to any intent.

# [iOS] Semi-transparent keyboard reveals widgets not drawing under it on iOS 26

**Issue ID**: [flutter#179482](https://github.com/flutter/flutter/issues/179482)

**Summary**: On iOS 26, the semi-transparent "Liquid Glass" keyboard reveals the black modal barrier or empty space instead of app content. This occurs because Flutter widgets like `Scaffold` and `BottomSheet` typically resize to avoid the `viewInsets` created by the keyboard rather than drawing behind the keyboard's translucent area.

# [Android] Keyboard auto-hides after first character when autofillHints is enabled

**Issue ID**: [flutter#159670](https://github.com/flutter/flutter/issues/159670)

**Summary**: When `autofillHints` are enabled on Android, specific third-party input methods (such as Sogou and WeChat) cause the keyboard to automatically hide immediately after the user types the first character. This behavior appears to be Flutter-specific, as it does not occur in native Android applications using the same input methods.
