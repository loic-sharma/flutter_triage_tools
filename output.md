# Add option to count Unicode code points for TextField max-length validation

**Issue ID**: [flutter#182907](https://github.com/flutter/flutter/issues/182907)

**Summary**: A proposal was made to allow `TextField` to count Unicode code points instead of grapheme clusters for its `maxLength` property to match certain server-side validation requirements. However, it was determined that this functionality can already be achieved using a custom `TextInputFormatter` for enforcement and the `buildCounter` property for the UI, leading to the issue being closed as not planned.

# [Windows] External voice dictation tools cannot detect TextFields via UI Automation

**Issue ID**: [flutter#182876](https://github.com/flutter/flutter/issues/182876)

**Summary**: External voice dictation and speech-to-text tools on Windows (like Typeless or Windows Voice Typing) are unable to locate or inject text into Flutter `TextField` widgets. The root causes are identified as Flutter not properly exposing UIA text-editing patterns and its continued use of the legacy IMM32 framework instead of the modern Text Services Framework (TSF).

# [Windows] Shift key randomly gets stuck in a pressed down state when using TextFields

**Issue ID**: [flutter#181907](https://github.com/flutter/flutter/issues/181907)

**Summary**: On Windows, the Shift key can become logically stuck in a "pressed down" state after certain interactions with a `TextField`, such as combined keyboard and mouse usage or switching window focus. This results in unintended text selection, broken vertical scrolling, and reversed Tab key navigation, requiring an app restart to clear.

**Screenshot or video**: https://github.com/user-attachments/assets/4c9dfa8b-b40f-49b8-96b3-99c4ea819377
