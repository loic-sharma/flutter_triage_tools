# Add option to count Unicode code points for TextField max-length validation

**Link**: [flutter#182907](https://github.com/flutter/flutter/issues/182907)

**Summary**: A request was made to allow `TextField` to enforce `maxLength` based on Unicode code points instead of the default grapheme clusters to match specific server-side validation requirements. The issue was closed as "not planned" because the same functionality can be achieved by composing existing features, specifically by using a custom `TextInputFormatter` for enforcement and the `buildCounter` property for the character count display.

# [Windows] External voice dictation tools cannot detect TextFields via UI Automation

**Link**: [flutter#182876](https://github.com/flutter/flutter/issues/182876)

**Summary**: External voice dictation and productivity tools on Windows are unable to detect or inject text into Flutter `TextField` widgets. This is attributed to two main issues: Flutter's Windows embedder does not properly expose UI Automation (UIA) text-editing patterns, and it still relies on the legacy IMM32 input framework rather than the modern Text Services Framework (TSF) required by most modern Windows input tools.

# [Windows] Shift key randomly gets stuck in a pressed down state when using TextFields

**Link**: [flutter#181907](https://github.com/flutter/flutter/issues/181907)

**Summary**: Users report that the Shift key occasionally becomes logically stuck in a "pressed" state within Flutter applications on Windows after performing text selection or switching window focus. This leads to several side effects, including involuntary text selection, mouse wheel scrolling becoming horizontal-only, and Tab navigation moving in reverse.

**Screenshot or video**:

https://github.com/user-attachments/assets/4c9dfa8b-b40f-49b8-96b3-99c4ea819377
