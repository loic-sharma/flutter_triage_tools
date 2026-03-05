<instructions>
Summarize each of the following GitHub issues and pull requests.

Suggest a title for each, in sentence case. If the issue is specific to a
platform, prefix the title with the platform name, e.g. "[Android]" or "[iOS]".

If the issue has a screenshot or video, include a link to it. Ensure there is
an empty line before each screenshot/video URL.
</instructions>

<example_output>

# [Android] Backspace is not sent to TextField

**Link**: [flutter#123](https://github.com/flutter/flutter/issues/123)

**Summary**: When Backspace is pressed on a virtual keyboard of certain Samsung
devices, the keypress is not sent to the TextField. This appears to be a bug in
`_HighlightModeManager`: it assumes all `KeyMessage`s are physical key presses,
however, Android's backspace virtual key can send a `KeyMessage`.

**Screenshot or video**:

https://github.com/user-attachments/assets/abc

https://github.com/user-attachments/assets/xyz

</example_output>

<collection>
  <pull_request id="183112">
    <title>Fix emoji insertion corruption by using grapheme-aware text operations</title>
    <body>
Fixes a bug where inserting emojis between existing emojis in an RTL `TextField` on Android would break the text and render `?` characters. The root cause was that the Android IME sends text updates using UTF-16 code unit positions, which can split surrogate pairs when the cursor is placed between emoji characters.

### Changes made:

- **`TextEditingValue.replaced()`** — Updated to use grapheme cluster boundaries instead of raw UTF-16 code unit positions, preventing surrogate pair splits during text replacement.
- **`TextInput._validateAndCorrectTextEditingValue()`** — New method that detects and fixes broken surrogate pairs received from the Android IME before they reach the text input client.
- **`_handleTextInputInvocation()`** — Now intercepts platform text updates and applies the correction above before forwarding to the text input client.

### Before / After:

| | Before fix | After fix |
|---|---|---|
| **Behavior** | Inserting emoji between emojis in RTL TextField renders `?` and breaks text | Emoji inserts correctly without breaking surrounding characters |
<table>
  <tr>
    <td align="center">
      <b>Before fix</b><br>
      <video src="https://github.com/user-attachments/assets/701c78cb-f2c0-4cec-91fc-455f9490a6c3" width="350" controls></video>
    </td>
    <td align="center">
      <b>After fix</b><br>
      <video src="https://github.com/user-attachments/assets/409cfbd2-ecae-4368-b508-fe674f43f8a2" width="350" controls></video>
    </td>
  </tr>
</table>

Fixes https://github.com/flutter/flutter/issues/181759

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [x] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [x] All existing and new tests are passing.

If you need help, consider asking for advice on the #hackers-new channel on [Discord].

**Note**: The Flutter team is currently trialing the use of [Gemini Code Assist for GitHub](https://developers.google.com/gemini-code-assist/docs/review-github-code). Comments from the `gemini-code-assist` bot should not be taken as authoritative feedback from the Flutter team.


<!-- Links -->
[Contributor Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#overview
[Tree Hygiene]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
[test-exempt]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#tests
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
[Features we expect every widget to implement]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md#features-we-expect-every-widget-to-implement
[CLA]: https://cla.developers.google.com/
[flutter/tests]: https://github.com/flutter/tests
[breaking change policy]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#handling-breaking-changes
[Discord]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md
[Data Driven Fixes]: https://github.com/flutter/flutter/blob/main/docs/contributing/Data-driven-Fixes.md
    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![high](https://www.gstatic.com/codereviewagent/high-priority.svg)

The logic to find the inserted character fails if the inserted character already exists in the string. For example, if the user inserts 'a' into "banana", `previousChars.contains(char)` will be true, and the inserted character will not be detected. A more robust approach is to account for character counts.

```dart
      var insertedText = '';
      final Map<String, int> previousCharCounts = <String, int>{};
      for (final String char in previousChars) {
        previousCharCounts[char] = (previousCharCounts[char] ?? 0) + 1;
      }

      for (final String char in currentChars) {
        if (char == '?' || char == '\uFFFD') {
          continue;
        }
        final int? count = previousCharCounts[char];
        if (count == null || count == 0) {
          // This character is new.
          insertedText = char;
          break;
        }
        previousCharCounts[char] = count - 1;
      }
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

The `while` loop to find `graphemeEnd` uses `characters.elementAt(graphemeEnd)`, which can be inefficient for long strings as `elementAt` on an `Iterable` has O(N) complexity. This makes the loop O(N^2) in the number of graphemes in the replacement range. Using an iterator would be more performant.

```dart
    // Find the grapheme that contains replacementRange.end
    var graphemeEnd = graphemeStart;
    final Iterator<String> it = characters.skip(graphemeStart).iterator;
    while (codeUnitCount < replacementRange.end && it.moveNext()) {
      codeUnitCount += it.current.length;
      graphemeEnd++;
    }
```
      </comment>
      <comment author="Istiak-Ahmed78">
Fixed in the latest commit.
      </comment>
      <comment author="Istiak-Ahmed78">
Fixed in the latest commit.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="183110">
    <title>Fix SelectableText right-click selecting word on web/desktop</title>
    <body>
On macOS and web, right-clicking on `SelectableText` selects the word at the click position. This is incorrect for a read-only text widget where selection should only occur through deliberate gestures (tap-drag, double-tap, long press).

## Root Cause

`_SelectableTextSelectionGestureDetectorBuilder` in `selectable_text.dart` overrides `onSingleTapUp` but not `onSecondaryTap`. When a right-click occurs, the base class implementation in `TextSelectionGestureDetectorBuilder.onSecondaryTap` runs directly, which calls `renderEditable.selectWord()` on macOS/iOS when there is no existing selection at the tap point.

## Fix

Add an `onSecondaryTap` override in `_SelectableTextSelectionGestureDetectorBuilder` that skips word selection. Since `SelectableText` is read-only, right-clicking should not expand the selection. The toolbar is shown only if text is already selected.

This PR implements the analysis from [my earlier comment](https://github.com/flutter/flutter/issues/181833#issuecomment-3977030774) on this issue.

Fixes #181833

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [x] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [x] All existing and new tests are passing.

If you need help, consider asking for advice on the #hackers-new channel on [Discord].

**Note**: The Flutter team is currently trialing the use of [Gemini Code Assist for GitHub](https://developers.google.com/gemini-code-assist/docs/review-github-code). Comments from the `gemini-code-assist` bot should not be taken as authoritative feedback from the Flutter team. If you find its comments useful you can update your code accordingly, but if you are unsure or disagree with the feedback, please feel free to wait for a Flutter team member's review for guidance on which automated comments should be addressed.

<!-- Links -->
[Contributor Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#overview
[Tree Hygiene]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
[test-exempt]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#tests
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
[Features we expect every widget to implement]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md#features-we-expect-every-widget-to-implement
[CLA]: https://cla.developers.google.com/
[flutter/tests]: https://github.com/flutter/tests
[breaking change policy]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#handling-breaking-changes
[Discord]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md
[Data Driven Fixes]: https://github.com/flutter/flutter/blob/main/docs/contributing/Data-driven-Fixes.md
    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

This test correctly verifies that the selection doesn't change on a right-click. To make it more complete and align with its description ('Right-click shows toolbar...'), consider also asserting that the selection toolbar is visible after the right-click.

```dart
      // The selection should remain unchanged.
      expect(state.textEditingValue.selection.baseOffset, 4);
      expect(state.textEditingValue.selection.extentOffset, 7);

      // The toolbar should be visible.
      expect(find.text('Copy'), findsOneWidget);
```
      </comment>
      <comment author="ishaquehassan">
Great suggestion! I've made two improvements based on your feedback:

1. **Added toolbar visibility assertion** — added `expect(find.text('Copy'), findsOneWidget)` after the right-click to verify the toolbar is actually shown, making the test complete and true to its description.

2. **Improved the implementation** — replaced the `shouldShowSelectionToolbar` flag check with a direct check on the actual selection state (`selection.isValid && !selection.isCollapsed`). This is more reliable since `shouldShowSelectionToolbar` can be affected by prior gesture state, whereas checking the actual selection value is always accurate.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="183074">
    <title>Replace BorderRadius.circular with const BorderRadius.all and update documentation examples</title>
    <body>
This PR replaces usages of `BorderRadius.circular(double radius)` with `const BorderRadius.all(Radius.circular(radius))` (and similarly for `BorderRadiusDirectional` and `BorderRadiusGeometry`) to improve code consistency and enable const constructors where applicable.

Additionally, all code examples in the documentation have been updated to reflect this pattern, ensuring that developers see the recommended style.

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [ ] I listed at least one issue that this PR fixes in the description above.
- [ ] I updated/added relevant documentation (doc comments with `///`).
- [ ] I added new tests to check the change I am making, or this PR is [test-exempt].
- [ ] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [ ] All existing and new tests are passing.

If you need help, consider asking for advice on the #hackers-new channel on [Discord].

**Note**: The Flutter team is currently trialing the use of [Gemini Code Assist for GitHub](https://developers.google.com/gemini-code-assist/docs/review-github-code). Comments from the `gemini-code-assist` bot should not be taken as authoritative feedback from the Flutter team. If you find its comments useful you can update your code accordingly, but if you are unsure or disagree with the feedback, please feel free to wait for a Flutter team member's review for guidance on which automated comments should be addressed.

<!-- Links -->
[Contributor Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#overview
[Tree Hygiene]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
[test-exempt]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#tests
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
[Features we expect every widget to implement]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md#features-we-expect-every-widget-to-implement
[CLA]: https://cla.developers.google.com/
[flutter/tests]: https://github.com/flutter/tests
[breaking change policy]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#handling-breaking-changes
[Discord]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md
[Data Driven Fixes]: https://github.com/flutter/flutter/blob/main/docs/contributing/Data-driven-Fixes.md

    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `InputDecoration` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```dart
              borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `ProgressIndicatorThemeData` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```dart
        borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

`_upperRectRadius` is an instance field, so it cannot be used inside a `const` expression. Please remove the `const` keyword here.

```dart
      BorderRadius.all(Radius.circular(_upperRectRadius)),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `data` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```suggestion
    const data = MediaQueryData(displayCornerRadii: const BorderRadius.all(Radius.circular(33)));
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `BoxDecoration` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```suggestion
        const BoxDecoration(borderRadius: const BorderRadiusDirectional.all(Radius.circular(100.0))),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `InputDecoration` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```dart
              borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since the parent `InputDecorator` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```dart
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `decoration` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```suggestion
    const decoration = BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(radius)));
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since the parent `InputDecorator` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```dart
                        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `TabBarTheme` is `const`, its `data` property must be a compile-time constant. Please add `const` to `BorderRadius.all`.

```dart
              data: TabBarThemeData(splashBorderRadius: const BorderRadius.all(Radius.circular(radius))),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `PopupMenuThemeData` is `const`, the value for `shape` must be a compile-time constant. The `borderRadius` property of `RoundedRectangleBorder` needs a `const` value.

```suggestion
      shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `PopupMenuThemeData` is `const`, the value for `shape` must be a compile-time constant. The `borderRadius` property of `RoundedRectangleBorder` needs a `const` value.

```suggestion
      shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10))),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

The values in a `const` map must be compile-time constants. You need to add the `const` keyword before `BorderRadius.all` for this to compile.

```dart
      CupertinoButtonSize.small: const BorderRadius.all(Radius.circular(40)),
      CupertinoButtonSize.medium: const BorderRadius.all(Radius.circular(40)),
      CupertinoButtonSize.large: const BorderRadius.all(Radius.circular(12)),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `ProgressIndicatorThemeData` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```dart
                  borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Since `ProgressIndicatorThemeData` is `const`, this expression must also be a compile-time constant. Please add `const` here.

```dart
        borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

The `shape` and `iconButtonStyle` can be `const`. To do this, you'll need to add `const` before `RoundedRectangleBorder` and `ButtonStyle`, and remove the `const` from `MaterialStatePropertyAll` since it will be inferred.

```dart
    const shape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)));
    const iconButtonStyle = ButtonStyle(
      backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
      foregroundColor: MaterialStatePropertyAll<Color>(foregroundColor),
      overlayColor: MaterialStatePropertyAll<Color>(overlayColor),
      shadowColor: MaterialStatePropertyAll<Color>(shadowColor),
      elevation: MaterialStatePropertyAll<double>(elevation),
      shape: MaterialStatePropertyAll<OutlinedBorder>(shape),
    );
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

There seems to be a typo here. `BorderRadius.radius` does not exist. It should probably be `BorderRadius.all` to be consistent with the other changes.

```dart
  /// * `shape` - RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(4)))
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

The `shape` and `iconButtonStyle` can be `const`. To do this, you'll need to add `const` before `RoundedRectangleBorder` and `ButtonStyle`, and remove the `const` from `MaterialStatePropertyAll` since it will be inferred.

```dart
    const shape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)));
    const iconButtonStyle = ButtonStyle(
      backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
      foregroundColor: MaterialStatePropertyAll<Color>(foregroundColor),
      overlayColor: MaterialStatePropertyAll<Color>(overlayColor),
      shadowColor: MaterialStatePropertyAll<Color>(shadowColor),
      elevation: MaterialStatePropertyAll<double>(elevation),
      shape: MaterialStatePropertyAll<OutlinedBorder>(shape),
    );
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

To fully leverage `const` constructors, you should add `const` here. This will allow the `VerticalDivider` and `Center` widgets to be constructed as constants.

```suggestion
        child: Center(child: VerticalDivider(radius: const BorderRadius.all(Radius.circular(5)))),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

To fully leverage `const` constructors, you should add `const` here. This will allow the `Divider` and `Center` widgets to be constructed as constants.

```suggestion
        child: Center(child: Divider(radius: const BorderRadius.all(Radius.circular(5)))),
```
      </comment>
      <comment author="BrainLUX">
Unnecessary since InputDecoration is already marked as const
      </comment>
      <comment author="BrainLUX">
Unnecessary since ProgressIndicatorThemeData is already marked as const
      </comment>
      <comment author="BrainLUX">
_upperRectRadius is a const field
      </comment>
      <comment author="BrainLUX">
Unnecessary since data is already marked as const
      </comment>
      <comment author="BrainLUX">
Unnecessary since BoxDecoration is already marked as const
      </comment>
      <comment author="BrainLUX">
Unnecessary since InputDecoration is already marked as const
      </comment>
      <comment author="BrainLUX">
Unnecessary since RepaintBoundary is already marked as const
      </comment>
      <comment author="BrainLUX">
Unnecessary since decoration is already marked as const
      </comment>
      <comment author="BrainLUX">
Unnecessary since RepaintBoundary is already marked as const
      </comment>
      <comment author="BrainLUX">
Unnecessary since DefaultTabController is already marked as const
      </comment>
    </comments>
  </pull_request>
  <pull_request id="182920">
    <title>TextField: add code-point mode for maxLength counting</title>
    <body>
Part of #182907

## Problem
`TextField.maxLength` currently counts user-perceived grapheme clusters only. Some apps need client-side validation based on Unicode code points to match server-side constraints.

## Fix
- Add `MaxLengthCountType` with:
  - `characters` (default, existing behavior)
  - `codePoints`
- Extend `LengthLimitingTextInputFormatter` with `maxLengthCountType` and use it for:
  - counting current length
  - truncation behavior
  - max-length enforcement checks
- Add `TextField.maxLengthCountType` and wire it into:
  - intrinsic error state
  - counter display
  - internal `LengthLimitingTextInputFormatter`

## Impact
- Existing apps keep current behavior by default.
- Apps can opt into code-point counting to align with backend validation rules.
- Counter and enforcement remain consistent under the selected counting mode.

## Validation
- `./bin/flutter --suppress-analytics test packages/flutter/test/services/text_formatter_test.dart --plain-name "Can count as Unicode code points"`
- `./bin/flutter --suppress-analytics test packages/flutter/test/services/text_formatter_test.dart --plain-name "Can enforce maxLength using code points"`
- `./bin/flutter --suppress-analytics test packages/flutter/test/material/text_field_test.dart --plain-name "maxLength counter can measure Unicode code points"`
- All passed.

    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

For better readability, this boolean expression can be simplified. The current ternary operator makes the condition harder to understand at a glance. A simplified version using logical AND (`&&`) and OR (`||`) would be more direct and align with the style guide's emphasis on readability.

```dart
      (_currentLength > widget.maxLength!) && (widget.controller != null || !restorePending);
```

<details>
<summary>References</summary>

1. Line 29: Optimize for readability: Code is read more often than it is written. <sup>([link](https://github.com/flutter/flutter/blob/master/.gemini/styleguide.md))</sup>
</details>
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

The current test case with `const familyEmoji = '👨👩👦';` uses a string that has 3 characters and 3 code points. This doesn't effectively test the difference between `MaxLengthCountType.characters` and `MaxLengthCountType.codePoints`. A stronger test case would use a string where these two counts differ, for example, a character with a combining mark. This would ensure the new counting logic is correctly exercised.

```dart
    const combiningChars = 'o\u0308'; // 1 character, 2 code points
    await tester.enterText(find.byType(TextField), combiningChars);
    await tester.pump();

    expect(find.text('2/10'), findsOneWidget);
```

<details>
<summary>References</summary>

1. Line 11: Code should be tested and follow the guidance described in the writing effective tests guide. <sup>([link](https://github.com/flutter/flutter/blob/master/.gemini/styleguide.md))</sup>
</details>
      </comment>
    </comments>
  </pull_request>
  <pull_request id="182870">
    <title>Add await or ignore lint to invokeMethod callsites</title>
    <body>
Part of https://github.com/flutter/flutter/pull/181513
    </body>
    <comments>
      <comment author="victorsanni">
I didn't add `await` here because I'm wondering if the `Timer` is evidence the exclusion is intentional?
      </comment>
      <comment author="victorsanni">
Same with the `Timer` here?
      </comment>
      <comment author="victorsanni">
Changing the signature of a public method? Should we ignore instead?
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Using `await` here is incorrect. The `expect` function is designed to work with `Future`s directly when using matchers like `throwsA`. When you `await` a `Future` that is expected to throw, the exception is thrown before `expect` can catch and test it, leading to an unhandled exception and a failed test. The original code was correct. Please remove the `await`.

```suggestion
      expect(channel.invokeMethod<List<String>>('sayHello', 'hello'), throwsA(isA<TypeError>()));
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

Similar to the previous comment, using `await` here is incorrect. The `Future` should be passed directly to `expect` when testing for exceptions with `throwsA`. Please remove the `await`.

```suggestion
        channel.invokeMethod<Map<String, String>>('sayHello', 'hello'),
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![high](https://www.gstatic.com/codereviewagent/high-priority.svg)

Changing `_setUndoState` to be `async` is a good improvement. However, this introduces an `unawaited_futures` lint warning at its call site in the public static method `setUndoState`. To complete this change, `setUndoState` should also be updated to be `async` and `await` this call. This would be a breaking change to a public API, so please ensure this is intended.

```dart
static Future<void> setUndoState({bool canUndo = false, bool canRedo = false}) async {
  await _instance._setUndoState(canUndo: canUndo, canRedo: canRedo);
}
```

If a breaking change is not intended, it would be better to keep `_setUndoState` synchronous and add an `// ignore: unawaited_futures` comment to the `invokeMethod` call, similar to other changes in this PR.
      </comment>
      <comment author="victorsanni">
Added ignore because this is in a microtask?
      </comment>
      <comment author="victorsanni">
Added ignore here (and elsewhere in this file) because awaiting will require changing the method signature
      </comment>
      <comment author="victorsanni">
awaiting will mean changing method signature?
      </comment>
      <comment author="dkwingsmt">
I think this is ok since this method can't be overridden. The worst that can happen is that apps will get new lint warnings for unwaited futures.
      </comment>
      <comment author="dkwingsmt">
Unawaited futures in production code should be reported to FlutterError in a `.catch`.
      </comment>
      <comment author="dkwingsmt">
Similarly, report to `FlutterError` in a `.catch`.
      </comment>
      <comment author="dkwingsmt">
The current change simply moves the `unawaited_futures` warning to `setUndoState`. We should either change `setUndoState`'s return value, or report the error in a `.catch`.
      </comment>
      <comment author="dkwingsmt">
Yeah we probably don't want to break it. Report the error in `.catch` then.
      </comment>
      <comment author="dkwingsmt">
This probably breaks. Report the error in `.catch` instead.
      </comment>
      <comment author="dkwingsmt">
This might be the same case as above. Simply removes `() =>` might work.
      </comment>
      <comment author="victorsanni">
It has a `catchError` already, so we don't need to do anything here.
      </comment>
      <comment author="dkwingsmt">
Are you saying `Timer` should also be awaited? I don't think so...
      </comment>
      <comment author="dkwingsmt">
I'd be surprised if this is even allowed. If it is, we should somehow have a lint that avoids assigning `Future<void> ()` to `void ()`.

This `invokeMethod` should report errors in a `catchError` instead.
      </comment>
      <comment author="dkwingsmt">
All errors in this file should be reported instead of ignored.
      </comment>
      <comment author="dkwingsmt">
Report instead of ignore.
      </comment>
      <comment author="dkwingsmt">
Same as above.
      </comment>
      <comment author="dkwingsmt">
The `catchError` only ignores `MissingPluginException` and does not report other errors.

We should keep `_onFocusChange`'s return type `void` (and hence removing `async`, because `Focus` does not process `_onFocusChange`'s returning future.

The two `catchError`s should report the error to `FlutterError` in their `else` branch.
      </comment>
      <comment author="dkwingsmt">
Likewise: Keep the return value `void`, remove `async`, and report the future error in `catchError`.
      </comment>
      <comment author="victorsanni">
My understanding is `Timer` is used to lag the function calls, but I am not sure if the intention is to lag from the moment the Future is scheduled or from when it completes.
      </comment>
      <comment author="victorsanni">
But we do this below: https://github.com/flutter/flutter/pull/182870/changes#r2850174911
      </comment>
      <comment author="dkwingsmt">
I see your point. I think it doesn't matter here since it's in a test where we're safe to ignore all futures. So the current change is good by adding ignore to both `invokeMethod`. Or is there any other concern you're talking about?
      </comment>
      <comment author="dkwingsmt">
First, for `startLiveTextInput`, there are two ways to design its API.
* Either we make `startLiveTextInput` return void, indicating that code who uses it is not allowed to know the result of this `startLiveTextInput` call and `startLiveTextInput` should report to `FlutterError` in a `catchError` within itself.
* Or we make `startLiveTextInput` return a future, indicating that code who uses it is responsible of handling the result of this `startLiveTextInput` call, and is recommended to report to `FlutterError` in a `catchError` after this call.

We're making a design decision here, because we can choose how users should handle it. What I suggested in that comment suggested the 2nd choice, although I'm ok with either. If we choose the 2nd choice, we should make sure our own invocations process the errors - there's exactly one use in `editable_text.dart`.

As for `_handleWebFirstFrame` (and other similar cases below), the callback is handled by an API that does not handle the async result at all (in this case, `addPostFrameCallback`; in other cases, `Focus`). Therefore we have to choose the 1st way and provide a callback that handles these errors.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="182752">
    <title>Respect per-field autovalidateMode priority</title>
    <body>
Implemented a hierarchical validation logic: `FormField.autovalidateMode` now takes precedence over the parent `Form` settings. If the field-level mode is unspecified, it inherits the form-level configuration, with a final fallback to `AutovalidateMode.disabled`.

Fixes flutter/flutter#125766

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [ ] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [x] All existing and new tests are passing.

If you need help, consider asking for advice on the #hackers-new channel on [Discord].

**Note**: The Flutter team is currently trialing the use of [Gemini Code Assist for GitHub](https://developers.google.com/gemini-code-assist/docs/review-github-code). Comments from the `gemini-code-assist` bot should not be taken as authoritative feedback from the Flutter team. If you find its comments useful you can update your code accordingly, but if you are unsure or disagree with the feedback, please feel free to wait for a Flutter team member's review for guidance on which automated comments should be addressed.

<!-- Links -->
[Contributor Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#overview
[Tree Hygiene]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
[test-exempt]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#tests
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
[Features we expect every widget to implement]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md#features-we-expect-every-widget-to-implement
[CLA]: https://cla.developers.google.com/
[flutter/tests]: https://github.com/flutter/tests
[breaking change policy]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#handling-breaking-changes
[Discord]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md
[Data Driven Fixes]: https://github.com/flutter/flutter/blob/main/docs/contributing/Data-driven-Fixes.md

    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![high](https://www.gstatic.com/codereviewagent/high-priority.svg)

The documentation for `autovalidateMode` appears to contradict the implementation in `_effectiveAutovalidateMode` and the pull request's description. The implementation correctly gives precedence to `FormField.autovalidateMode`, but this documentation states the opposite, which could be misleading for developers.

To ensure clarity and accuracy, I recommend updating the documentation to reflect the actual behavior.

```dart
  /// If not null, this `autovalidateMode` takes precedence over the [Form]'s
  /// `autovalidateMode`. If null, the form's `autovalidateMode` is used.
  ///
  /// If both are null, this defaults to [AutovalidateMode.disabled].
```

<details>
<summary>References</summary>

1. Documentation should be useful and accurately describe the code's behavior. The current documentation for `autovalidateMode` is misleading as it doesn't match the implementation. <sup>([link](https://github.com/flutter/flutter/blob/master/.gemini/styleguide.md))</sup>
</details>
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

The nested `switch` statement within the `when` clause appears to be redundant. Since the outer `switch` already establishes that `_effectiveAutovalidateMode` is `AutovalidateMode.onUnfocus`, the inner `switch` on the same variable will always evaluate to `true` within this case.

Refactoring this to remove the nested `switch` would make the code clearer and more concise.

```dart
    return switch (_effectiveAutovalidateMode) {
      AutovalidateMode.onUnfocus =>
        Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onFocusChange: (bool value) {
            if (!value) {
              setState(_validate);
            }
          },
          focusNode: _focusNode,
          child: child,
        ),
      _ => child,
    };
```

<details>
<summary>References</summary>

1. Code should be optimized for readability. The nested switch statement is confusing and can be simplified to make the logic easier to understand. <sup>([link](https://github.com/flutter/flutter/blob/master/.gemini/styleguide.md))</sup>
</details>
      </comment>
      <comment author="justinmc">
I thought Form.autovalidateMode was non nullable?
      </comment>
      <comment author="justinmc">
I find the addition of the `validation` parameter here to be confusing. Reading the comments on _FormValidation doesn't really help, and just from reading that it's not clear that it is only for the _validate method.

What if it was just a bool? `useFieldAutovalidateMode = true` or something.
      </comment>
      <comment author="justinmc">
This is a great abstraction of important logic 👍 
      </comment>
      <comment author="justinmc">
This is nice.
      </comment>
      <comment author="justinmc">
Can you explain the concern you had in your comment https://github.com/flutter/flutter/pull/180822#discussion_r2836622700 where setState can't be called in `validate` and how that appears in this PR? I see that we no longer use addPostFrameCallback here, but anyway, I think it's not possible to call setState inside of `validate` in most scenarios on master right now anyway.
      </comment>
      <comment author="Mairramer">
I believe a boolean would be appropriate here. The logic is reused from the earlier PR.
      </comment>
      <comment author="Mairramer">
The problem was related to the `TimePicker`. Because it invokes setState within its validator, I needed to explicitly set `autovalidateMode: AutovalidateMode.disabled `after removing it from the `TextFormField`.
      </comment>
      <comment author="Mairramer">
Although the parameter is nullable, the stored value is never null.
The constructor normalizes it using a fallback:
 ```dart
 AutovalidateMode? autovalidateMode,
 }) : autovalidateMode = autovalidateMode ?? AutovalidateMode.disabled,
 ```
Intentionally left unchanged for now.

      </comment>
      <comment author="justinmc">
Is this logic wrong or is it me? I would think it should be:

```dart
if (useFieldAutovalidateMode && !field._shouldValidate) {
  continue;
}
```
      </comment>
      <comment author="Mairramer">
Yes, that’s correct. Maybe only the name sounds a bit odd.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="182728">
    <title>Enable inline text prediction on iOS (issue #135221)</title>
    <body>
**Description**

This PR adds support for **inline predictive text** on iOS 17+ (the gray suggestion that appears after the cursor as you type). It does two things:

1. **Enable/disable inline prediction** – Apps can turn inline prediction on or off per field via a new `enableInlinePrediction` parameter on `TextField` and `CupertinoTextField` (default remains `true`). The setting is sent through `TextInputConfiguration` to the engine, which sets `UITextInlinePredictionType` on the iOS text input view so the system shows or hides inline suggestions.

2. **Style the prediction/composing region** – A new optional `composingStyle` parameter lets apps control how the composing range (IME and inline prediction) is drawn. When set (e.g. gray with no underline), the suggestion can match the native iOS look instead of the default underline.

**Why:** On iOS 17+, the system keyboard can show inline predictions; Flutter had no way to enable/disable this or style the suggestion text. This change adds that control and styling so Flutter apps can match platform behavior and design.

**Technical notes:**  
- Framework: `TextInputConfiguration.enableInlinePrediction`, `EditableText`/`TextField`/`CupertinoTextField` pass-through, and `TextEditingController.buildTextSpan(composingStyle)` for the composing region.  
- Engine (iOS only): read `enableInlinePrediction` in `configureWithDictionary:`, set `FlutterTextInputView.inlinePredictionType`, and implement `setAttributedMarkedText:selectedRange:` so the system can deliver inline prediction. Semantics objects updated for the same protocol.  
- Other platforms are unchanged: they ignore the new config; `composingStyle` only affects how the composing range is drawn.

Consider adding before/after screenshots: one with inline prediction off or default underline, one with `enableInlinePrediction: true` and a custom `composingStyle` (e.g. gray, no underline) to show the new behavior.

---

**Fixes** #135221

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [x] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [x] All existing and new tests are passing.

If you need help, consider asking for advice on the #hackers-new channel on [Discord].

**Note**: The Flutter team is currently trialing the use of [Gemini Code Assist for GitHub](https://developers.google.com/gemini-code-assist/docs/review-github-code). Comments from the `gemini-code-assist` bot should not be taken as authoritative feedback from the Flutter team. If you find its comments useful you can update your code accordingly, but if you are unsure or disagree with the feedback, please feel free to wait for a Flutter team member's review for guidance on which automated comments should be addressed.

<!-- Links -->
[Contributor Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#overview
[Tree Hygiene]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
[test-exempt]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#tests
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
[Features we expect every widget to implement]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md#features-we-expect-every-widget-to-implement
[CLA]: https://cla.developers.google.com/
[flutter/tests]: https://github.com/flutter/tests
[breaking change policy]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#handling-breaking-changes
[Discord]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md
[Data Driven Fixes]: https://github.com/flutter/flutter/blob/main/docs/contributing/Data-driven-Fixes.md

    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

The test asserts that the marked range length is 18, but the input string `"inline prediction"` has a length of 17. This appears to be a typo in the test. The length of the marked range should match the length of the string from the `NSAttributedString`.

```
  XCTAssertEqual(markedRange.range.length, 17ul);
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

This logic for determining the `effectiveComposingStyle` can be simplified for better readability, which aligns with the style guide's emphasis on optimizing for readability.

```dart
    final TextStyle finalComposingStyle = composingStyle ?? const TextStyle(decoration: TextDecoration.underline);
    final TextStyle effectiveComposingStyle = style?.merge(finalComposingStyle) ?? finalComposingStyle;
```

<details>
<summary>References</summary>

1. Code should be optimized for readability, as it is read more often than it is written. <sup>([link](https://github.com/flutter/flutter/blob/master/.gemini/styleguide.md))</sup>
</details>
      </comment>
      <comment author="LongCatIsLooong">
Is it supposed to be NSValue here?
      </comment>
      <comment author="LongCatIsLooong">
What about default? 
      </comment>
      <comment author="LongCatIsLooong">
This will likely be a breaking change (based on my past attempts to add new parameters to this method). 
      </comment>
      <comment author="LongCatIsLooong">
Document which platforms support it (or something like "Whether to enable inline predictive text on iOS").
      </comment>
      <comment author="LongCatIsLooong">
nit: underlined -> [TextDecoration.underline] 
      </comment>
      <comment author="LongCatIsLooong">
This doesn't seem to have to do with text predication?
      </comment>
      <comment author="nikb7">
the config value is a boolean from the channel, hence NSNumber. Tested this flow locally as well to validate this behaviour
      </comment>
      <comment author="nikb7">
updated
      </comment>
      <comment author="nikb7">
updated
      </comment>
      <comment author="nikb7">
platform default behaviour will be default - and null/no value will be considered as default
      </comment>
      <comment author="hellohuanlin">
I'm surprised that `setMarkedText` works out of box. Is the inline predictive text eventually rendered by the framework or iOS system?
      </comment>
      <comment author="nikb7">
is it eventually rendered by flutter framework itself - as composing text. And we can override the style attributes of the text as well
      </comment>
      <comment author="dkwingsmt">
How come you can use one style to represent both IME and predictive text? AFAI understand, IME text uses regular color with underline, while predictive text uses grey color and no underline.
      </comment>
      <comment author="dkwingsmt">
```suggestion
  /// This feature is specific to iOS 17 and later. It has no effect on other platforms.
  ///
  /// By default, this property is null, meaning the platform setting is used.
  /// Setting this flag overrides the platform setting.
  /// When true, inline prediction is shown; when false, it is disabled.
```
      </comment>
      <comment author="dkwingsmt">
If that's so we should solve this once and for all: Create a new data class `class BuildTextSpanInfo` that contains all these parameters, and use this class as the parameter instead. This way adding new parameters no longer breaks.
      </comment>
      <comment author="LongCatIsLooong">
The iOS text input implementation does not distinguish these two. UX-wise I don't think it's too big of a deal since to users they both represent uncommitted changes suggested by iOS.
      </comment>
      <comment author="LongCatIsLooong">
Ah it looks like you're trying to expose the configuration on TextField/CupertinoTextField. The widget-level API makes sense but I'm still worried this change (on TextEditingController) will be breaking.

Since this is a separate / potentially breaking feature from inline prediction (and people can subclass TextEditingController to achieve the same thing, and interestingly this is going to be a breaking change for them),  I feel we should hold off adding this argument if it's indeed breaking.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="182702">
    <title>refactor: remove material from widget_inspector_test, sliver_cross_axis_group_test, editable_text_show_on_screen_test, scrollable_fling_test, selection_container_test</title>
    <body>
This PR removes Material imports from widget_inspector_test, sliver_cross_axis_group_test, editable_text_show_on_screen_test, scrollable_fling_test, selection_container_test.

part of: https://github.com/flutter/flutter/issues/177415

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [x] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [x] All existing and new tests are passing.
    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

Setting `debugDefaultTargetPlatformOverride` directly in a helper function without a guaranteed reset (e.g., via `addTearDown`) can lead to test pollution if a test fails before reaching the manual reset. It is safer to use `addTearDown` to ensure the global state is restored even on failure.

```suggestion
  debugDefaultTargetPlatformOverride = platform;
  addTearDown(() => debugDefaultTargetPlatformOverride = null);
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

This manual reset is redundant if `addTearDown` is used in the `pumpTest` helper function. Additionally, a manual reset at the end of a test body does not protect against test failures that occur earlier in the execution flow.
      </comment>
      <comment author="navaronbracke">
We do need a teardown here, so I agree
      </comment>
      <comment author="navaronbracke">
I would prefer doing this with teardowns, since then it is easier to follow
      </comment>
      <comment author="navaronbracke">
Can we add the original test(s) in SliverAppBar tests over in Material?
      </comment>
      <comment author="navaronbracke">
There is no "snap" parameter for the widget? Or am I reading this wrong?
      </comment>
      <comment author="navaronbracke">
Same here
      </comment>
      <comment author="navaronbracke">
Is there a constant from the widget inspector that we can leverage, instead of the magic number?
      </comment>
      <comment author="navaronbracke">
Is this specific for a golden test? Why not `Color(0xFFFF0000)`
      </comment>
      <comment author="navaronbracke">
Use TestButton?
      </comment>
      <comment author="navaronbracke">
Same here for TestButton
      </comment>
      <comment author="navaronbracke">
Here too
      </comment>
      <comment author="navaronbracke">
TestButton?
      </comment>
      <comment author="navaronbracke">
Why is there a tiny difference here?
      </comment>
      <comment author="navaronbracke">
This should be moved? The original issue mentioned CupertinoTabScaffold specifically?

cc @justinmc 
      </comment>
      <comment author="navaronbracke">
Use an If-case to clean this up? It feels odd to read
      </comment>
      <comment author="navaronbracke">
Can we use an if-case to get rid of the // ignore ?
      </comment>
      <comment author="navaronbracke">
If case to avoid the // ignore ?
      </comment>
      <comment author="navaronbracke">
Nit: inline this var into the pumpWidget call?
      </comment>
      <comment author="rkishan516">
I made it wrong sentence, actually I wanted to say, since there is no snap parameter that's why no change after gesture release.
      </comment>
      <comment author="rkishan516">
Sure will do

      </comment>
      <comment author="rkishan516">
Oh, I think I missed this. We should use single channel color.
      </comment>
      <comment author="rkishan516">
I don't think there is. But will check.
      </comment>
      <comment author="rkishan516">
Removal of import of material and cupertino has caused this.
      </comment>
      <comment author="rkishan516">
I was thinking to move SliverAppBar to sliver.dart, because thats the only sliver stuck inside material.
      </comment>
      <comment author="justinmc">
I would put this teardown inside of pumpTest to avoid some future test calling pumpTest and forgetting to include the teardown.
      </comment>
      <comment author="justinmc">
Ah that could be a good idea, it looks like SliverAppBar does not depend on AppBar or anything else Material?  I wonder what @Piinks thinks.

For another PR though.
      </comment>
      <comment author="justinmc">
I'm not sure exactly why that would be off the top of my head.
      </comment>
      <comment author="justinmc">
Good catch, yeah @rkishan516 can you copy the original test to Cupertino? Just to make sure we have that specific bug covered. Up to you if you also want to keep your modified test here too.
      </comment>
      <comment author="rkishan516">
Sure, will move.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="182477">
    <title>Unify text direction handling in InputDecorator and TextField/TextFormField</title>
    <body>
This PR adds a unified `textDirection` property to `InputDecoration` and aligns its behavior with `TextField` and `TextFormField`.
 It ensures that `labelText` and `hintText` are correctly resolved when using `TextDirection.rtl`, eliminating the need for redundant configuration and improving consistency across input widgets.


Fixes https://github.com/flutter/flutter/issues/41324

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [x] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [x] All existing and new tests are passing.

If you need help, consider asking for advice on the #hackers-new channel on [Discord].

**Note**: The Flutter team is currently trialing the use of [Gemini Code Assist for GitHub](https://developers.google.com/gemini-code-assist/docs/review-github-code). Comments from the `gemini-code-assist` bot should not be taken as authoritative feedback from the Flutter team. If you find its comments useful you can update your code accordingly, but if you are unsure or disagree with the feedback, please feel free to wait for a Flutter team member's review for guidance on which automated comments should be addressed.

<!-- Links -->
[Contributor Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#overview
[Tree Hygiene]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
[test-exempt]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#tests
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
[Features we expect every widget to implement]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md#features-we-expect-every-widget-to-implement
[CLA]: https://cla.developers.google.com/
[flutter/tests]: https://github.com/flutter/tests
[breaking change policy]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#handling-breaking-changes
[Discord]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md
[Data Driven Fixes]: https://github.com/flutter/flutter/blob/main/docs/contributing/Data-driven-Fixes.md

    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

To improve readability and avoid a redundant widget tree lookup, you can fetch `Directionality.of(context)` once and store it in a local variable. You can also reuse `effectiveLabelTextDirection` to define `effectiveHintTextDirection`, which makes the precedence clearer and the code more concise.

```dart
    final TextDirection directionality = Directionality.of(context);
    final TextDirection effectiveLabelTextDirection = decoration.textDirection ?? directionality;
    final TextDirection effectiveHintTextDirection = decoration.hintTextDirection ?? effectiveLabelTextDirection;
```

<details>
<summary>References</summary>

1. The Flutter Style Guide emphasizes optimizing for readability and writing code correctly. The suggested change improves readability by reducing redundancy and making the logic clearer, which aligns with the principles in lines 29 and 31 of the repository style guide. <sup>([link](https://github.com/flutter/flutter/blob/master/.gemini/styleguide.md))</sup>
</details>
      </comment>
      <comment author="Renzo-Olivares">
I think we should be moving this logic to when we first set `textDirection` on line 2574 above. It seems the text direction is taken into account in the padding calculation `final EdgeInsets? resolvedPadding = decoration.contentPadding?.resolve(textDirection);` so it should have the appropriate text direction at that time.


      </comment>
      <comment author="Renzo-Olivares">
This feels like it might be a breaking change if someone had has TextField.textDirection and TextField.hintTextDirection as different and then they migrate away from hintTextDirection. Previously the text field and input decorator could have a different text direction but after this change they cannot. I don't think this is a blocker since I think unifying the handling here is the right decision but definitely something to keep an eye out for.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="182024">
    <title>[web] Fix autofill in iOS 26 Safari</title>
    <body>
This fix has 2 parts basically:

1. Reuse autofill forms. Prior to this PR, the autofill forms were being recreated every time a text input connection is established. This behavior prevents Safari from autofilling the entire form. This PR reuses the existing form and fields instead of recreating them.

2. Re-establish the text input connection with the framework when the text field receives focus from the browser. This is necessary for iOS26's new focus behavior where it blurs the text field then focuses it before autofilling it. That blur-then-focus is a new behavior that was not accounted for by the web engine.

Fixes https://github.com/flutter/flutter/issues/177248
    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![high](https://www.gstatic.com/codereviewagent/high-priority.svg)

The `_updateFieldValues` method calls `applyToDomElement` on all elements in the form. The documentation for `applyToDomElement` states that it should only be used for focused elements, as calling `setSelectionRange` on a non-focused element will cause it to gain focus. This could lead to unintended focus-stealing behavior.

To fix this, you should only apply the full editing state (including selection) to the currently focused element, and only update the text value for other elements in the form.

```suggestion
  void _updateFieldValues() {
    for (final String key in elements.keys) {
      final DomHTMLElement element = elements[key]!;
      final AutofillInfo autofill = items[key]!.autofillInfo;
      if (key == focusedElementId) {
        autofill.editingState.applyToDomElement(element);
      } else {
        // For non-focused elements, only update the text value to avoid
        // accidentally focusing them.
        if (element is DomHTMLInputElement) {
          element.value = autofill.editingState.text;
        } else if (element is DomHTMLTextAreaElement) {
          element.value = autofill.editingState.text;
        }
      }
    }
  }
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

Using a null assertion `!` on `view` could lead to a runtime error if `EnginePlatformDispatcher.instance.viewManager[viewId]` returns null. While this might be unlikely in the current flow, using the null-aware operator `?.` would be safer and more robust.

```suggestion
    view?.dom.textEditingHost.addEventListener('focusin', createDomEventListener(_handleRefocus));
```
      </comment>
      <comment author="justinmc">
This will be a breaking change for anyone that mixes in TextInputClient. This at least includes super_editor in customer_testing. You probably want to include an empty implementation here to avoid this (like showToolbar does below), unless maybe if the refocus method is critical enough that it should be a breaking change to not implement it.
      </comment>
      <comment author="Renzo-Olivares">
+1 about this being a breaking change. 

My thoughts are that we probably do want to make this a breaking change since without it `Autofill` is broken on iOS 26 and this way implementers are made aware that implementing the method is required to fix that feature. This `refocus` approach LGTM!
      </comment>
      <comment author="mdebbar">
Alright, now that the approach sounds good to both of you, I'll go ahead and add tests and fix the failures.

Regarding the breaking change, I think the most reasonable path is to include an empty implementation of `refocus()` to avoid the breaking change. Reasoning:

Advanced text field implementations (like `super_editor`) do not need or use autofill functionality. They are addressing a different use case (rich text editing and document rendering). And I doubt autofill ever worked with `super_editor`given that they don't use AutofillGroup, etc.

Does that sound reasonable?
      </comment>
      <comment author="Renzo-Olivares">
My initial thought was that because Autofill is a common feature of a `TextField` that we should get this in as a breaking change to make it clear to implementers that this is necessary for Autofill to work. However, giving this more thought I think for the reasons you stated @mdebbar it is reasonable to keep this change non-breaking since it is not required for basic text input, i.e if a user does not want autofill on Safari they do not need to implement `refocus`.
      </comment>
      <comment author="mdebbar">
Good bot!
      </comment>
      <comment author="mdebbar">
The `_addRefocusListenerToView` method is always given an ID of a live view. If `view` turns out to be null, then there's a serious bug somewhere.
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

According to the style guide, all public members should have documentation. Please add a doc comment for the `FieldItem` class and its fields.

```dart
/// Holds information about a single field in an autofill group.
class FieldItem {
  FieldItem({required this.inputType, required this.autofillInfo});

  /// The input type of the field.
  final EngineInputType inputType;

  /// The autofill information for the field.
  final AutofillInfo autofillInfo;
}
```

<details>
<summary>References</summary>

1. All public members should have documentation. <sup>([link](https://github.com/flutter/flutter/blob/master/.gemini/styleguide.md))</sup>
</details>
      </comment>
      <comment author="loic-sharma">
```suggestion
      // Send refocus message to re-establish the connection.
```
      </comment>
      <comment author="loic-sharma">
This behavior - that `TextInputClient.refocus` is ignored unless the connection was previously closed - might be confusing to other embedders that want to send this message. Should we maybe make this message's name a bit more descriptive? For example, `TextInputClient.refocusIfConnectionClosed` or `TextInputClient.refocusLastConnection`?
      </comment>
      <comment author="loic-sharma">
```suggestion
      // Send refocus message to re-establish the connection.
```
      </comment>
      <comment author="mdebbar">
Rationale for current implementation: if a connection is already open, then the text field is already focused, so refocusing is a no-op. Is that a correct assumption?
      </comment>
      <comment author="loic-sharma">
> if a connection is already open, then the text field is already focused, so refocusing is a no-op.

While this _might_ be true for `EditableText`, I don't think we can make this assumption universally. You can make a custom text input client with weird focus behaviors.

Also @LongCatIsLooong bubbled up an interesting concern during Jan 8's text input sync ([Google internal link](https://docs.google.com/document/d/1vimZnqmmv5ZjTc9mDZ73cX3ztM6hlAXTSiznd5gB80c/edit?resourcekey=0-9Zl8Zp8pdQwYsSRm8sLcCA&tab=t.0#heading=h.eimx21agxelp)): on iOS, the input method can do actions even after you unfocused. For example, if you start an IME composition but don't complete it and then move focus, IME composition completes after focus has moved. The ideal solution would be keeping connections open for all focusable text fields, regardless of whether they are actually focused. This might be something we do in the future.
      </comment>
      <comment author="loic-sharma">
(BTW I'm happy to stick with the current implementation as-is, my suggestion is only for the name of the platform message)
      </comment>
      <comment author="loic-sharma">
Is this comment up-to-date? It looks like this disables pointer events on iOS too.
      </comment>
      <comment author="mdebbar">
I gave this a little more thought.

Based on what you said (which makes sense), I think we should be less opinionated on how the input client should behave and instead treat this as an event rather than a request for a specific action. I.e. I'm proposing we name it "onFocusReceived" or something similar, and each client should react to it as it sees fit (default would be to refocus, which will re-establish the connection). This is similar to the existing "onConnectionClosed".

I'm also going to remove the condition `if (!alreadyFocused) { refocus(); }`, and make it so it always calls `requestFocus` (which is mostly a no-op if the node already has focus: [see code](https://github.com/flutter/flutter/blob/167f30fc7d2ce4f83e2a5439eb5e074c431c27b3/packages/flutter/lib/src/widgets/focus_manager.dart#L1184-L1187)).
      </comment>
      <comment author="loic-sharma">
> I'm proposing we name it "onFocusReceived" 

Love it! Thanks for the thoughtful response :)
      </comment>
    </comments>
  </pull_request>
  <pull_request id="181722">
    <title>Remove Material Dependency from `semantics_debugger_test`</title>
    <body>
This change refactors `semantics_debugger_test.dart` to eliminate its dependency on **Material** widgets, as part of the test reorganization effort to ensure tests only depend on the library code they are testing.

---

## Changes

- Replace `Material` import with `widgets` import in `semantics_debugger_test.dart`
- Replace `ElevatedButton` with `TestButton` (2 tests)
- Replace `Slider` with `TestSlider` (1 test)
- Replace `Checkbox` with `TestCheckbox` (2 tests)
- Replace `TextField` with `TestTextField` (1 test)
- Replace `MaterialApp` with `TestWidgetsApp` (2 tests)
- Remove `Material` wrapper widgets throughout tests
- Replace `Colors` constants with explicit `Color` values

---

## New Test Widgets Created

### `TestSlider`
A minimal slider with semantics support for testing.

- Implements `onIncrease` / `onDecrease` semantic actions
- Supports min/max range and divisions
- Uses a **10% adjustment unit** for continuous sliders

### `TestCheckbox`
A minimal checkbox with semantics support for testing.

- Implements checked state and `onTap` semantic action
- Supports enabled and disabled states

---

## Enhanced Existing Test Widget

### `TestTextField`
Updated to better match the Material `TextField` semantics structure.

- Added a `Semantics` wrapper
- Provides enabled state and `onTap` action
- Allows tests to find `Semantics` descendants as expected

---

## Test Results

All **21 tests pass** successfully with the new test widget
Part of  #177414
<!--
Thanks for filing a pull request!
Reviewers are typically assigned within a week of filing a request.
To learn more about code review, see our documentation on Tree Hygiene: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
-->

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [x] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [x] All existing and new tests are passing.

If you need help, consider asking for advice on the #hackers-new channel on [Discord].

**Note**: The Flutter team is currently trialing the use of [Gemini Code Assist for GitHub](https://developers.google.com/gemini-code-assist/docs/review-github-code). Comments from the `gemini-code-assist` bot should not be taken as authoritative feedback from the Flutter team. If you find its comments useful you can update your code accordingly, but if you are unsure or disagree with the feedback, please feel free to wait for a Flutter team member's review for guidance on which automated comments should be addressed.

<!-- Links -->
[Contributor Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#overview
[Tree Hygiene]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
[test-exempt]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#tests
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
[Features we expect every widget to implement]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md#features-we-expect-every-widget-to-implement
[CLA]: https://cla.developers.google.com/
[flutter/tests]: https://github.com/flutter/tests
[breaking change policy]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#handling-breaking-changes
[Discord]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md
[Data Driven Fixes]: https://github.com/flutter/flutter/blob/main/docs/contributing/Data-driven-Fixes.md

[![talabat.com contributions](https://img.shields.io/badge/talabat.com-contributions-FF5A00?style=flat&logo=flutter&logoColor=white)](https://www.talabat.com) [![Talabat Flutter PRs](https://img.shields.io/badge/Talabat_Flutter_PRs-14%20merged-97ca00?style=flat&logo=flutter&logoColor=white)](https://github.com/search?q=org%3Aflutter+talabat&type=pullrequests)

    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

The `onChanged != null` check is redundant. This method is only assigned to `Semantics.onIncrease` when `onChanged` is not null, so the check is unnecessary. You can simplify the method for better readability.

```dart
  void _increaseAction() {
    final double newNormalizedValue = (_normalizedValue + _semanticActionUnit).clamp(0.0, 1.0);
    onChanged!(min + newNormalizedValue * (max - min));
  }
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

The `onChanged != null` check is redundant. This method is only assigned to `Semantics.onDecrease` when `onChanged` is not null, so the check is unnecessary. You can simplify the method for better readability.

```dart
  void _decreaseAction() {
    final double newNormalizedValue = (_normalizedValue - _semanticActionUnit).clamp(0.0, 1.0);
    onChanged!(min + newNormalizedValue * (max - min));
  }
```
      </comment>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

The `onChanged != null` check is redundant. This method is only assigned to `Semantics.onTap` and `GestureDetector.onTap` when `onChanged` is not null, so the check is unnecessary. You can simplify the method for better readability.

```dart
  void _handleTap() {
    onChanged!(value != true);
  }
```
      </comment>
      <comment author="justinmc">
Are you able to do this via EditableText which has a Semantics inside of it? @Renzo-Olivares I wonder what you think about this.
      </comment>
      <comment author="justinmc">
Can you add a TODO like this for each of these two new Test classes you wrote?

https://github.com/flutter/flutter/blob/9b30164e6957a42d6be43a9ccd4cfa9746d24136/packages/flutter/test/widgets/widgets_app_tester.dart#L34-L35
      </comment>
      <comment author="justinmc">
Also, I think we should move these classes to their own files, like slider_tester.dart and checkbox_tester.dart. I should probably move TestButton in another PR too, sorry for the misleading example here.

CC @Renzo-Olivares for thoughts.
      </comment>
      <comment author="justinmc">
@Renzo-Olivares pointed out to me that EditableText actually does not have onTap in its Semantics:

https://github.com/flutter/flutter/blob/018a57179c12c7d4ee1fb225b4759d2c05047b20/packages/flutter/lib/src/widgets/editable_text.dart#L5800-L5805

That is handled [in TextField](https://github.com/flutter/flutter/blob/018a57179c12c7d4ee1fb225b4759d2c05047b20/packages/flutter/lib/src/material/text_field.dart#L1795-L1799) and [in CupertinoTextField](https://github.com/flutter/flutter/blob/018a57179c12c7d4ee1fb225b4759d2c05047b20/packages/flutter/lib/src/cupertino/text_field.dart#L1630-L1632). We should probably move that semantics logic to EditableText, but after this PR. I'll create an issue.

In the meantime, I think we should move the test "SemanticsDebugger textfield" to material, and keep TestTextField as-is.
      </comment>
      <comment author="justinmc">
Issue: https://github.com/flutter/flutter/issues/181873

@rizwan-saleem When you move the test to Material, please add a TODO that references this issue.
      </comment>
      <comment author="Renzo-Olivares">
This test looks like it's testing some specific platform logic based on this switch. I wonder if we should duplicate it in `Material`.
      </comment>
      <comment author="Renzo-Olivares">
I think this test might also be a good candidate to duplicate or outright move to `Material` since it seems to be specifically testing `Checkbox` and not just the general functionality.

Unlike `SemanticsDebugger interaction test` earlier in this file which uses the buttons as a means to add logs to a list, this is testing the `Checkbox` functionality.
      </comment>
      <comment author="Renzo-Olivares">
Similar to my comment https://github.com/flutter/flutter/pull/181722/changes#r2760892419
      </comment>
      <comment author="justinmc">
Good catch, yes I would copy the original test to Material and keep the version you have now here.
      </comment>
      <comment author="Renzo-Olivares">
Sounds good to me!
      </comment>
      <comment author="justinmc">
Was this added by mistake or am I misunderstanding? Seems like this file is in the right spot.
      </comment>
      <comment author="justinmc">
I think maybe you misread my comment (https://github.com/flutter/flutter/pull/181722#discussion_r2760834163). I meant that you should move this test into test/material/semantics_debugger_test.dart, and then add a comment with a TODO linking to https://github.com/flutter/flutter/issues/181873.

I think this test is fundamentally testing logic that is currently inside of TextField in the Material library, so the test should go in the Material library tool.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="181240">
    <title>Expose computeLineMetrics on RenderParagraph</title>
    <body>
This change exposes TextPainter.computeLineMetrics() through RenderParagraph by adding a small forwarding method.

This allows callers that only have access to RenderParagraph to retrieve line metrics without duplicating layout logic or accessing internal state.

The implementation follows the same pattern as existing query methods such as getBoxesForSelection and getPositionForOffset.
 
fixes #44834
    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![medium](https://www.gstatic.com/codereviewagent/medium-priority.svg)

This extra blank line should be removed to adhere to Dart's formatting conventions, which typically use a single blank line between class members.

<details>
<summary>References</summary>

1. The style guide states that all Dart code is formatted using `dart format`. This tool enforces a single blank line between members for consistent code style. <sup>([link](https://github.com/flutter/flutter/blob/master/.gemini/styleguide.md))</sup>
</details>
      </comment>
      <comment author="crackedhandle">
Fixed — removed the extra blank line. Thanks!
      </comment>
      <comment author="Renzo-Olivares">
nit: for the docs we should probably use the same documentation from `TextPainter.computeLineMetrics`. I recommend making it a doc template and using that template here.
      </comment>
      <comment author="Renzo-Olivares">
I wonder if it would be beneficial here to expose other methods like `getLineMetricsAt` which may have less overhead then calling `computeLineMetrics` if someone only wants to access metrics for specific lines. cc @LongCatIsLooong since that seems to be the approach you were taking in https://github.com/flutter/flutter/pull/145190/changes#diff-8869f4e2a7291974a4badaa8af9df4e31da61cba8a0beb83948a258486166fdc .
      </comment>
      <comment author="crackedhandle">
> nit: for the docs we should probably use the same documentation from `TextPainter.computeLineMetrics`. I recommend making it a doc template and using that template here.

Thanks for pointing that out!

I’ll update the docs to reuse the same template as `TextPainter.computeLineMetrics` so we avoid duplication and keep everything consistent.
      </comment>
      <comment author="crackedhandle">
> I wonder if it would be beneficial here to expose other methods like `getLineMetricsAt` which may have less overhead then calling `computeLineMetrics` if someone only wants to access metrics for specific lines. cc @LongCatIsLooong since that seems to be the approach you were taking in https://github.com/flutter/flutter/pull/145190/changes#diff-8869f4e2a7291974a4badaa8af9df4e31da61cba8a0beb83948a258486166fdc .

That’s a really good suggestion.

For this PR, I was aiming to keep the change minimal and just expose the existing `computeLineMetrics` through `RenderParagraph`.

I’m happy to open a follow-up PR to explore exposing `getLineMetricsAt` (or other more granular APIs) if that would be useful.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="180021">
    <title>Add Translate to iOS selection context menu</title>
    <body>
Fixes https://github.com/flutter/flutter/issues/150392, part of https://github.com/flutter/flutter/issues/107578

This PR adds a "Translate" action to the ios selection context menu using this [swiftui translate api](https://developer.apple.com/documentation/SwiftUI/View/translationPresentation(isPresented:text:attachmentAnchor:arrowEdge:replacementAction:)) announce during WWDC 2024.
Includes the ipad implementation as well.

https://github.com/user-attachments/assets/8c508f93-2341-498a-b494-c83fafa878f4


https://github.com/user-attachments/assets/61025f9c-f937-4043-bee5-ee31761cf5c0

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [x] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [x] All existing and new tests are passing.

    </body>
    <comments>
      <comment author="hellohuanlin">
uber nit: we typically call this `flutterViewController` in embedder
      </comment>
      <comment author="hellohuanlin">
please double check ios 26 behavior, we may also wanna pass the rect on iphone
      </comment>
      <comment author="hellohuanlin">
good corner case!
      </comment>
      <comment author="hellohuanlin">
nit: Translate**View**Controller
      </comment>
      <comment author="hellohuanlin">
Nit: objc name should have a prefix
      </comment>
      <comment author="hellohuanlin">
`termToTranslate` vs `originalText` can you pick just one? 
      </comment>
      <comment author="hellohuanlin">
nit: can do `guard let strongSelf = self else { return }`
      </comment>
      <comment author="hellohuanlin">
nit: can use `??`
      </comment>
      <comment author="hellohuanlin">
Am I understanding right that the reason we have to use 2 new VCs (this and the hosting controller) is that hosting vc cannot be imported in objc? 
Maybe leave a comment if so

      </comment>
      <comment author="hellohuanlin">
`isTranslationPopoverShown` is only toggled internally. I wonder you can simplify it by getting rid of this state (and the `onChange` call) and just pass a raw binding: 

```
  .translationPresentation(
        isPresented: Binding(
          get: { true },
          set: { isShown in
            if !isShown {
              onDismiss?()
            }
          }),
        text: termToTranslate,
        //...
```
      </comment>
      <comment author="LouiseHsu">
i moved this out into a computed property lol
      </comment>
      <comment author="LouiseHsu">
done
      </comment>
      <comment author="LouiseHsu">
done
      </comment>
      <comment author="LouiseHsu">
done
      </comment>
      <comment author="LouiseHsu">
done
      </comment>
      <comment author="LouiseHsu">
done
      </comment>
      <comment author="LouiseHsu">
it looks nice
<img width="1206" height="2622" alt="Simulator Screenshot - new iphone 17 (26 2) - 2026-01-13 at 15 43 24" src="https://github.com/user-attachments/assets/3a7e851f-c892-4b9f-b77d-e09588dec63f" />

      </comment>
      <comment author="LouiseHsu">
done
      </comment>
      <comment author="hellohuanlin">
Can you add a comment on why use different anchor source for iphone/ipad? 

The format is off. @jmagman i remember you setup formatter in packages repo. Do we also have it setup for flutter repo? 

      </comment>
      <comment author="jmagman">
> The format is off. @jmagman i remember you setup formatter in packages repo. Do we also have it setup for flutter repo?

No, it's tracked here: https://github.com/flutter/flutter/issues/172799
      </comment>
      <comment author="hellohuanlin">
@LouiseHsu can you manually format this code in xcode by using `CMD + A` then `Control + I`
      </comment>
      <comment author="hellohuanlin">
remember to revert this @LouiseHsu 
      </comment>
      <comment author="justinmc">
"it's" => "its"
      </comment>
      <comment author="justinmc">
"A" => "An"
      </comment>
      <comment author="justinmc">
Period at the end.
      </comment>
      <comment author="loic-sharma">
```suggestion
  /// Whether translate is enabled.
```
      </comment>
      <comment author="loic-sharma">
```suggestion
  /// this function will not do anything.
```
      </comment>
      <comment author="loic-sharma">
Should this line be removed? The comment indicates this method intends to no-op on obscured text.
      </comment>
    </comments>
  </pull_request>
  <pull_request id="178258">
    <title>Use glyph boundaries for horizontal character traversal</title>
    <body>
This PR implements horizontal character traversal (using arrow keys) in text fields and paragraphs using actual glyph information from text layout, as opposed to "guessing" character boundaries from the underlying text. This allows for correct horizontal caret traversal of RTL text as well as correctly positioning the caret between characters in complex scripts (e.g. Indic) that rely on text shaping.

Before:
![before](https://github.com/user-attachments/assets/57296793-6fcd-4ae8-a835-35eb95572c62)

After:
![after](https://github.com/user-attachments/assets/b00a55d4-ca21-4ab8-8681-5c095288223d)

Fixes #34610
Fixes #78660
Maybe fixes #120049

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [x] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [ ] All existing and new tests are passing.

    </body>
    <comments>
      <comment author="gemini-code-assist[bot]">
![critical](https://www.gstatic.com/codereviewagent/critical.svg)

These TODO comments indicate known issues or untested edge cases, with one explicitly marked as `FAIL`. It's critical to address these before merging to ensure the stability and correctness of glyph-based traversal, especially with complex text layouts involving mixed directions and line breaks. Could you please add the mentioned tests and fix any failures, or create follow-up issues to track this work if it's out of scope for this PR?
      </comment>
      <comment author="gemini-code-assist[bot]">
![high](https://www.gstatic.com/codereviewagent/high-priority.svg)

The logic for handling LTR/RTL boundary transitions is quite complex and hard to follow. For instance, the `offset` variable is updated inside the `do-while` loops but this value seems to be unused, as it's immediately overwritten after the loop. This could be a potential source of bugs.

Additionally, the indentation for the lines after the `do-while` loops (lines 5330-5331 and 5344-5345) seems incorrect. They should be indented to be within their respective `if/else` blocks. This appears to be a violation of the Flutter Style Guide which requires all code to be formatted with `dart format`.[^1]

Given the complexity and the existing TODOs about failing tests, this section might benefit from simplification or more extensive comments explaining the state transitions. Could you refactor this to improve clarity and correctness, perhaps by breaking it down into smaller helper methods and fixing the formatting?

#### Style Guide References
[^1]: All Dart code is formatted using `dart format`. This is enforced by CI.
      </comment>
      <comment author="justinmc">
Does TextBoundary.getTextBoundaryAt possibly require iterating the entire string? I'm thinking about what the performance implications of this PR could be. I assume it will be negligible in most cases, but we should think it through.
      </comment>
      <comment author="justinmc">
We should probably include a high level test that actually puts a bidirectional string into an EditableText and traverses it with arrow keys.
      </comment>
      <comment author="justinmc">
Are there any other places that would benefit from _moveBeyondGlyphBoundary?
      </comment>
      <comment author="justinmc">
Nit: If you accept _value as a parameter, could this be static? Just thinking it might make this complex method easier to understand if so.
      </comment>
      <comment author="tgucio">
That's correct, in the worst case (single text direction change), this would traverse the string towards either end. But I think the current `WordBoundary` implementation does so too.
      </comment>
      <comment author="tgucio">
Agree, this needs a couple of new tests here and there.
      </comment>
      <comment author="tgucio">
Good question there. Perhaps Paragraph for changing text selection?
      </comment>
    </comments>
  </pull_request>
  <pull_request id="176968">
    <title>feat: Expose `buttons` accessor on Tap Details events (TapDownDetails and TapUpDetails)</title>
    <body>
Expose `buttons` accessor on Tap Details events (`TapDownDetails` and `TapUpDetails`).

Fixes https://github.com/flutter/flutter/issues/176583

Note: I chose the option of making it optional to avoid breaking anyone creating synthetic events by hand (though I doubt many people would be doing that). I am also perfectly happy with making it required - just let me know. That would be more ergonomic to the end user as the framework can always guarantee it is there but might break those edge cases of people creating these classes "by hand". A compromise would be a default value, though I think that is more misleading than it would be helping. If we are ok with the minor breaking change my preference would be to make it required. But I think adding it as optional is a much safer first step.

## Pre-launch Checklist

- [x] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [x] I read the [Tree Hygiene] wiki page, which explains my responsibilities.
- [x] I read and followed the [Flutter Style Guide], including [Features we expect every widget to implement].
- [x] I signed the [CLA].
- [x] I listed at least one issue that this PR fixes in the description above.
- [x] I updated/added relevant documentation (doc comments with `///`).
- [x] I added new tests to check the change I am making, or this PR is [test-exempt].
- [x] I followed the [breaking change policy] and added [Data Driven Fixes] where supported.
- [x] All existing and new tests are passing.

<!-- Links -->
[Contributor Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#overview
[Tree Hygiene]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md
[test-exempt]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#tests
[Flutter Style Guide]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
[Features we expect every widget to implement]: https://github.com/flutter/flutter/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md#features-we-expect-every-widget-to-implement
[CLA]: https://cla.developers.google.com/
[flutter/tests]: https://github.com/flutter/tests
[breaking change policy]: https://github.com/flutter/flutter/blob/main/docs/contributing/Tree-hygiene.md#handling-breaking-changes
[Discord]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md
[Data Driven Fixes]: https://github.com/flutter/flutter/blob/main/docs/contributing/Data-driven-Fixes.md

    </body>
    <comments>
      <comment author="renancaraujo">
```suggestion
    // TODO(luanpotter): Provide kind and buttons here once [TapDragDownDetails] has them.
```
      </comment>
      <comment author="luanpotter">
@renancaraujo I'm the only _one_
      </comment>
      <comment author="Renzo-Olivares">
I think if we want to expose the `*Details.buttons` API it would be preferred if this pull request handled adding them to all the `*Details` objects and not only `TapDownDetails` and `TapUpDetails`. This would be similar to how we added the `allowedButtonsFilter` API https://github.com/flutter/flutter/pull/111852 on all the recognizers in one PR. I think the benefit of doing it this way versus the alternative of multiple PRs is that the framework is not left in a inconsistent state. What do you think about this?
      </comment>
      <comment author="Renzo-Olivares">
This doc snippet needs to be updated to reflect the new map structure.
      </comment>
      <comment author="Renzo-Olivares">
I suggest pulling the inverted stylus example directly from the `[PointerEvent.buttons]` documentation into here and elsewhere. 
      </comment>
      <comment author="Renzo-Olivares">
A doc template may be appropriate here as well.
      </comment>
      <comment author="luanpotter">
I can def try to add to other details - let me take a look!
      </comment>
      <comment author="luanpotter">
NOTE: I am also wiring kind on places that I found it missing. Please let me know if the omission was intentional in these places.
      </comment>
      <comment author="luanpotter">
didn't feel great to hide a NOTE inside the macro (and it might not apply everywhere) so I left it here, but happy to pivot.
      </comment>
      <comment author="luanpotter">
this was missing but I believe was a mistake
      </comment>
      <comment author="luanpotter">
not sure if this one needs to be nullable as well - since the `kind` is not
      </comment>
      <comment author="luanpotter">
this is an addendum; just making the test easier to debug
      </comment>
      <comment author="luanpotter">
if you prefer I can extract that to a separate PR to reduce touchpoints. or just remove it.

btw on this test I just arbitrarily added the parameters to test the toStrings
      </comment>
      <comment author="luanpotter">
kind is also require because the dartdocs we are importing in on every event with the macro references `[kind]`. so if we don't want to also add kind, we will need to have two versions of that dartdoc
      </comment>
      <comment author="luanpotter">
intentionally left some as null to test that as well
      </comment>
      <comment author="luanpotter">
the value is already `T?`
      </comment>
      <comment author="dkwingsmt">
I think the documentation is not clear enough. Instead of focusing on the format of the bitfield, there are more things to clarify. Here's my proposal:
```dart
  /// The buttons that were pressed when the device first contacted the screen.
  ///
  /// For the format of this value, see [PointerEvent.buttons].
  ///
  /// Subsequent changes to the buttons pressed during the same drag sequence
  /// will be reported in [DragUpdateDetails.buttons], regardless of whether the
  /// drag has started ([DragStartDetails]) or not.
  ///
  /// This property will always be set by the platform but synthetic events
  /// might not have it. It can be made required on future releases.
```
Feel free to clarify more details if you feel necessary.

      </comment>
      <comment author="dkwingsmt">
Since we're describing things at the gesture level, I recommend not mentioning "events" when possible.
```suggestion
  /// The kind of the device that initiated the drag.
```
      </comment>
      <comment author="luanpotter">
would you still put that into a macro? it seems we are going in the direction of more customized per-event messages (such as referring to drag-specifics or referring to things with the exact name in the context they are). makes sense to just not use a macro at all?
      </comment>
      <comment author="luanpotter">
i'm not sure why this test was expecting 0 here instead of the actual button (2). I think it was just testing the wrong previous behaviour incorrectly
      </comment>
      <comment author="luanpotter">
this is from https://github.com/flutter/flutter/blob/7889cccfbe970b5470c3ea56f9fddc2d77e23f4b/packages/flutter_test/lib/src/controller.dart#L1800-L1803

seems pretty intentional; if the line were uncommented there, this could follow the other tests
      </comment>
      <comment author="luanpotter">
changing everything to non-nullable (including some existing kind fields) caused some cascading consequences here. please take a close look 🙏 
      </comment>
      <comment author="luanpotter">
more cascading consequences of `kind` being non-null
      </comment>
      <comment author="Renzo-Olivares">
https://github.com/luanpotter/flutter/blob/255b742a6950b48f2ff1e8ec489afcc30dcae3bb/packages/flutter/lib/src/gestures/monodrag.dart#L321-L323 contradicts the documentation here. I think this snippet should be removed, and a snippet explaining this behavior should be added to `DragGestureRecognizer`s documentation. Maybe something like "`DragGestureRecognizer will cancel a gesture if there are any changes to the buttons pressed during the same drag sequence`".
      </comment>
      <comment author="dkwingsmt">
It seems like the new `details` is the same as `originalDetails` except that its `localPosition` is in terms of the scrollbar instead of the thumb, which makes total sense. Since `originalDetails.localPosition` is never used, I think it's simpler to construct the new drag details in `_handleThumbDragStart` so that `handleThumbPressStart` receives just one `details`. (And can you also add the explaination of the `localPosition` to in the method's doc?)
      </comment>
      <comment author="dkwingsmt">
It's a bit surprising to me that practically we don't support dragging with multiple buttons (unless the buttons are pressed at the exact same time). I guess it's what it is, although I'd appreciate it if you can help me verify it.

I think @Renzo-Olivares 's paragraph is great, although I suggest adding it to the drag recognizer classes instead of here.
      </comment>
      <comment author="dkwingsmt">
Since we don't expect this value to change during a sequence we should just call it `_kind`. 
      </comment>
      <comment author="dkwingsmt">
How can these members be null? We should instead assert the two members are non-null here.
      </comment>
      <comment author="dkwingsmt">
I guess this comment is no longer applicable?
      </comment>
      <comment author="dkwingsmt">
Create a data class instead of using this record. It's a few lines more but easier to maintain, especially since this data class is used for persistent storage in the recognizer.
      </comment>
    </comments>
  </pull_request>
</collection>

