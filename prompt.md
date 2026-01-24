<instructions>
Summarize each of the following GitHub issues in 1-3 sentences.

Suggest a title for each, in sentence case. If the issue is specific to a
platform, prefix the title with the platform name, e.g. "[Android]" or "[iOS]".
</instructions>

<example_output>

# [Android] Backspace is not sent to TextField

**Issue ID**: [flutter#123](https://github.com/flutter/flutter/issues/123)

**Summary**: When Backspace is pressed on a virtual keyboard of certain Samsung
devices, the keypress is not sent to the TextField.

</example_output>

<collection>
  <issue id="181231">
    <title>[SelectionArea] An incorrect context menu popped up when SelectionArea was nested</title>
    <body>
### Steps to reproduce

Right-clicking within a nested SelectionArea area may sometimes pop up the
ContextMenu of the parent Selection.

### Expected results

Right-clicking within a nested SelectionArea area always pop up the ContextMenu
of current SelectionArea.

### Actual results

Right-clicking within a nested SelectionArea area may sometimes pop up the
ContextMenu of the parent Selection.

### Code sample

<details open><summary>Code sample</summary>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: SelectionArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
            SelectionArea(
              child: Container(
                height: 300,
                color: Colors.yellow,
                alignment: Alignment.center,
                child: Text('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'),
              ),
            ),
            Text('ccccccccccccccccccccccccccccc'),
          ],
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

![Image](https://github.com/user-attachments/assets/10def7ed-9eb8-4f47-b55d-b8038ca1a8a0)

</details>

### Logs

<details open><summary>Logs</summary>

```console
[Paste your logs here]
```

</details>

### Flutter Doctor output

<details open><summary>Doctor output</summary>

```console
[√] Flutter (Channel stable, 3.38.6, on Microsoft Windows [版本 10.0.26100.7462], locale zh-CN) [231ms]
    • Flutter version 3.38.6 on channel stable at D:\Flutter\flutter_windows_latest\flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 8b87286849 (12 days ago), 2026-01-08 10:49:17 -0800
    • Engine revision 78fc3012e4
    • Dart version 3.10.7
    • DevTools version 2.51.1
    • Pub download mirror https://pub.flutter-io.cn
    • Flutter download mirror https://storage.flutter-io.cn
    • Feature flags: enable-web, enable-linux-desktop, enable-macos-desktop, enable-windows-desktop, enable-android,
      enable-ios, cli-animations, enable-native-assets, omit-legacy-version-file, enable-lldb-debugging

[√] Windows Version (Windows 11 or higher, 24H2, 2009) [717ms]

[√] Android toolchain - develop for Android devices (Android SDK version 36.0.0) [1,340ms]
    • Android SDK at D:\Android\Sdk
    • Emulator version 36.3.10.0 (build_id 14472402) (CL:N/A)
    • Platform android-36, build-tools 36.0.0
    • ANDROID_HOME = D:\Android\Sdk
    • Java binary at: D:\Android\Studio\jbr\bin\java
      This is the JDK bundled with the latest Android Studio installation on this machine.
      To manually set the JDK path, use: `flutter config --jdk-dir="path/to/jdk"`.
    • Java version OpenJDK Runtime Environment (build 21.0.8+-14196175-b1038.72)
    • All Android licenses accepted.

[√] Chrome - develop for the web [66ms]
    • Chrome at C:\Program Files\Google\Chrome\Application\chrome.exe

[√] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.14.12) [65ms]
    • Visual Studio at D:\VisualStudio\Community
    • Visual Studio Community 2022 version 17.14.36408.4
    • Windows 10 SDK version 10.0.26100.0

[√] Connected device (3 available) [257ms]
    • Windows (desktop) • windows • windows-x64    • Microsoft Windows [版本 10.0.26100.7462]
    • Chrome (web)      • chrome  • web-javascript • Google Chrome 142.0.7444.176
    • Edge (web)        • edge    • web-javascript • Microsoft Edge 144.0.3719.82

[√] Network resources [832ms]
    • All expected network resources are available.

• No issues found!
```

</details>

    </body>
    <comments>

## author:	YaolongChen association:	none edited:	false status:	none

Incidentally, even wrapping the nested `SelectionArea` with
`SelectionContainer.disabled` didn't help.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: SelectionArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
            SelectionContainer.disabled(
              child: SelectionArea(
                child: Container(
                  height: 300,
                  color: Colors.yellow,
                  alignment: Alignment.center,
                  child: Text('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'),
                ),
              ),
            ),
            Text('ccccccccccccccccccccccccccccc'),
          ],
        ),
      ),
    );
  }
}
```

## ![Image](https://github.com/user-attachments/assets/f0f0d3ff-c898-4b7f-8599-eabaa3162323)

## author:	tirth-patel-nc association:	member edited:	false status:	none

Thanks for the report. Seeing the same behaviour with latest SDK versions.

```
stable : 3.38.7
master : 3.41.0-1.0.pre-187
```

## -- author:	flutter-triage-bot association:	none edited:	false status:	none

## The `fyi-text-input` label is redundant with the `team-text-input` label. The `triaged-design` label is irrelevant if there is no `team-design` label or `fyi-design` label.

    </comments>

</issue>
  <issue id="180484">
    <title>[Android] `MediaQuery.viewInsetOf(context).bottom` discontinuity when opening the keyboard</title>
    <body>
### Steps to reproduce

- Create an app and align a fixed height container to the bottom of the safe
  area and add a textfield
- Run the app and tap into the text field
- Notice that as the keyboard opens there's a jump at the end of the animation

### Expected results

- There's no jump in the animation

### Actual results

- There's a jump in the animation

### Code sample

<details open><summary>Flutter Code sample</summary>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(hintText: 'Enter text here', border: OutlineInputBorder()),
              ),
            ),

            const Spacer(),

            const Text('Flutter Example', textAlign: TextAlign.center),

            const Spacer(),

            Container(width: double.infinity, height: 60, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
```

</details>

<details open><summary>Android Code sample</summary>

```kotlin
package com.example.text_example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.example.text_example.ui.theme.Text_exampleTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            Text_exampleTheme {
              MainScreen()
            }
        }
    }
}

@Composable
fun MainScreen(modifier: Modifier = Modifier) {
    var textFieldValue by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .windowInsetsPadding(WindowInsets.systemBars.only(WindowInsetsSides.Top))
            .imePadding()
            .windowInsetsPadding(WindowInsets.systemBars.only(WindowInsetsSides.Bottom)),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // TextField at the top
        TextField(
            value = textFieldValue,
            onValueChange = { textFieldValue = it },
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            placeholder = { Text("Enter text here") }
        )

        Spacer(modifier = Modifier.weight(1f))

        Text("Native Android Example", textAlign = TextAlign.Center)


        Spacer(modifier = Modifier.weight(1f))

        // Red rectangle at the bottom
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(60.dp)
                .background(Color.Red)
        )
    }
}
```

</details>

### Screenshots or Video

<details open>
<summary>Screenshots / Video demonstration</summary>

https://github.com/user-attachments/assets/681a46ae-5cb6-4b9a-a691-2c4c1cff2152

https://github.com/user-attachments/assets/d678f871-8b9f-46b0-9f2f-f4d1e9828260

</details>

### Details

I've attached two implementations (Flutter, Native) and two video captures to
compare on the same device.

- The Android implementation has no jump
- The Flutter implementation has a jump the end of the animation

I've also logged `MediaQuery.viewInsetOf(context).bottom` and the values look
like this:

```
I/flutter (32244): Bottom inset: 46.857142857142854
I/flutter (32244): Bottom inset: 194.28571428571428
I/flutter (32244): Bottom inset: 252.95238095238096
I/flutter (32244): Bottom inset: 274.6666666666667
I/flutter (32244): Bottom inset: 288.0
I/flutter (32244): Bottom inset: 296.0
I/flutter (32244): Bottom inset: 299.42857142857144
I/ImeTracker(32244): com.example.text_example:8f09955a: onShown
I/flutter (32244): Bottom inset: 324.1904761904762
```

Notice that after `288.0`, `296.0`, a jump occurs to `324.1904761904762`. The 24
point jump also seems to be highly related to the height of the home indicator
visible on the bottom when the keyboard is closed.

### System

Nothing OS 3.2 Nothing Phone 1 Android version 15

### Flutter Doctor output

<details open><summary>Doctor output</summary>

```console
[✓] Flutter (Channel stable, 3.38.5, on macOS 15.7.1 24G231 darwin-arm64, locale en-US) [450ms]
    • Flutter version 3.38.5 on channel stable at /Users/rumori/fvm/versions/3.35.6
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision f6ff1529fd (3 weeks ago), 2025-12-11 11:50:07 -0500
    • Engine revision 1527ae0ec5
    • Dart version 3.10.4
    • DevTools version 2.51.1
    • Feature flags: enable-web, enable-linux-desktop, enable-macos-desktop, enable-windows-desktop, enable-android, enable-ios, cli-animations, enable-native-assets,
      omit-legacy-version-file, enable-lldb-debugging

[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0) [1,770ms]
    • Android SDK at /Users/rumori/Library/Android/sdk
    • Emulator version 36.1.9.0 (build_id 13823996) (CL:N/A)
    • Platform android-36, build-tools 35.0.0
    • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
      This is the JDK bundled with the latest Android Studio installation on this machine.
      To manually set the JDK path, use: `flutter config --jdk-dir="path/to/jdk"`.
    • Java version OpenJDK Runtime Environment (build 21.0.7+-13880790-b1038.58)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 26.1) [1,043ms]
    • Xcode at /Applications/Xcode26.1.app/Contents/Developer
    • Build 17B55
    • CocoaPods version 1.16.2

[✓] Chrome - develop for the web [6ms]
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Connected device (5 available) [6.3s]
(redacted)
[✓] Network resources [667ms]
    • All expected network resources are available.

• No issues found!
```

</details>

    </body>
    <comments>

## author:	PurplePolyhedron association:	contributor edited:	true status:	none

## Have you tried the code in profile or release mode? I have experienced lag when opening the keyboard in Android debug mode.

## author:	intonarumori association:	none edited:	false status:	none

## Yes, I tested in release mode and it's the same result, pretty noticeable. The native version is smooth as butter.

## author:	tirth-patel-nc association:	member edited:	false status:	none

## thanks for the report. Appears to be a duplicate of #19480 #167374 #116836. If you disagree write in comments and I'll reopen the issue.

## author:	intonarumori association:	none edited:	false status:	none

## I've looked at those issues, I think they are related, but not duplicates.

## author:	intonarumori association:	none edited:	false status:	none

## @tirth-patel-nc This issue is related to the ones you posted, but not a straight duplicate, please reopen.

## author:	tirth-patel-nc association:	member edited:	false status:	none

Thanks for the report. Seeing the same behaviour with latest SDK versions.

```
stable : 3.38.6
master : 3.40.0-1.0.pre-494
```

## -- author:	HE-LU association:	none edited:	false status:	none

@intonarumori I can confirm that I’m seeing the same issue on my end. I tested
both the stable release (3.38.6) and master, and the behavior is consistent.

I also noticed an additional, less obvious behavior. As shown in your video,
when the keyboard opens, the red bar becomes slightly cropped. I can reproduce
this as well.

Additionally, when this happens very quickly—for example, when unfocusing on
click and rapidly focusing/unfocusing the input, causing the software keyboard
to open and close in quick succession—the behavior changes slightly. Instead of
cropping the red bar, an empty space is added below it, shifting the entire bar
slightly upward above the keyboard. This then settles once the keyboard is fully
visible.

## Could you please check whether you observe the same behavior during rapid keyboard show/hide cycles?

## author:	loic-sharma association:	member edited:	true status:	none

@intonarumori Could you expand on how this issue is different than
https://github.com/flutter/flutter/issues/116836?

## It looks like these issues have similar root causes, I suspect we should mark this one as a duplicate and copy your findings to that issue.

    </comments>

</issue>
  <issue id="180435">
    <title>Action.overridable cannot be overridden by a DoNothingAction</title>
    <body>
### Steps to reproduce

1. Wrap a `TextField` with `Actions` and use `DoNothingAction` for all text
   editing `Intent`s (see code sample)
2. Run it, type in some text.
3. Do some text editing related shortcuts like `arrow left`, `arrow up`,
   `ctrl + A`, `backspace` etc.

### Expected results

1. `arrow up`, `arrow down`, `page up`, `page down`, `home` and `end` or in
   other words `ExtendSelectionVerticallyToAdjacentPageIntent` and
   `ExtendSelectionVerticallyToAdjacentLineIntent` do nothing
2. for all other intents no assertion errors is thrown

### Actual results

1. `ExtendSelectionVerticallyToAdjacentPageIntent` and
   `ExtendSelectionVerticallyToAdjacentLineIntent` moves caret to the start/end
   of the text
2. When all other intents are executed, the following assertion error is thrown
   (example for `SelectAllTextIntent`):

```dart
════════ Exception caught by services library ══════════════════════════════════
The following assertion was thrown while processing the key message handler:
SelectAllTextIntent cannot be handled by an Action of runtime type DoNothingAction.
'package:flutter/src/widgets/actions.dart':
Failed assertion: line 926 pos 9: 'false'

Either the assertion indicates an error in the framework itself, or we should provide substantially more information in this error message to help you determine and fix the underlying cause.
In either case, please report this assertion by filing a bug on GitHub:
  https://github.com/flutter/flutter/issues/new?template=02_bug.yml

When the exception was thrown, this was the stack:
#2      Actions._castAction (package:flutter/src/widgets/actions.dart:926:9)
actions.dart:926
#3      Actions._maybeFindWithoutDependingOn.<anonymous closure> (package:flutter/src/widgets/actions.dart:907:33)
actions.dart:907
#4      Actions._visitActionsAncestors (package:flutter/src/widgets/actions.dart:746:18)
actions.dart:746
#5      Actions._maybeFindWithoutDependingOn (package:flutter/src/widgets/actions.dart:905:5)
actions.dart:905
#6      _OverridableActionMixin.getOverrideAction (package:flutter/src/widgets/actions.dart:1637:19)
actions.dart:1637
#7      _OverridableActionMixin.isEnabled (package:flutter/src/widgets/actions.dart:1706:39)
actions.dart:1706
#8      Action._isEnabled (package:flutter/src/widgets/actions.dart:247:45)
actions.dart:247
#9      ActionDispatcher.invokeActionIfEnabled (package:flutter/src/widgets/actions.dart:664:16)
actions.dart:664
#10     ShortcutManager.handleKeypress (package:flutter/src/widgets/shortcuts.dart:935:9)
shortcuts.dart:935
#11     _ShortcutsState._handleOnKeyEvent (package:flutter/src/widgets/shortcuts.dart:1135:20)
shortcuts.dart:1135
#12     _HighlightModeManager.handleKeyMessage (package:flutter/src/widgets/focus_manager.dart:2244:72)
focus_manager.dart:2244
#13     KeyEventManager._dispatchKeyMessage (package:flutter/src/services/hardware_keyboard.dart:1119:34)
hardware_keyboard.dart:1119
#14     KeyEventManager.handleRawKeyMessage (package:flutter/src/services/hardware_keyboard.dart:1195:17)
hardware_keyboard.dart:1195
#15     BasicMessageChannel.setMessageHandler.<anonymous closure> (package:flutter/src/services/platform_channel.dart:259:49)
platform_channel.dart:259
#16     _DefaultBinaryMessenger.setMessageHandler.<anonymous closure> (package:flutter/src/services/binding.dart:665:35)
binding.dart:665
#17     _invoke2 (dart:ui/hooks.dart:388:13)
hooks.dart:388
#18     _ChannelCallbackRecord.invoke (dart:ui/channel_buffers.dart:45:5)
channel_buffers.dart:45
#19     _Channel.push (dart:ui/channel_buffers.dart:136:31)
channel_buffers.dart:136
#20     ChannelBuffers.push (dart:ui/channel_buffers.dart:344:17)
channel_buffers.dart:344
```

### Code sample

<details open><summary>Code sample</summary>

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
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        body: Actions(
          actions: {
            DeleteCharacterIntent: DoNothingAction(),
            DeleteToNextWordBoundaryIntent: DoNothingAction(),
            DeleteToLineBreakIntent: DoNothingAction(),
            ExtendSelectionByCharacterIntent: DoNothingAction(),
            ExtendSelectionToNextWordBoundaryIntent: DoNothingAction(),
            ExtendSelectionToNextWordBoundaryOrCaretLocationIntent:
                DoNothingAction(),
            ExtendSelectionToLineBreakIntent: DoNothingAction(),
            ExtendSelectionVerticallyToAdjacentLineIntent: DoNothingAction(),
            ExtendSelectionVerticallyToAdjacentPageIntent: DoNothingAction(),
            ExtendSelectionToDocumentBoundaryIntent: DoNothingAction(),
            SelectAllTextIntent: DoNothingAction(),
            ReplaceTextIntent: DoNothingAction(),
            UpdateSelectionIntent: DoNothingAction(),
            CopySelectionTextIntent: DoNothingAction(),
            PasteTextIntent: DoNothingAction(),
          },
          child: const TextField(enableInteractiveSelection: false),
        ),
      ),
    );
  }
}
```

</details>

### Screenshots or Video

_No response_

### Logs

_No response_

### Flutter Doctor output

<details open><summary>Doctor output</summary>

```console
[✓] Flutter (Channel stable, 3.38.5, on Pop!_OS 24.04 LTS 6.17.9-76061709-generic, locale en_US.UTF-8) [26ms]
    • Flutter version 3.38.5 on channel stable at /home/alexander/.develop/flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision f6ff1529fd (3 weeks ago), 2025-12-11 11:50:07 -0500
    • Engine revision 1527ae0ec5
    • Dart version 3.10.4
    • DevTools version 2.51.1
    • Feature flags: enable-web, enable-linux-desktop, enable-macos-desktop, enable-windows-desktop, enable-android, enable-ios,
      cli-animations, enable-native-assets, omit-legacy-version-file, enable-lldb-debugging

[✓] Android toolchain - develop for Android devices (Android SDK version 36.1.0) [998ms]
    • Android SDK at /home/alexander/.android/sdk/
    • Emulator version 36.3.10.0 (build_id 14472402) (CL:N/A)
    • Platform android-36, build-tools 36.1.0
    • Java binary at: /home/alexander/.local/android-studio/jbr/bin/java
      This is the JDK bundled with the latest Android Studio installation on this machine.
      To manually set the JDK path, use: `flutter config --jdk-dir="path/to/jdk"`.
    • Java version OpenJDK Runtime Environment (build 21.0.8+-14196175-b1038.72)
    • All Android licenses accepted.

[✓] Chrome - develop for the web [8ms]
    • Chrome at google-chrome

[✓] Linux toolchain - develop for Linux desktop [370ms]
    • Ubuntu clang version 18.1.3 (1ubuntu1)
    • cmake version 3.28.3
    • ninja version 1.11.1
    • pkg-config version 1.8.1
    • OpenGL core renderer: Mesa Intel(R) Iris(R) Xe Graphics (RPL-P)
    • OpenGL core version: 4.6 (Core Profile) Mesa 25.1.5-1pop0~1753463422~24.04~8af185e
    • OpenGL core shading language version: 4.60
    • OpenGL ES renderer: Mesa Intel(R) Iris(R) Xe Graphics (RPL-P)
    • OpenGL ES version: OpenGL ES 3.2 Mesa 25.1.5-1pop0~1753463422~24.04~8af185e
    • OpenGL ES shading language version: OpenGL ES GLSL ES 3.20
    • GL_EXT_framebuffer_blit: yes
    • GL_EXT_texture_format_BGRA8888: yes

[✓] Connected device (2 available) [125ms]
    • Linux (desktop) • linux  • linux-x64      • Pop!_OS 24.04 LTS 6.17.9-76061709-generic
    • Chrome (web)    • chrome • web-javascript • Google Chrome 143.0.7499.169

[✓] Network resources [363ms]
    • All expected network resources are available.

• No issues found!
```

</details>

    </body>
    <comments>

## author:	PurplePolyhedron association:	contributor edited:	true status:	none

It seems that `DoNothingAction` couldn't actually bind to any `Intent` in this
case, despite the document saying it should be able to. A possible workaround is
to create your own `Intent` specific `DoNothingAction`.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const ActionApp());
}

class MyDoNothingAction<T extends Intent> extends Action<T> {
  @override
  void invoke(T intent) {}
}

class ActionApp extends StatelessWidget {
  const ActionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        body: Actions(
          actions: {
            DeleteCharacterIntent: MyDoNothingAction<DeleteCharacterIntent>(),
            DeleteToNextWordBoundaryIntent: MyDoNothingAction<DeleteToNextWordBoundaryIntent>(),
            DeleteToLineBreakIntent: MyDoNothingAction<DeleteToLineBreakIntent>(),
            ExtendSelectionByCharacterIntent: MyDoNothingAction<ExtendSelectionByCharacterIntent>(),
            ExtendSelectionToNextWordBoundaryIntent:
                MyDoNothingAction<ExtendSelectionToNextWordBoundaryIntent>(),
            ExtendSelectionToNextWordBoundaryOrCaretLocationIntent:
                MyDoNothingAction<ExtendSelectionToNextWordBoundaryOrCaretLocationIntent>(),
            ExtendSelectionToLineBreakIntent: MyDoNothingAction<ExtendSelectionToLineBreakIntent>(),
            ExtendSelectionVerticallyToAdjacentLineIntent:
                MyDoNothingAction<ExtendSelectionVerticallyToAdjacentLineIntent>(),
            ExtendSelectionVerticallyToAdjacentPageIntent:
                MyDoNothingAction<ExtendSelectionVerticallyToAdjacentPageIntent>(),
            ExtendSelectionToDocumentBoundaryIntent:
                MyDoNothingAction<ExtendSelectionToDocumentBoundaryIntent>(),
            SelectAllTextIntent: MyDoNothingAction<SelectAllTextIntent>(),
            ReplaceTextIntent: MyDoNothingAction<ReplaceTextIntent>(),
            UpdateSelectionIntent: MyDoNothingAction<UpdateSelectionIntent>(),
            CopySelectionTextIntent: MyDoNothingAction<CopySelectionTextIntent>(),
            PasteTextIntent: MyDoNothingAction<PasteTextIntent>(),
          },
          child: const TextField(enableInteractiveSelection: false),
        ),
      ),
    );
  }
}
```

## -- author:	lebeshev association:	none edited:	false status:	none

> A possible workaround is to create your own Intent specific DoNothingAction.

## Yes, that naturally fixes assertion errors. This does not fix `ExtendSelectionVerticallyToAdjacentLineIntent` and `ExtendSelectionVerticallyToAdjacentPageIntent` still running their default actions however.

## author:	lebeshev association:	none edited:	false status:	none

I did some digging and I think I found the issue for why overriding
`ExtendSelectionVerticallyToAdjacentLineIntent` and
`ExtendSelectionVerticallyToAdjacentPageIntent` does not work.

Here is the code from `editable_text.dart` :

```dart
// line 5455
  late final _UpdateTextSelectionVerticallyAction<DirectionalCaretMovementIntent>
  _verticalSelectionUpdateAction =
      _UpdateTextSelectionVerticallyAction<DirectionalCaretMovementIntent>(this);
// ...

// line 5512
  late final Map<Type, Action<Intent>> _actions = <Type, Action<Intent>>{
// ...
// line 5570
    ExtendSelectionVerticallyToAdjacentLineIntent: _makeOverridable(_verticalSelectionUpdateAction),
    ExtendSelectionVerticallyToAdjacentPageIntent: _makeOverridable(_verticalSelectionUpdateAction),
// ...
}
```

Action used for both `ExtendSelectionVerticallyToAdjacentLineIntent` and
`ExtendSelectionVerticallyToAdjacentPageIntent` is bound to
`DirectionalCaretMovementIntent`, which I assume should not be the case.

And indeed overriding the `DirectionalCaretMovementIntent` itself like

```dart
DirectionalCaretMovementIntent: MyDoNothingAction<DirectionalCaretMovementIntent>()
```

## fixes the issue and caret does not move anymore on `arrow up` and similar shortcuts.

## author:	tirth-patel-nc association:	member edited:	false status:	none

Thanks for the report. Seeing the same behaviour with latest SDK versions.

```
stable : 3.38.5
master : 3.40.0-1.0.pre-413
```

## -- author:	loic-sharma association:	member edited:	true status:	none

This appears to be a bug in
[`Action.overridable`](https://api.flutter.dev/flutter/widgets/Action/Action.overridable.html).
`Action.overridable` is an action that can be overridden by an action higher up
the widget tree.

Like @PurplePolyhedron mentioned above,
[`DoNothingAction`](https://api.flutter.dev/flutter/widgets/DoNothingAction-class.html)'s
docs claims it can bind to any intent.

However, `Action.overridable` does not appear to take `DoNothingAction` into
account properly. When it finds an override action, it checks that that override
action's intent matches the overridden action's intent:
[1](https://github.com/flutter/flutter/blob/96403e0fa5704dacd8fee2509b9333a86b3c7fed/packages/flutter/lib/src/widgets/actions.dart#L907),
[2](https://github.com/flutter/flutter/blob/96403e0fa5704dacd8fee2509b9333a86b3c7fed/packages/flutter/lib/src/widgets/actions.dart#L920).
It seems this check needs to be updated to also allow for `DoNothingAction` -
its intent will not match the overridden action's intent.

<details>
<summary>Minimal repro app...</summary>

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(home: CounterPage()));

class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  void _increment() => setState(() => _count++);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const IncrementIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          IncrementIntent: DoNothingAction(),
        },
        child: Builder(
          builder: (context) {
            return Actions(
              actions: <Type, Action<Intent>>{
                // Option 1: Increment. Works as expected.
                // IncrementIntent: CallbackAction<IncrementIntent>(
                //   onInvoke: (IncrementIntent intent) => _increment(),
                // ),

                // Option 2: DoNothingAction. Works as expected.
                // IncrementIntent: DoNothingAction(),

                // Option 3: Allow parent Action to override with DoNothingAction. Does NOT work.
                IncrementIntent: Action<IncrementIntent>.overridable(
                  defaultAction: CallbackAction<IncrementIntent>(onInvoke: (IncrementIntent intent) => _increment()),
                  context: context,
                ),
              },
              child: Focus(
                autofocus: true, // Focus is required for Shortcuts to work!
                child: Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Press SPACE to increment: $_count'),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: _increment,
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

class IncrementIntent extends Intent {
  const IncrementIntent();
}
```

## -- author:	LongCatIsLooong association:	member edited:	false status:	none

Yeah the `T` in `Action<T>` is supposed to be contravariant so the check doesn't
make sense
https://github.com/flutter/flutter/blob/96403e0fa5704dacd8fee2509b9333a86b3c7fed/packages/flutter/lib/src/widgets/actions.dart#L922

## Unfortunately I don't think we have a way to do that check properly (https://github.com/dart-lang/language/issues/524) so I think we'll have to get rid of the `is` check entirely

## author:	LongCatIsLooong association:	member edited:	false status:	none

Hmm maybe we can construct a const `Function<T>` in each `Action<T>` and does
the type check like this:

```dart
mappedAction._functionSignature is Function<T>
```

## But this means people won't be able to `implement Action<T>`. Let me try this out.

## author:	LongCatIsLooong association:	member edited:	false status:	none

## The above tricks seems to work but unforunately some of our public APIs return `Action<T>` and the language only allows for covariant type parameters so there's no way you can return a `Action<Intent>` when `T` is a more specialized type. And `Function` is final so we can't do `Action<T> extends Function<T>`, and also Function type literal has a special syntax `Function(U)`.

## author:	lebeshev association:	none edited:	false status:	none

> I did some digging and I think I found the issue for why overriding
> `ExtendSelectionVerticallyToAdjacentLineIntent` and
> `ExtendSelectionVerticallyToAdjacentPageIntent` does not work.
>
> Here is the code from `editable_text.dart` :
>
> // line 5455 late final
> _UpdateTextSelectionVerticallyAction<DirectionalCaretMovementIntent>
> _verticalSelectionUpdateAction =
> _UpdateTextSelectionVerticallyAction<DirectionalCaretMovementIntent>(this); //
> ...
>
> // line 5512 late final Map<Type, Action<Intent>> _actions = <Type,
> Action<Intent>>{ // ... // line 5570
> ExtendSelectionVerticallyToAdjacentLineIntent:
> _makeOverridable(_verticalSelectionUpdateAction),
> ExtendSelectionVerticallyToAdjacentPageIntent:
> _makeOverridable(_verticalSelectionUpdateAction), // ... }
>
> Action used for both `ExtendSelectionVerticallyToAdjacentLineIntent` and
> `ExtendSelectionVerticallyToAdjacentPageIntent` is bound to
> `DirectionalCaretMovementIntent`, which I assume should not be the case.
>
> And indeed overriding the `DirectionalCaretMovementIntent` itself like
>
> DirectionalCaretMovementIntent:
> MyDoNothingAction<DirectionalCaretMovementIntent>()
>
> fixes the issue and caret does not move anymore on `arrow up` and similar
> shortcuts.

## Should I create a separate issue for this bug?

## author:	LongCatIsLooong association:	member edited:	false status:	none

> Action used for both `ExtendSelectionVerticallyToAdjacentLineIntent` and
> `ExtendSelectionVerticallyToAdjacentPageIntent` is bound to
> `DirectionalCaretMovementIntent`, which I assume should not be the case.

## Hmm I'm not sure what you mean, it makes sense to me that `ExtendSelectionVerticallyToX` should be a subclass of `DirectionalCaretMovementIntent`?

## author:	lebeshev association:	none edited:	false status:	none

>> Action used for both `ExtendSelectionVerticallyToAdjacentLineIntent` and
>> `ExtendSelectionVerticallyToAdjacentPageIntent` is bound to
>> `DirectionalCaretMovementIntent`, which I assume should not be the case.
>
> Hmm I'm not sure what you mean, it makes sense to me that
> `ExtendSelectionVerticallyToX` should be a subclass of
> `DirectionalCaretMovementIntent`?

The issue is that you cannot override
`ExtendSelectionVerticallyToAdjacentPageIntent` and
`ExtendSelectionVerticallyToAdjacentLineIntent` individually even when using
something
like`MyDoNothingAction<ExtendSelectionVerticallyToAdjacentPageIntent>()` and
`MyDoNothingAction<ExtendSelectionVerticallyToAdjacentLineIntent>()`. You need
to use `MyDoNothingAction<DirectionalCaretMovementIntent>()`, which will
override them both.

And my guess is that this happens because action used in `editable_text.dart`
for both these intents is defined bound to `DirectionalCaretMovementIntent` like
this:

```dart
late final _UpdateTextSelectionVerticallyAction<DirectionalCaretMovementIntent>
_verticalSelectionUpdateAction =
    _UpdateTextSelectionVerticallyAction<DirectionalCaretMovementIntent>(this);
```

## -- author:	LongCatIsLooong association:	member edited:	true status:	none

>>> Action used for both `ExtendSelectionVerticallyToAdjacentLineIntent` and
>>> `ExtendSelectionVerticallyToAdjacentPageIntent` is bound to
>>> `DirectionalCaretMovementIntent`, which I assume should not be the case.
>>
>> Hmm I'm not sure what you mean, it makes sense to me that
>> `ExtendSelectionVerticallyToX` should be a subclass of
>> `DirectionalCaretMovementIntent`?
>
> The issue is that you cannot override
> `ExtendSelectionVerticallyToAdjacentPageIntent` and
> `ExtendSelectionVerticallyToAdjacentLineIntent` individually even when using
> something
> like`MyDoNothingAction<ExtendSelectionVerticallyToAdjacentPageIntent>()` and
> `MyDoNothingAction<ExtendSelectionVerticallyToAdjacentLineIntent>()`. You need
> to use `MyDoNothingAction<DirectionalCaretMovementIntent>()`, which will
> override them both.
>
> And my guess is that this happens because action used in `editable_text.dart`
> for both these intents is defined bound to `DirectionalCaretMovementIntent`
> like this:
>
> late final
> _UpdateTextSelectionVerticallyAction<DirectionalCaretMovementIntent>
> _verticalSelectionUpdateAction =
> _UpdateTextSelectionVerticallyAction<DirectionalCaretMovementIntent>(this);

Ah I might have fixed that in #180883. It's probably because we were using the
statically inferred type `T extends Intent` to find the override action instead
of using the `Intent`'s runtime type. Let me add a test for that later.

## Update: Yeah I think I might have fixed that case in the said PR. But the limitation is that you won't be able to access `callingAction`, which is basically the equivalent of the super implementation when you're implementing the override.

    </comments>

</issue>
  <issue id="179482">
    <title>Semi-transparent keyboard on iOS 26 reveals widgets that do not draw under it</title>
    <body>
> [!NOTE]
> If your app is affected by this problem, consider disabling Liquid Glass for your app by updating your `ios/Runner/Info.plist` file:
>
> ```xml
> <key>UIDesignRequiresCompatibility</key>
> <true/>
> ```
>
> The `UIDesignRequiresCompatibility` property is a temporary workaround until Flutter fixes this issue. You will need to remove this property in the future.
>
> For more details, see: https://developer.apple.com/documentation/BundleResources/Information-Property-List/UIDesignRequiresCompatibility

### Steps to reproduce

Platforms iOS

When you click on the text input box in the BottomSheet Modal, the color around
the rounded corner at the top of the semi-transparent keyboard that pops up is
incorrect

### Expected results

.

### Actual results

When using the keyboard inside an open Bottom Sheet Modal, the modal shifts
upward to make room for the keyboard. However, this causes the semi-transparent
keyboard on iOS 26 to display a black background instead of showing the modal's
content. Please note, this is not a corner-radius issue—the entire keyboard,
being semi-transparent, clearly shows a black background during dragging, which
is inconsistent with the modal's color.

### Code sample

<details><summary>Code sample</summary>

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
      title: 'Flutter Bottom Sheet Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for the text input field
  final TextEditingController _textController = TextEditingController();
  
  // Focus node to manage keyboard focus
  final FocusNode _textFocusNode = FocusNode();
  
  // Store user input
  String _userInput = '';

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  // Method to show the bottom sheet
  void _showBottomSheet(BuildContext context) {
    // Clear previous input when opening
    _textController.clear();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to move up with keyboard
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // Make room for keyboard
            ),
            child: _buildBottomSheetContent(context),
          ),
        );
      },
    ).then((value) {
      // Handle when bottom sheet is closed
      setState(() {
        _userInput = _textController.text;
      });
    });
    
    // Request focus for the text field after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_textFocusNode);
    });
  }

  // Build the content of the bottom sheet
  Widget _buildBottomSheetContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enter Your Text',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Text input field
            TextField(
              controller: _textController,
              focusNode: _textFocusNode,
              decoration: InputDecoration(
                hintText: 'Type something here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              maxLines: 3,
              minLines: 1,
            ),
            const SizedBox(height: 20),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                
                // Submit button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userInput = _textController.text;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Sheet Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bottom Sheet Example',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Display user input
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your Input:',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _userInput.isEmpty ? 'No input yet' : _userInput,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'How to use:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the button below to open a bottom sheet. The text field will automatically gain focus and the keyboard will appear.',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBottomSheet(context),
        icon: const Icon(Icons.edit),
        label: const Text('Open Bottom Sheet'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
```

</details>

### Screenshots or Video

<details open>
<summary>Screenshots / Video demonstration</summary>

[Upload media here]

<img width="377" height="413" alt="Image" src="https://github.com/user-attachments/assets/7f929d5c-986b-4b93-a407-62718b6282d1" />

</details>

### Logs

<details open><summary>Logs</summary>

```console
[Paste your logs here]
```

</details>

### Flutter Doctor output

<details open><summary>Doctor output</summary>

```console
[Paste your output here]
```

</details>

    </body>
    <comments>

## author:	tirth-patel-nc association:	member edited:	false status:	none

Thanks for the report. Seeing the same behaviour with latest SDK versions on
iOS 26. Appears fine on iOS 18.

```
stable : 3.38.4
master : 3.39.0-1.0.pre-426
```

<img width="1512" height="982" alt="Image" src="https://github.com/user-attachments/assets/2c03232a-1cfb-4b47-ae0a-f5bc712de0f4" />
--
author:	lucas-goldner
association:	contributor
edited:	true
status:	none
--
This also happens in a normal text field, from what I have seen. We need to get a hotfix for this ASAP
Same issue here

<img width="322" height="357" alt="Image" src="https://github.com/user-attachments/assets/77fbca37-8d6b-4b0d-933e-21d79ce220f5" />
--
author:	LongCatIsLooong
association:	member
edited:	true
status:	none
--
This is the color of the modal barrier, now that the keyboard does not completely obscure the rectangular area at the bottom. This is going to require a somewhat large change, every bottom sheet widget may have to be updated how it handles `viewInsets` (I don't think there are many such widgets in flutter/flutter but a lot of packages will have to update their UI).

## We'll have to change the definition / documentation of `MediaQueryData.viewInsets`, and update material/cupertino widgets like the material bottom sheet so they extend to cover the keyboard area instead of moving up to avoid the keyboard area.

## author:	loic-sharma association:	member edited:	true status:	none

## I've routed this to the framework team's triage as per @LongCatIsLooong's investigation it appears the fix will need to be in bottom sheets. Please feel free to send it back to the text input team if needed!

## author:	LongCatIsLooong association:	member edited:	false status:	none

FWIW, this is the UI hierarchy of the FlutterViewController when the soft
keyboard pops up:

<img width="243" height="622" alt="Image" src="https://github.com/user-attachments/assets/cdeee19a-e6c7-4e63-b9d0-48b287975329" />
--
author:	LongCatIsLooong
association:	member
edited:	false
status:	none
--
Also IIRC [Scaffold.resizeToAvoidBottomInset](https://main-api.flutter.dev/flutter/material/Scaffold/resizeToAvoidBottomInset.html) defaults to true. This may no longer be the most reasonable behavior in case the app has a floating widget that wants to stay at the bottom of the screen but above the keyboard.
--
author:	Piinks
association:	member
edited:	false
status:	none
--
Ah ok, so Flutter is still drawing under the keyboard? During triage I wasn't sure if the FlutterView even extended below the keyboard.
We also discussed, this probably is not limited to just bottom sheets. The Scaffold for example can resize to avoid the bottom inset. We should check that as well.
--
author:	Piinks
association:	member
edited:	false
status:	none
--
Aha! @LongCatIsLooong too fast for me. :)
--
author:	Piinks
association:	member
edited:	true
status:	none
--
Quick look, there are about ~40 - note: included MediaQuery classes~ 25 uses (not actually individual widgets) of viewInsets in flutter widgets. I imagine there could be more cases than those accounted for here. I'll make a list and work through it.
--
author:	Piinks
association:	member
edited:	true
status:	none
--
- Scaffold.resizeToAvoidBottomInset
- CupertinoPageScaffold.resizeToAvoidBottomInset
- CupertinoTabScaffold.resizeToAvoidBottomInset
- We should check use cases for SearchAnchor as well (--> _SearchViewRoute --> _ViewContent)
  - The ListView in _ViewContentState uses viewInsets to pad itself.

These are the ones I found in my investigation today we should validate against
in addition to those above. This will require a series of changes to several
widgets and not something we would hot fix.

Another case to consider as well, in some cases this will probably not be as
simple as 'draw further below the keyboard', or to just fill the pace with the
background color.

Consider this, looking at the native contacts app:

<img width="147" height="320" alt="Image" src="https://github.com/user-attachments/assets/3d82a955-502e-4b15-b87f-b9f391def5b5" />

The keyboard is up. The text field is focused and in view. I can scroll the page
(which dismisses the keyboard). You can see the rest of the page contents under
the keyboard, the blurry green buttons and such.

Currently, when the Scaffold resizes to avoid the bottom inset, if Scaffold.body
contains a scroll view, the viewport itself ends up resizing to fit within the
visible space the scaffold allots to it, instead of extending below the
keyboard. Changing this viewport resize case might require further changes to
things like getOffsetToReveal, showOnScreen, and ensureVisible, which are used
to scroll things like a text field into view when the keyboard pops up.

## This should probably be a dedicated project for someone to tackle and investigate all the angles here. I am going to un-assign myself for now after having had a look, and will add to the queue for planning.

## author:	Piinks association:	member edited:	false status:	none

## For planning as well: When we have this assigned and determine the course of action (and maybe even a workaround for the meantime) we should send out word to the ecosystem. There are likely other widgets in packages out there that need to account for this as well.

## author:	CarGuo association:	none edited:	false status:	none

Actually, why not temporarily solve the problem by configuring this in the plist
for the time being?

```xml
<key>UIDesignRequiresCompatibility</key>
<true/>
```

| false                                                                                                                                | true                                                                                                                                 |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| <img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/5e9a6c61-52d3-4e56-b509-a354e0b4140e" /> | <img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/432e18f8-ac30-4a00-ada4-b00ece0bdc3a" /> |

## -- author:	CarGuo association:	none edited:	false status:	none

Perhaps the situation isn't as bad as it seems? If the opacity issue mainly
occurs in scenarios where the content is aligned at the bottom, like in
`BottomSheet`? For scenarios like Dialog, after I modified the code as shown
below, it still looks normal, keyboard perspective effect compatible with iOS
26:

<img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/afd39aeb-17a4-4252-8baf-07c6eee5155e" />

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
      title: 'Flutter Bottom Sheet Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for the text input field
  final TextEditingController _textController = TextEditingController();

  // Focus node to manage keyboard focus
  final FocusNode _textFocusNode = FocusNode();

  // Store user input
  String _userInput = '';

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  // Method to show the bottom sheet
  void _showBottomSheet(BuildContext context) {
    // Clear previous input when opening
    _textController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child:  GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapping outside
              FocusScope.of(context).unfocus();
            },
            child: Center(
              child:  SizedBox(
                height: 100,
                child: _buildBottomSheetContent(context),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      // Handle when bottom sheet is closed
      setState(() {
        _userInput = _textController.text;
      });
    });

    // Request focus for the text field after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(_textFocusNode);
    });
  }

  // Build the content of the bottom sheet
  Widget _buildBottomSheetContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text input field
            TextField(
              controller: _textController,
              focusNode: _textFocusNode,
              decoration: InputDecoration(
                hintText: 'Type something here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              maxLines: 3,
              minLines: 1,
            ),
            const SizedBox(height: 20),

            // Action buttons
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Bottom Sheet Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bottom Sheet Example',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Display user input
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your Input:',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _userInput.isEmpty ? 'No input yet' : _userInput,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'How to use:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the button below to open a bottom sheet. The text field will automatically gain focus and the keyboard will appear.',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBottomSheet(context),
        icon: const Icon(Icons.edit),
        backgroundColor: Colors.red,
        label: const Text('Open Bottom Sheet'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
```

--

    </comments>

</issue>
</collection>
