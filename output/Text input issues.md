# [Android][iOS] Unify Talkback and VoiceOver TextField announcements

**Link**: [flutter#183808](https://github.com/flutter/flutter/issues/183808)

**Summary**: Talkback on Android and VoiceOver on iOS announce `TextField` labels and hints in different orders. Talkback appends both to the end of the announcement, while VoiceOver announces the label first and the hint last. This inconsistency makes it difficult to provide a uniform accessibility experience, and the issue proposes giving developers control over the announcement order.

# [iOS] NSJSONSerialization crash when deleting SMP characters

**Link**: [flutter#183571](https://github.com/flutter/flutter/issues/183571)

**Summary**: A crash occurs on iOS when deleting Supplementary Multilingual Plane (SMP) characters, such as certain emojis, from a `TextField`. The deletion process can leave orphaned UTF-16 surrogates in the underlying string, which causes `NSJSONSerialization` to fail and crash the app when attempting to communicate with the engine. A proposed fix involves sanitizing the JSON by removing lone surrogates before serialization.

# [iOS] TextField OTP autofill not working correctly

**Link**: [flutter#183501](https://github.com/flutter/flutter/issues/183501)

**Summary**: On some iOS devices (specifically reported on an iPhone XS), tapping the one-time code (OTP) hint above the keyboard fails to populate the focused `TextField`. Interestingly, the autofill works correctly if the user presses the backspace key before tapping the code hint. The issue appears to be intermittent or hardware-specific, as it could not be reproduced on newer iPhone models.

**Screenshot or video**:

https://github.com/user-attachments/assets/2b2e4ab2-85cd-4ebd-bfe7-4f61372a24c8

https://github.com/user-attachments/assets/e40fe170-f46c-4374-87b4-135e27cae4bb

# Autocomplete blocks keyboard navigation using TAB

**Link**: [flutter#183456](https://github.com/flutter/flutter/issues/183456)

**Summary**: Keyboard navigation using the TAB key is interrupted when using the `Autocomplete` widget if the next focusable widget in the sequence is disabled. Instead of skipping the disabled widget and moving to the next enabled one, the focus remains trapped within the `Autocomplete` field.

**Screenshot or video**:

https://github.com/user-attachments/assets/f382e6e4-fbc2-44ce-ae98-8f2ebd47e5d0

https://github.com/user-attachments/assets/09a51a73-6bb0-4a57-b6f0-0a16a57b4eec

# [Android] WebView input fails to scroll into visible area on focus

**Link**: [flutter#183392](https://github.com/flutter/flutter/issues/183392)

**Summary**: In `webview_flutter` on Android, focusing an HTML input element at the bottom of a page does not automatically scroll it into view above the keyboard. This differs from the iOS implementation, where the input is correctly scrolled. The issue is particularly prominent when `resizeToAvoidBottomInset` is set to false, though partial obstruction still occurs when it is enabled.

**Screenshot or video**:

https://github.com/user-attachments/assets/81f0b8bc-c816-4eae-ba98-d93c66629fa1

https://github.com/user-attachments/assets/9e760f6e-ef0b-45b7-bab8-c13abbb83308

https://github.com/user-attachments/assets/854f52d8-5901-490e-aa8c-faca45c31239

# [Android] Physical keyboard paste fails with TextInputType.none

**Link**: [flutter#182941](https://github.com/flutter/flutter/issues/182941)

**Summary**: When a `TextField` is configured with `TextInputType.none` on Android, pasting text (Ctrl+V) from a physical keyboard or barcode scanner does not work initially. The "paste" action only begins to function after the software keyboard has been displayed and dismissed at least once. This affects specialized hardware like integrated barcode scanners that rely on physical keyboard events.

**Screenshot or video**:

https://github.com/user-attachments/assets/9274d92b-94a7-4454-8e32-d229854a0009

https://github.com/user-attachments/assets/8b5f0c5d-5e42-43a2-b794-6b31040f6d7a

https://github.com/user-attachments/assets/3dc6886e-4689-4d62-8ce1-31a8b6df02ad

https://github.com/user-attachments/assets/a5b82e8b-c2f1-4bbe-a722-d216824e2595

# [Android] Scroll jumps when dragging selection handle upwards

**Link**: [flutter#143479](https://github.com/flutter/flutter/issues/143479)

**Summary**: When selecting text in a long `TextField` on Android, dragging the start selection handle upwards causes the scroll position to "flicker" or jump. This happens because the framework attempts to keep the end of the selection in view while the user is actively moving the start handle. Developers suggest that the framework should skip auto-scrolling to the selection end when a handle drag is in progress.

**Screenshot or video**:

https://github.com/flutter/flutter/assets/77847606/704d9131-594d-444b-b7ec-25fd65bb8d19
