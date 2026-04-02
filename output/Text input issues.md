# [Mobile] Toggling TextField.obscureText can show the last character

**Link**: [flutter#184483](https://github.com/flutter/flutter/issues/184483)

**Summary**: When `TextField.obscureText` is toggled quickly on a mobile device, the most recently entered character is briefly visible instead of remaining obscured. This occurs when transitioning the state from true to false and back to true in rapid succession.

**Screenshot or video**:

https://github.com/user-attachments/assets/992e0473-059c-4c7a-a1b1-8ca6bf222538

# Vertical baseline alignment mismatch between Text and collapsed TextField

**Link**: [flutter#184240](https://github.com/flutter/flutter/issues/184240)

**Summary**: There is a vertical baseline alignment mismatch between a `Text` widget and a collapsed `TextField` even when they share the same font style. The `TextField` shifts vertically depending on the `TextLeadingDistribution` (even vs. proportional), causing it to align incorrectly with adjacent text.

**Screenshot or video**:

https://github.com/user-attachments/assets/7754e4dc-24ba-4ee1-9ab6-de4347c6ddce
