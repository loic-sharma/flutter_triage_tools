# Proposal to allow counting Unicode code points for TextField max-length validation

**Issue ID**: [flutter#182907](https://github.com/flutter/flutter/issues/182907)

**Summary**: A proposal to add an option to `TextField` that allows `maxLength` to be interpreted as Unicode code points instead of the default grapheme clusters. The issue was closed as "not planned" because the desired behavior can be achieved through composition using a custom `TextInputFormatter` and the `buildCounter` property.

# [Windows] External voice dictation tools cannot detect TextFields

**Issue ID**: [flutter#182876](https://github.com/flutter/flutter/issues/182876)

**Summary**: External voice dictation and accessibility tools on Windows are unable to locate or inject text into Flutter `TextField` widgets. This failure is attributed to Flutter's incomplete exposure of UI Automation (UIA) patterns and its continued reliance on the legacy IMM32 framework rather than the modern Text Services Framework (TSF).

# [Windows] Shift key randomly gets stuck in a "pressed down" state

**Issue ID**: [flutter#181907](https://github.com/flutter/flutter/issues/181907)

**Summary**: When using `TextField`s on Windows, the Shift key can become logically stuck in a "pressed down" state. This bug leads to persistent unintended text selection, forces horizontal-only scrolling, and reverses the direction of focus navigation, requiring an application restart to resolve.
