# [iOS] OTP autofill does not populate TextField

**Link**: [flutter#183501](https://github.com/flutter/flutter/issues/183501)

**Summary**: On iOS, tapping an OTP (One-Time Password) suggestion from the keyboard hint bar fails to populate the `TextField`. The issue has been reproduced on iOS 18.7.6 and iOS 26.3.1. Investigation indicates that the Flutter framework does not receive the `flutter/textinput` message when the suggestion is tapped, pointing to a potential bug in the iOS engine embedder.

**Screenshot or video**:

https://github.com/user-attachments/assets/2b2e4ab2-85cd-4ebd-bfe7-4f61372a24c8

https://github.com/user-attachments/assets/e40fe170-f46c-4374-87b4-135e27cae4bb

# [Android] Physical keyboard paste fails with TextInputType.none until software keyboard is shown

**Link**: [flutter#182941](https://github.com/flutter/flutter/issues/182941)

**Summary**: When using `TextInputType.none` on Android, pasting text from a physical keyboard (such as Ctrl+V or input from a barcode scanner) does not function until the software keyboard has been displayed at least once. This issue specifically affects hardware-based input methods on physical Android devices.

**Screenshot or video**:

https://github.com/user-attachments/assets/9274d92b-94a7-4454-8e32-d229854a0009

https://github.com/user-attachments/assets/8b5f0c5d-5e42-43a2-b794-6b31040f6d7a

https://github.com/user-attachments/assets/3dc6886e-4689-4d62-8ce1-31a8b6df02ad

https://github.com/user-attachments/assets/a5b82e8b-c2f1-4bbe-a722-d216824e2595
