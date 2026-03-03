<instructions>
Summarize each of the following GitHub issues.

Suggest a title for each, in sentence case. If the issue is specific to a
platform, prefix the title with the platform name, e.g. "[Android]" or "[iOS]".
If the issue has a screenshot or video, include a link to it.
</instructions>

<example_output>

# [Android] Backspace is not sent to TextField

**Issue ID**: [flutter#123](https://github.com/flutter/flutter/issues/123)

**Summary**: When Backspace is pressed on a virtual keyboard of certain Samsung
devices, the keypress is not sent to the TextField. This appears to be a bug in
`_HighlightModeManager`: it assumes all `KeyMessage`s are physical key presses,
however, Android's backspace virtual key can send a `KeyMessage`.

**Screenshot or video**: https://github.com/user-attachments/assets/abcdef

</example_output>

<collection>
  <issue id="182907">
    <title>Proposal - TextField for max-length validation, add option to count Unicode code points instead of grapheme clusters</title>
    <body>
### Use case

In Zulip, we sometimes want to send a user-provided string to the server, and the server validates the string by counting its Unicode code points. See for example "max_stream_name_length:" in [this Zulip API doc](https://zulip.com/api/register-queue):

> The maximum allowed length for a channel name, in Unicode code points. Clients should use this property rather than hardcoding field sizes.

We'd like a simple way to validate the string client-side before passing it to the server.


### Proposal

The [`TextField` widget](https://api.flutter.dev/flutter/material/TextField-class.html) has params [`maxLength`](https://api.flutter.dev/flutter/material/TextField/maxLength.html) and [`maxLengthEnforcement`](https://api.flutter.dev/flutter/material/TextField/maxLengthEnforcement.html). Those work by counting Unicode _grapheme clusters_, not code points, so if we want to perfectly match the client-side validation/enforcement to the server, we can't use those.

I propose adding another optional param to `TextField` that configures whether `maxLength` is interpreted as grapheme clusters, which will remain the default behavior, or as code points.
    </body>
    <comments>
      <comment author="loic-sharma">
@chrisbobbe Did you consider making a custom text input formatter (see [`TextInputFormatter`](https://api.flutter.dev/flutter/services/TextInputFormatter-class.html))?

Here's a prototype by Gemini:

```dart
import 'package:flutter/services.dart';

class CodePointLengthLimitingFormatter extends TextInputFormatter {
  const CodePointLengthLimitingFormatter({required this.maxCodePoints});

  final int maxCodePoints;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Runes represent the Unicode code points of the string
    if (newValue.text.runes.length > maxCodePoints) {
      // If we exceed the limit, we revert to the old value
      // or truncate the new one. Reverting is safer for cursor position.
      return oldValue;
    }
    return newValue;
  }
}
```

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Enter up to 5 code points',
    hintText: 'Try emojis!',
  ),
  inputFormatters: [
    CodePointLengthLimitingFormatter(maxCodePoints: 5),
  ],
)
```

I would recommend referring to [`LengthLimitingTextInputFormatter`](https://github.com/flutter/flutter/blob/a7a950aea089d638bdaf6ea9d0ade91f819b3a7b/packages/flutter/lib/src/services/text_formatter.dart#L445) for a thorough implementation which adapts to different platforms and also takes text composition into account.

Kudos to @LongCatIsLooong for the suggestion during text input triage
      </comment>
      <comment author="loic-sharma">
Ah I missed the discussion in the linked PR. I added a comment there: https://github.com/flutter/flutter/pull/182920#issuecomment-3974195223

> ...
> This is a reasonable feature, but it seems rather uncommon. Every feature we add to `TextField` directly increases its complexity, and `TextField` is already very complex.
> 
> Instead of adding this feature directly to `TextField`, I'd prefer that `TextField` provides the necessary foundations that let you build this feature on top of `TextField` using composition. Since a custom `TextInputFormatter` should let you add code point limits (see [#182907 (comment)](https://github.com/flutter/flutter/issues/182907#issuecomment-3974082231) for an example prototype), I lean towards not adding this feature.
> ...
      </comment>
      <comment author="chrisbobbe">
Interesting; yes, that should work re: enforcement.

The other piece of functionality controlled by `maxLength` is the "counter" showing current / maximum character counts. I see multiple other ways to control that:

- [`TextField.buildCounter`](https://api.flutter.dev/flutter/material/TextField/buildCounter.html)
- [`InputDecoration.counter`](https://api.flutter.dev/flutter/material/InputDecoration/counter.html)
- [`InputDecoration.counterText`](https://api.flutter.dev/flutter/material/InputDecoration/counterText.html) / [`InputDecoration.counterStyle`](https://api.flutter.dev/flutter/material/InputDecoration/counterStyle.html)

and I was able to make it show accurate numbers by using the field's `TextEditingController`, which isn't totally ergonomic but it worked:

```dart
      buildCounter: (context, {
        required currentLength,
        required maxLength,
        required isFocused,
      }) => Text('${controller.text.runes.length}/$maxLengthCodePoints'),
```

(That solution feels simpler than the `InputDecoration` controls; I think I'd need to involve a stateful widget and a listener on the `TextEditingController` to make live-updating work with those.)

So I think I'm all set, and this can be closed as not planned. Thanks for considering!
      </comment>
    </comments>
  </issue>
  <issue id="182876">
    <title>External voice dictation tools (e.g. Typeless, Windows Voice Typing) cannot detect Flutter TextFields via UIA at least in [Windows]</title>
    <body>
### Steps to reproduce

1. Install an external voice dictation tool (tested with [Typeless](https://typeless.com/) and a Whisper-based tool).
2. Run a Flutter desktop app with a standard `TextField`.
3. Focus the `TextField`, activate dictation, and speak.
4. The tool **cannot detect the TextField** and fails to inject text.

### Expected results

The dictation tool should detect the focused `TextField` via Windows UI Automation (UIA) and inject text directly — as it does with native Win32, WPF, UWP, Electron, and other desktop frameworks.

### Actual results

The dictation tool **cannot locate any editable text control** in the Flutter window via UIA.

- **Typeless** falls back to a "Copy last transcription" popup — it found the window but no injectable text field.
- **Whisper-based tools** similarly fail to inject into the focused field.

Windows built-in Voice Typing (`Win+H`) and Voice Access likely have the same problem, since they rely on the same UIA / TSF infrastructure.


### Root cause analysis

Two main gaps were identified:

**1. UIA text-editing patterns not properly exposed**

External tools find text fields by querying UIA for `IValueProvider` (`SetValue()`) or `ITextProvider`. Flutter's `AXPlatformNodeWin` (from Chromium) implements `IRawElementProviderFragment` and some UIA patterns, but `FlutterPlatformNodeDelegate` doesn't seem to correctly expose them for `TextField` widgets. The `ITextProvider` / `StringSearch` implementation is also known incomplete (#117013).

**2. No TSF — still on legacy IMM32**

Flutter's Windows embedder uses **IMM32** for IME support (`text_input_manager.cc`), not **TSF (Text Services Framework)**. TSF is how modern Windows routes speech recognition, handwriting, and keyboard input via `ITextStoreACP`. Without a TSF text store, any input going through TSF (including `Win+H`) has nowhere to write. Microsoft has [stated](https://learn.microsoft.com/en-us/windows/apps/develop/input/input-method-editor-requirements) that IMM32 is being deprecated.

Additionally, when a dictation tool shows an overlay, it can steal focus from the Flutter window — and Flutter's text input pipeline depends on window focus to receive `WM_*` messages, so even clipboard-based fallback injection may break.

### Related issues

- #117013 — Incomplete `StringSearch` for `AXPlatformNodeTextRangeProviderWin`
- #181313 — IME activated when no TextField has focus
- #36057 / #176403 — Touch/virtual keyboard issues in tablet mode (same underlying infrastructure)

### Suggested fix

1. **Fix UIA pattern exposure** — Make `FlutterPlatformNodeDelegate` properly expose `IValueProvider` (with working `SetValue`) and `ITextEditProvider` for text fields. This alone would fix tools like Typeless that inject via UIA.

2. **Migrate to TSF** — Implement `ITextStoreACP` to replace IMM32-based text input. This would fix `Win+H`, Fluid Dictation, and all TSF-based input methods, and is also the proper fix for the touch keyboard issues (#36057 / #176403).

### Current workaround

As an app-level workaround, a **clipboard bridge** works: monitor `WM_CLIPBOARDUPDATE` and auto-insert clipboard content into the focused `TextField` when updated by an external process. This covers tools like Typeless that fall back to clipboard, but it's a hack — not a substitute for proper UIA/TSF support.

### Environment

```
[✓] Flutter (Channel stable, 3.38.3, on Microsoft Windows [Version 10.0.19045.6466], locale zh-CN)
    • Flutter version 3.38.3 on channel stable
    • Framework revision 19074d12f7 (2025-11-20)
    • Engine revision 13e658725d
    • Dart version 3.10.1
    • DevTools version 2.51.1

[✓] Windows Version (10 Pro 64-bit, 22H2, 2009)

[✓] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.14.16)
    • Windows 10 SDK version 10.0.26100.0
```

    </body>
    <comments>
      <comment author="mbcorona">
Hi @dbsxdbsx , thanks for reporting, labeling team-engine for review of this issue.
      </comment>
    </comments>
  </issue>
  <issue id="181907">
    <title>[Windows] Shift key randomly gets stuck in a "pressed down" state forever when using TextFields</title>
    <body>
### Steps to reproduce

The problem is that sometimes, when editing text inside a TextField using the Shift key, the Flutter app will keep the Shift key stuck in a "pressed down" state forever.

It happens quite randomly, but generally what seems to trigger the problem is this: 
1. Focus on a TextField widget and write something
2. Use the Shift key, maybe combined with the arrow keys as well (press Shift and select some text with the arrow keys, or press Shift and click with your mouse somewhere within the TextField, ...). Also try to unfocus the whole application (click on your desktop, other app, etc), then re-focus the Flutter app
3. At some point you will notice that the Shift key is logically stuck in a "pressed down" state forever inside the Flutter app. You cannot deactivate/unpress it, no matter what

This issue seems to be related to these
- https://github.com/flutter/flutter/issues/115066
- https://github.com/flutter/flutter/issues/75675

but it seems the problem is still here in Flutter v3.32.8.

Here are some signs to notice when this problem starts to happen:
- when you edit some text inside a TextField, parts of the text are automatically selected (without you pressing the Shift key) -> you can see this happening in the video
- you cannot scroll vertical scroll views with your mouse wheel anymore because the Shift key is stuck in the down state, so you can only scroll horizontally now
- focus groups will now focus backwards (i.e. when you press the Tab key to move to the next focus, the app will actually focus the previous focusable element) -> you can see this happening in the video

### Expected results

Expected = I can use the Shift key normally

### Actual results

Actual = The Shift key is stuck in a "pressed down" state forever, and you have to restart the app to "fix it", but it will happen again at some point

### Code sample

<details open><summary>Code sample</summary>

I can't paste the actual code from the video, but the widgets are literally just two TextFields with a border and nothing else.
Any TextField will do.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: const TextField(),
        ),
      ),
    );
  }
}
```

</details>


### Screenshots or Video

<details open>
<summary>Screenshots / Video demonstration</summary>

https://github.com/user-attachments/assets/4c9dfa8b-b40f-49b8-96b3-99c4ea819377

</details>


### Logs

_No response_

### Flutter Doctor output

<details open><summary>Doctor output</summary>

```console
$ flutter doctor -v
[✓] Flutter (Channel stable, 3.32.8, on Microsoft Windows [Version 10.0.22631.6199], locale en-001) [407ms]
    • Flutter version 3.32.8 on channel stable at C:\Users\ady_f\fvm\versions\3.32.8
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision edada7c56e (6 months ago), 2025-07-25 14:08:03 +0000
    • Engine revision ef0cd00091
    • Dart version 3.8.1
    • DevTools version 2.45.1

[✓] Windows Version (11 Home 64-bit, 23H2, 2009) [2.7s]

[✓] Android toolchain - develop for Android devices (Android SDK version 36.0.0) [1,828ms]
    • Android SDK at D:\Software\dev\android-sdk
    • Platform android-36, build-tools 36.0.0
    • Java binary at: C:\Program Files\OpenJDK\jdk-18.0.2\bin\java
      This JDK is specified in your Flutter configuration.
      To change the current JDK, run: `flutter config --jdk-dir="path/to/jdk"`.
    • Java version OpenJDK Runtime Environment (build 18.0.2+9-61)
    • All Android licenses accepted.

[✓] Chrome - develop for the web [100ms]
    • Chrome at C:\Program Files\Google\Chrome\Application\chrome.exe

[✓] Visual Studio - develop Windows apps (Visual Studio Community 2019 16.11.18) [99ms]
    • Visual Studio at C:\Program Files (x86)\Microsoft Visual Studio\2019\Community
    • Visual Studio Community 2019 version 16.11.32802.440
    • Windows 10 SDK version 10.0.19041.0

[✓] Android Studio (version 2025.1.4) [28ms]
    • Android Studio at C:\Program Files\Android\Android Studio
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 21.0.8+-14018985-b1038.68)

[✓] VS Code, 64-bit edition (version 1.102.2) [26ms]
    • VS Code at C:\Program Files\Microsoft VS Code
    • Flutter extension version 3.128.0

[✓] Connected device (3 available) [221ms]
    • Windows (desktop) • windows • windows-x64    • Microsoft Windows [Version 10.0.22631.6199]
    • Chrome (web)      • chrome  • web-javascript • Google Chrome 144.0.7559.110
    • Edge (web)        • edge    • web-javascript • Microsoft Edge 144.0.3719.92

[✓] Network resources [359ms]
    • All expected network resources are available.

• No issues found!
```

</details>

    </body>
    <comments>
      <comment author="saurabh-mirajkar">
@adrianflutur Thanks for the report.
      </comment>
    </comments>
  </issue>
</collection>

