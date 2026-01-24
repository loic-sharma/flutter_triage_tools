# Incorrect context menu with nested SelectionArea

**Issue ID**: [flutter#181231](https://github.com/flutter/flutter/issues/181231)

**Summary**: When `SelectionArea` widgets are nested, right-clicking the inner
`SelectionArea` can incorrectly trigger the context menu of the outer
`SelectionArea`. The expected behavior is for the context menu of the most
specific, nested `SelectionArea` to be shown.

# [Android] Stutter in viewInsets animation when keyboard opens

**Issue ID**: [flutter#180484](https://github.com/flutter/flutter/issues/180484)

**Summary**: On Android, the animation for `MediaQuery.viewInsets.bottom` is not
smooth when the on-screen keyboard appears. This causes a visual "jump" for
widgets that are positioned relative to the keyboard, unlike the smooth
animation seen in native Android apps.

# Action.overridable cannot be overridden by DoNothingAction

**Issue ID**: [flutter#180435](https://github.com/flutter/flutter/issues/180435)

**Summary**: Using `DoNothingAction` to override an `Action.overridable` fails
with an assertion because of a strict type check that doesn't account for
`DoNothingAction`'s generic nature. A related issue prevents certain text
selection intents from being overridden individually because they share the same
underlying action instance in the framework.

# [iOS] Semi-transparent keyboard reveals empty space

**Issue ID**: [flutter#179482](https://github.com/flutter/flutter/issues/179482)

**Summary**: On recent iOS versions, the new semi-transparent keyboard reveals
an empty black area behind it when widgets like `BottomSheet` resize to avoid
the keyboard. This happens because the widgets shift up, leaving no content to
be seen through the keyboard's transparent parts. A temporary workaround
involves opting out of the new iOS design features via an `Info.plist` key.
