# [Web] Korean IME composing range assertion failure after window blur

**Link**: [flutter#183078](https://github.com/flutter/flutter/issues/183078)

**Summary**: Switching windows (Cmd+Tab) while composing a Korean character causes an assertion failure (`googValue.googcomposing.end <= googValue.text.length`) when the user returns and presses Backspace. The browser's `compositionend` event fires on blur, but Flutter fails to sync its internal composing range, leading to a state where the composing range exceeds the actual text length.

# [Windows] External voice dictation tools cannot detect Flutter TextFields via UI Automation

**Link**: [flutter#182876](https://github.com/flutter/flutter/issues/182876)

**Summary**: Voice dictation and automation tools (e.g., Typeless, Windows Voice Typing) are unable to detect or inject text into Flutter `TextField` widgets. This is due to the Windows embedder not properly exposing UIA text-editing patterns and its continued reliance on the legacy IMM32 framework instead of the modern Text Services Framework (TSF) required for speech and handwriting input.

# [Windows] Shift key randomly gets stuck in a pressed state when using TextFields

**Link**: [flutter#181907](https://github.com/flutter/flutter/issues/181907)

**Summary**: On Windows, the Shift key occasionally becomes logically stuck in a "pressed down" state after interacting with a `TextField` (e.g., selecting text or switching focus). This results in unintended side effects like automatic text selection, reversed Tab navigation, and horizontal-only scrolling that persist until the application is restarted.

**Screenshot or video**:

https://github.com/user-attachments/assets/4c9dfa8b-b40f-49b8-96b3-99c4ea819377
