<instructions>
Summarize each of the following GitHub issues.

Suggest a title for each, in sentence case. If the issue is specific to a
platform, prefix the title with the platform name, e.g. "[Android]" or "[iOS]".
</instructions>

<example_output>

# [Android] Backspace is not sent to TextField

**Issue ID**: [flutter#123](https://github.com/flutter/flutter/issues/123)

**Summary**: When Backspace is pressed on a virtual keyboard of certain Samsung
devices, the keypress is not sent to the TextField. This appears to be a bug in
`_HighlightModeManager`: it assumes all `KeyMessage`s are physical key presses,
however, Android's backspace virtual key can send a `KeyMessage`.

</example_output>

<collection>
  <issue id="181873">
    <title>Don't duplicate Semantics logic in TextField and CupertinoTextField</title>
    <body>
We should move all possible Semantics logic out of the design languages and into EditableText, to be DRY and to make sure that direct users of EditableText can easily get nitty gritty semantics details right.

## Background

Currently, EditableText only includes a Semantics widget for toolbar operations:

https://github.com/flutter/flutter/blob/018a57179c12c7d4ee1fb225b4759d2c05047b20/packages/flutter/lib/src/widgets/editable_text.dart#L5800-L5805

Meanwhile [in TextField](https://github.com/flutter/flutter/blob/018a57179c12c7d4ee1fb225b4759d2c05047b20/packages/flutter/lib/src/material/text_field.dart#L1795-L1799) and [in CupertinoTextField](https://github.com/flutter/flutter/blob/018a57179c12c7d4ee1fb225b4759d2c05047b20/packages/flutter/lib/src/cupertino/text_field.dart#L1630-L1632), there is Semantics logic for gestures and focus that is relevant to all users of text input.

## Recommendation

We should move all possible common semantics logic out of TextField/CupertinoTextField and into EditableText.

As a part of that PR, we should also move the test mentioned in https://github.com/flutter/flutter/pull/181722/files#r2760694144 back to the Widgets library, since it tests this semantics logic.

## Resources

This came up in: https://github.com/flutter/flutter/pull/181722/files#r2760694144
    </body>
    <comments>

    </comments>
  </issue>
  <issue id="181682">
    <title>Add a Cupertino version of SelectableText</title>
    <body>
While looking to fix up the last Cupertino test (test/cupertino/text_selection_test.dart) in https://github.com/flutter/flutter/pull/181634  that had a cross import to Material, I ended up being blocked, because that test uses `SelectableText.rich` and there is no Cupertino equivalent of SelectableText yet.

We probably need a Cupertino version of this, to fix that test.

Part of https://github.com/flutter/flutter/issues/177415

cc @justinmc We can probably remove the Cupertino tests from the umbrella issue once https://github.com/flutter/flutter/pull/181634 lands, and replace it with this issue instead, since that is the only remaining point?
    </body>
    <comments>

    </comments>
  </issue>
  <issue id="181532">
    <title>Widgetspan in not correctly aligned with other TextSpan inside Text.rich</title>
    <body>
### Steps to reproduce

1. Run code below on [Dart Pad](https://dartpad.dev/)
2. Change size of the window like in the video attached.

### Expected results

The texts AAA, BBB and CCC must be drawn consecutively without any strange line breaks.

### Actual results

After reducing window size, a strange line appear between AAA and BBB parts.

It seems like the WidgetSpan act like a single rectangle and because of that the TextSpan around cannot align correctly.
It could be interesting to have a solution (maybe it exist ?) to have a "multiline WidgetSpan with pixel perfect hit box".

My goal is to achieve something like bellow. I would like to put a custom border around a specific text : 

<img width="1317" height="210" alt="Image" src="https://github.com/user-attachments/assets/200bc826-7777-4180-ab94-fd995a272ae2" />

### Code sample

<details open><summary>Code sample</summary>

This example is small to hide all useless decoration added to the WidgetSpan in my app.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'AAA AAA AAA AAA '),
                WidgetSpan(
                  child: Text(
                    'BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB ',
                  ),
                ),
                TextSpan(text: ' CCC CCC CCC CCC'),
              ],
            ),
          ),
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

Alignement broken : 

https://github.com/user-attachments/assets/6fa49351-cf2c-48de-a659-4aacd468aa79

Shape is rectangular : 
<img width="636" height="99" alt="Image" src="https://github.com/user-attachments/assets/16505e9c-14fd-417e-b06d-f8e1e7927997" />

</details>


### Logs

<details open><summary>Logs</summary>

```console
```

</details>


### Flutter Doctor output

<details open><summary>Doctor output</summary>

```console
[✓] Flutter (Channel stable, 3.29.3, on macOS 26.2 25C56 darwin-arm64, locale fr-FR) [2,0s]
    • Flutter version 3.29.3 on channel stable at /Users/earminjon/fvm/versions/3.29.3
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision ea121f8859 (10 months ago), 2025-04-11 19:10:07 +0000
    • Engine revision cf56914b32
    • Dart version 3.7.2
    • DevTools version 2.42.3

[✓] Chrome - develop for the web [90ms]
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] IntelliJ IDEA Ultimate Edition (version 2025.3.2) [88ms]
    • IntelliJ at /Users/earminjon/Applications/IntelliJ IDEA.app
    • Flutter plugin version 89.0.0
    • Dart plugin version 502.0.0

[✓] Connected device (3 available) [6,7s]
    • macOS (desktop)                 • macos                 • darwin-arm64   • macOS 26.2 25C56 darwin-arm64
    • Mac Designed for iPad (desktop) • mac-designed-for-ipad • darwin         • macOS 26.2 25C56 darwin-arm64
    • Chrome (web)                    • chrome                • web-javascript • Google Chrome 143.0.7499.193

[✓] Network resources [260ms]
    • All expected network resources are available.
```

</details>

    </body>
    <comments>
author:	darshankawar
association:	member
edited:	false
status:	none
--
Replicable with latest stable and master versions, although this doesn't seem to be specific to web, as on desktop, it appears to replicate as well.

--
author:	flutter-triage-bot
association:	none
edited:	false
status:	none
--
The `fyi-text-input` label is redundant with the `team-text-input` label.
--

    </comments>
  </issue>
  <issue id="181474">
    <title>[iPadOS]Keyboard is dismissed, but the TextField keeps focus, causing subsequent taps not to trigger keyboard presentation.</title>
    <body>
### Steps to reproduce

1. With ipados 26.2. 
2. Set `keyboardType` into `TextInputType.number`.
3. Tap the `TextField` widget.
4. Tap outside. And you can see the 「floated small number keypad」 is dismissed, BUT the `TextField` keeps focus.
5. Now you tap the `TextField` again, the number keypad will not show again anymore.


### Expected results

Tap TextField widget, show keyboard. 
Tap outside, hide keyboard and unfocus.
Tap TextField widget Again, show keyboard again.
...

### Actual results

keyboard dont show again.

### Code sample

<details open><summary>Code sample</summary>

```dart
[Paste your code here]
```

</details>


### Screenshots or Video

<details open>
<summary>Screenshots / Video demonstration</summary>

[Upload media here]

https://github.com/user-attachments/assets/75a094ef-91f1-471a-b436-44e258107d93

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
[✓] Flutter (Channel stable, 3.38.1, on macOS 26.2 25C56 darwin-arm64,
    locale zh-Hans-CN) [1,713ms]
    • Flutter version 3.38.1 on channel stable at
      /Users/EsPsl/fvm/versions/3.38.1
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision b45fa18946 (2 months ago), 2025-11-12 22:09:06
      -0600
    • Engine revision b5990e5ccc
    • Dart version 3.10.0
    • DevTools version 2.51.1
    • Feature flags: enable-web, enable-linux-desktop,
      enable-macos-desktop, enable-windows-desktop, enable-android,
      enable-ios, cli-animations, enable-native-assets,
      omit-legacy-version-file, enable-lldb-debugging,
      enable-uiscene-migration

[✓] Android toolchain - develop for Android devices (Android SDK version
    36.1.0-rc1) [4.2s]
    • Android SDK at /Volumes/ExternalSSD/DevEnv/AndroidSdk
    • Emulator version 36.1.9.0 (build_id 13823996) (CL:N/A)
    • Platform android-36, build-tools 36.1.0-rc1
    • Java binary at: /Applications/Android
      Studio.app/Contents/jbr/Contents/Home/bin/java
      This is the JDK bundled with the latest Android Studio installation
      on this machine.
      To manually set the JDK path, use: `flutter config
      --jdk-dir="path/to/jdk"`.
    • Java version OpenJDK Runtime Environment (build
      21.0.7+-13880790-b1038.58)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 26.1.1) [3.9s]
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 17B100
    • CocoaPods version 1.16.2

[✓] Chrome - develop for the web [7ms]
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google
      Chrome

[✓] Connected device (6 available) [10.3s]
    • Psl (wireless) (mobile)      ...

[!] Network resources [75.1s]           
    ✗ A network error occurred while checking
      "https://maven.google.com/": Operation timed out

! Doctor found issues in 1 category.
```

</details>

    </body>
    <comments>
author:	Crazymuyang
association:	none
edited:	false
status:	none
--
New trouble.
If you use a M chip iPad and tap a TextField widget set with `TextInputType.number`, the keyboard is hard to appear.
--
author:	LongCatIsLooong
association:	member
edited:	false
status:	none
--
It looks like the "floating" number pad doesn't show up on an iPhone and even on iPadOS if only showed up when I made the text field in my test app smaller (narrower so it doesn't take up the full screen width). 

@Crazymuyang are you experiencing the same problem with UIKit text fields on iPadOS?

--
author:	Crazymuyang
association:	none
edited:	false
status:	none
--
> It looks like the "floating" number pad doesn't show up on an iPhone and even on iPadOS if only showed up when I made the text field in my test app smaller (narrower so it doesn't take up the full screen width).
> 
> [@Crazymuyang](https://github.com/Crazymuyang) are you experiencing the same problem with UIKit text fields on iPadOS?

I have not test with UIKit.
And you mean the problem is occured when the TextField is too small?
--
author:	LongCatIsLooong
association:	member
edited:	false
status:	none
--
> > It looks like the "floating" number pad doesn't show up on an iPhone and even on iPadOS if only showed up when I made the text field in my test app smaller (narrower so it doesn't take up the full screen width).
> > [@Crazymuyang](https://github.com/Crazymuyang) are you experiencing the same problem with UIKit text fields on iPadOS?
> 
> I have not test with UIKit. And you mean the problem is occured when the TextField is too small?

No the new floating numpad sometimes doesn't show up, I was just documenting in case someone else wants to repro.
--

    </comments>
  </issue>
  <issue id="180484">
    <title>[Android] `MediaQuery.viewInsetOf(context).bottom` discontinuity when opening the keyboard</title>
    <body>
### Steps to reproduce

- Create an app and align a fixed height container to the bottom of the safe area and add a textfield
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

I've attached two implementations (Flutter, Native) and two video captures to compare on the same device.
- The Android implementation has no jump
- The Flutter implementation has a jump the end of the animation

I've also logged `MediaQuery.viewInsetOf(context).bottom` and the values look like this:
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
Notice that after `288.0`, `296.0`, a jump occurs to `324.1904761904762`.
The 24 point jump also seems to be highly related to the height of the home indicator visible on the bottom when the keyboard is closed.


### System
Nothing OS 3.2
Nothing Phone 1
Android version 15


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
author:	PurplePolyhedron
association:	contributor
edited:	true
status:	none
--
Have you tried the code in profile or release mode? I have experienced lag when opening the keyboard in Android debug mode.
--
author:	intonarumori
association:	none
edited:	false
status:	none
--
Yes, I tested in release mode and it's the same result, pretty noticeable. The native version is smooth as butter.
--
author:	tirth-patel-nc
association:	member
edited:	false
status:	none
--
thanks for the report. Appears to be a duplicate of #19480 #167374 #116836. If you disagree write in comments and I'll reopen the issue.
--
author:	intonarumori
association:	none
edited:	false
status:	none
--
I've looked at those issues, I think they are related, but not duplicates.
--
author:	intonarumori
association:	none
edited:	false
status:	none
--
@tirth-patel-nc This issue is related to the ones you posted, but not a straight duplicate, please reopen.
--
author:	tirth-patel-nc
association:	member
edited:	false
status:	none
--
Thanks for the report. Seeing the same behaviour with latest SDK versions.

```
stable : 3.38.6
master : 3.40.0-1.0.pre-494
```
--
author:	HE-LU
association:	none
edited:	false
status:	none
--
@intonarumori I can confirm that I’m seeing the same issue on my end. I tested both the stable release (3.38.6) and master, and the behavior is consistent.

I also noticed an additional, less obvious behavior. As shown in your video, when the keyboard opens, the red bar becomes slightly cropped. I can reproduce this as well.

Additionally, when this happens very quickly—for example, when unfocusing on click and rapidly focusing/unfocusing the input, causing the software keyboard to open and close in quick succession—the behavior changes slightly. Instead of cropping the red bar, an empty space is added below it, shifting the entire bar slightly upward above the keyboard. This then settles once the keyboard is fully visible.

Could you please check whether you observe the same behavior during rapid keyboard show/hide cycles?
--
author:	loic-sharma
association:	member
edited:	true
status:	none
--
@intonarumori Could you expand on how this issue is different than https://github.com/flutter/flutter/issues/116836?

It looks like these issues have similar root causes, I suspect we should mark this one as a duplicate and copy your findings to that issue.
--

    </comments>
  </issue>
  <issue id="137817">
    <title>IOS Emoji Selection is Higher than English Character</title>
    <body>
### Is there an existing issue for this?

- [X] I have searched the [existing issues](https://github.com/flutter/flutter/issues)
- [X] I have read the [guide to filing a bug](https://flutter.dev/docs/resources/bug-reports)

### Steps to reproduce

1. On IOS device (IOS 17, Iphone 15 Pro simulator), select text with emojis on `SelectableText`, `SelectionArea` containing `Text` widget.

### Expected results

1. On Android device, height of highlighted area of emojis is same with english character, expecting same behaviour on IOS devices.
![image](https://github.com/flutter/flutter/assets/70849672/71cb609e-ad09-4574-83e6-4a6c8917eb3d)

### Actual results

1. On IOS device, highlighted area of emojis is higher than english character
![image](https://github.com/flutter/flutter/assets/70849672/8a96736e-bc14-4d22-a876-d35a033727e8)


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
      title: 'Flutter Text Selection Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Text Selection Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Text(
                'SelectableText',
              ),
              const SelectableText(
                'Hello, world! 😀 good!',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text('SelectionArea containing Text'),
              const SelectionArea(
                child: Text(
                  'Hello, world!😀 good!',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ));
  }
}

```

</details>


### Screenshots or Video

<details>
<summary>Screenshots / Video demonstration</summary>

[Upload media here]

</details>


### Logs

<details><summary>Logs</summary>

```console
[Paste your logs here]
```

</details>


### Flutter Doctor output

<details><summary>Doctor output</summary>

```console
[✓] Flutter (Channel stable, 3.13.9, on macOS 14.1 23B74 darwin-x64, locale en-GB)
[!] Android toolchain - develop for Android devices (Android SDK version 33.0.2)
    ✗ cmdline-tools component is missing
      Run `path/to/sdkmanager --install "cmdline-tools;latest"`
      See https://developer.android.com/studio/command-line for more details.
    ✗ Android license status unknown.
      Run `flutter doctor --android-licenses` to accept the SDK licenses.
      See https://flutter.dev/docs/get-started/install/macos#android-setup for more details.
[!] Xcode - develop for iOS and macOS (Xcode 15.0.1)
    ✗ CocoaPods installed but not working.
        You appear to have CocoaPods installed but it is not working.
        This can happen if the version of Ruby that CocoaPods was installed with is different from the one being used to invoke it.
        This can usually be fixed by re-installing CocoaPods.
      To re-install see https://guides.cocoapods.org/using/getting-started.html#installation for instructions.
[✓] Android Studio (version 2022.3)
[✓] VS Code (version 1.83.1)
[✓] Connected device (2 available)
[✓] Network resources

```

</details>

    </body>
    <comments>
author:	dam-ease
association:	member
edited:	false
status:	none
--
Hi @yuhangang. Thanks for filing this.
I can reproduce both issues on the latest `master` and `stable` channels following the steps highlighted above. This isn't peculiar either iOS 17 or Impeller, as I can reproduce on other iOS versions both with and without Impeller.


<details><summary>stable, master flutter doctor -v</summary>
<p>

```
[!] Flutter (Channel stable, 3.13.9, on macOS 14.0 23A344 darwin-arm64, locale
    en-NG)
    • Flutter version 3.13.9 on channel stable at
      /Users/damilolaalimi/sdks/flutter
    ! Warning: `dart` on your path resolves to
      /opt/homebrew/Cellar/dart/3.1.5/libexec/bin/dart, which is not inside your      current Flutter SDK checkout at /Users/damilolaalimi/sdks/flutter.
      Consider adding /Users/damilolaalimi/sdks/flutter/bin to the front of your      path.
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision d211f42860 (8 days ago), 2023-10-25 13:42:25 -0700
    • Engine revision 0545f8705d
    • Dart version 3.1.5
    • DevTools version 2.25.0
    • If those were intentional, you can disregard the above warnings; however
      it is recommended to use "git" directly to perform update checks and
      upgrades.

[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
    • Android SDK at /Users/damilolaalimi/Library/Android/sdk
    • Platform android-34, build-tools 34.0.0
    • ANDROID_HOME = /Users/damilolaalimi/Library/Android/sdk
    • Java binary at: /Applications/Android
      Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build
      17.0.6+0-17.0.6b802.4-9586694)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 15.0.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 15A507
    • CocoaPods version 1.12.1

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2022.2)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build
      17.0.6+0-17.0.6b802.4-9586694)

[!] Android Studio (version unknown)
    • Android Studio at /Users/damilolaalimi/Downloads/Android Studio
      Preview.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    ✗ Unable to determine Android Studio version.
    • Java version OpenJDK Runtime Environment (build
      17.0.7+0-17.0.7b1000.6-10550314)

[✓] VS Code (version 1.83.1)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.50.0

[✓] VS Code (version 1.83.1)
    • VS Code at /Users/damilolaalimi/Downloads/Visual Studio Code.app/Contents
    • Flutter extension version 3.50.0

[✓] Connected device (4 available)
    • sdk gphone64 arm64 (mobile) • emulator-5554             • android-arm64  •
      Android 14 (API 34) (emulator)
    • Damilola’s iPhone (mobile)  • 00008110-001964480AE1801E • ios            •
      iOS 17.0.2 21A351
    • macOS (desktop)             • macos                     • darwin-arm64   •
      macOS 14.0 23A344 darwin-arm64
    • Chrome (web)                • chrome                    • web-javascript •
      Google Chrome 118.0.5993.117

[!] Network resources
    ✗ A network error occurred while checking "https://github.com/": Operation
      timed out

! Doctor found issues in 3 categories.
``` 
```
[!] Flutter (Channel master, 3.16.0-21.0.pre.42, on macOS 14.0 23A344 darwin-arm64, locale en-NG)
    • Flutter version 3.16.0-21.0.pre.42 on channel master at /Users/damilolaalimi/fvm/versions/master
    ! Warning: `flutter` on your path resolves to /Users/damilolaalimi/sdks/flutter/bin/flutter, which is not inside your current Flutter SDK checkout at /Users/damilolaalimi/fvm/versions/master. Consider adding /Users/damilolaalimi/fvm/versions/master/bin to the front of your path.
    ! Warning: `dart` on your path resolves to /opt/homebrew/Cellar/dart/3.1.5/libexec/bin/dart, which is not inside your current Flutter SDK checkout at /Users/damilolaalimi/fvm/versions/master. Consider adding /Users/damilolaalimi/fvm/versions/master/bin to the front of your path.
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision f7d1b35dca (3 hours ago), 2023-11-02 03:21:43 -0400
    • Engine revision 3c1e8f457e
    • Dart version 3.3.0 (build 3.3.0-87.0.dev)
    • DevTools version 2.29.0
    • If those were intentional, you can disregard the above warnings; however it is recommended to use "git" directly to perform update checks and upgrades.

[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
    • Android SDK at /Users/damilolaalimi/Library/Android/sdk
    • Platform android-34, build-tools 34.0.0
    • ANDROID_HOME = /Users/damilolaalimi/Library/Android/sdk
    • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 17.0.6+0-17.0.6b802.4-9586694)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 15.0.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 15A507
    • CocoaPods version 1.12.1

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2022.2)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 17.0.6+0-17.0.6b802.4-9586694)

[!] Android Studio (version unknown)
    • Android Studio at /Users/damilolaalimi/Downloads/Android Studio Preview.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    ✗ Unable to determine Android Studio version.
    • Java version OpenJDK Runtime Environment (build 17.0.7+0-17.0.7b1000.6-10550314)

[✓] VS Code (version 1.83.1)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.50.0

[✓] VS Code (version 1.83.1)
    • VS Code at /Users/damilolaalimi/Downloads/Visual Studio Code.app/Contents
    • Flutter extension version 3.50.0

[✓] Connected device (3 available)
    • Damilola’s iPhone (mobile) • 00008110-001964480AE1801E • ios            • iOS 17.0.2 21A351
    • macOS (desktop)            • macos                     • darwin-arm64   • macOS 14.0 23A344 darwin-arm64
    • Chrome (web)               • chrome                    • web-javascript • Google Chrome 118.0.5993.117

[✓] Network resources
    • All expected network resources are available.

! Doctor found issues in 2 categories.
exit code 0
``` 

</p>
</details> 
--
author:	vashworth
association:	member
edited:	false
status:	none
--
Framework team - Is the height of the selection controlled by the framework?
--
author:	vashworth
association:	member
edited:	false
status:	none
--
@yuhangang Can you file a separate issue for the drag selection issue you describe in Action Results > 2?
--
author:	yuhangang
association:	none
edited:	true
status:	none
--
@vashworth done, and renamed the current issue

https://github.com/flutter/flutter/issues/137976
--
author:	jmagman
association:	member
edited:	false
status:	none
--
> Framework team - Is the height of the selection controlled by the framework?

Maybe text-input team knows?
--
author:	Renzo-Olivares
association:	member
edited:	false
status:	none
--
Hi @yuhangang, the style of the selection height and width is configurable through `SelectableText.selectionHeightStyle` and `SelectableText.selectionWidthStyle`. `TextField` also has these members, but `Text` widgets under a `SelectionArea` do not have these as configurable yet. By default `TextField` and `SelectableText` default these values to [`BoxHeightStyle.tight`](https://api.flutter.dev/flutter/dart-ui/BoxHeightStyle.html) which is the behavior you are experiencing on iOS, but it is strange that this differs from the Android behavior. cc @LongCatIsLooong @justinmc for any insight.

You can achieve a more consistent behavior using `BoxSelectionHeightStyle.max` for the `selectionHeightStyle`, but this does increase the size of the highlight.

https://github.com/flutter/flutter/assets/948037/e2b53aba-3a1d-403c-adbd-fa64319ed52e
- Running on iOS simulator
--
author:	lucky1213
association:	none
edited:	true
status:	none
--
@Renzo-Olivares 
Can the selectionHeightStyle parameter be added to SelectionArea?

--
author:	flutter-triage-bot
association:	none
edited:	false
status:	none
--
This issue is assigned to @Renzo-Olivares but has had no recent status updates. Please consider unassigning this issue if it is not going to be addressed in the near future. This allows people to have a clearer picture of what work is actually planned. Thanks!
--

    </comments>
  </issue>
</collection>

