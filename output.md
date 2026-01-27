# Nested SelectionArea displays parent context menu

**Issue ID**: [flutter#181231](https://github.com/flutter/flutter/issues/181231)

**Summary**:
Right-clicking within a nested `SelectionArea` sometimes triggers the context menu of the parent `SelectionArea` instead of the child. This behavior persists even when the nested `SelectionArea` is wrapped in `SelectionContainer.disabled`, indicating an issue with how the framework identifies the target selection container for the context menu.

# [Android] Bottom view inset jumps during keyboard animation

**Issue ID**: [flutter#180484](https://github.com/flutter/flutter/issues/180484)

**Summary**:
On Android 15, `MediaQuery.viewInsetOf(context).bottom` values exhibit a discontinuity at the end of the keyboard opening animation. This results in a visible jump in the UI that appears to be related to the height of the system home indicator, whereas native Android implementations animate smoothly.

# Action.overridable fails when using DoNothingAction as an override

**Issue ID**: [flutter#180435](https://github.com/flutter/flutter/issues/180435)

**Summary**:
`Action.overridable` does not correctly support `DoNothingAction` because it strictly validates that the override action's intent type matches the default action's intent. Since `DoNothingAction` is intended to handle any `Intent`, it fails this type check and triggers an assertion error when used to override overridable actions.

# [iOS] Semi-transparent keyboard reveals empty area under resized widgets

**Issue ID**: [flutter#179482](https://github.com/flutter/flutter/issues/179482)

**Summary**:
The semi-transparent keyboard on iOS 26 reveals that widgets like `Scaffold` and `BottomSheet` do not draw content in the area they vacate to avoid the bottom inset. This results in a black background being visible through the keyboard, requiring a change in how framework widgets handle view insets to ensure content is drawn behind the keyboard.
