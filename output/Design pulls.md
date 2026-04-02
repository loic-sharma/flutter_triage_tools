# Add resetOnBlur property to DropdownMenu

**Link**: [flutter#180584](https://github.com/flutter/flutter/pull/180584)

**Summary**: This PR adds a `resetOnBlur` property (initially proposed as `clearOnBlur`) to `DropdownMenu`. When enabled, the text field reverts to the last selected value if the user navigates away or submits the field without selecting a new option. The implementation includes a shift to an internal focus node pattern for `DropdownMenu` to ensure the feature works correctly even when no external `focusNode` is provided.

# Move hero animation tests to the material directory

**Link**: [flutter#181266](https://github.com/flutter/flutter/pull/181266)

**Summary**: This PR attempts to move `heroes_test.dart` from the `widgets` directory to the `material` directory, as many of its tests rely on Material-specific components like `Scaffold` and `MaterialPageRoute`. During review, it was suggested that instead of moving the entire file, Material-specific tests should be split out or replaced with generic widget counterparts to keep core `Hero` logic testing within the `widgets` package.

# Clean up legacy material imports in widget tests

**Link**: [flutter#181612](https://github.com/flutter/flutter/pull/181612)

**Summary**: As part of an effort to reduce technical debt, this PR moves `page_route_builder_test.dart` from `test/widgets/` to `test/material/` and renames it to `page_route_builder_material_barrier_color_test.dart`. This change reflects the test's dependency on Material-specific behavior, specifically the `useMaterial3` flag and its effect on barrier colors.

# Use Material.of to access ink controllers in tests

**Link**: [flutter#183698](https://github.com/flutter/flutter/pull/183698)

**Summary**: This PR simplifies various Material-specific tests by using `Material.of(context)` to retrieve the `MaterialInkController`. This cleanup is a preliminary step toward a larger architectural goal of potentially moving the ink controller implementation out of the core Material library to improve layering.

# [Android] Fix text selection handle alignment and implement auto-dismissal

**Link**: [flutter#178551](https://github.com/flutter/flutter/pull/178551)

**Summary**: This PR addresses several issues in text selection: it fixes a slight misalignment of the selection handle in `InputField`, ensures the selection overlay rebuilds when `cursorWidth` is updated, and implements native-like auto-dismissal of selection handles on Android. On Android devices, collapsed selection handles will now automatically disappear after 4 seconds of inactivity.

**Screenshot or video**:

https://github.com/user-attachments/assets/99d69ea0-9559-4b79-8402-aa7657dc47b9

https://github.com/user-attachments/assets/d89d6a99-f026-4e59-bb17-ad8950aea6f0

# Fix autocomplete tab focus traversal with disabled fields

**Link**: [flutter#184000](https://github.com/flutter/flutter/pull/184000)

**Summary**: This PR ensures that `Autocomplete` options do not interfere with Tab focus traversal. By setting `canRequestFocus: false` on the individual option rows, the focus now correctly moves to the next enabled widget in a form when the user presses Tab, rather than getting stuck within the autocomplete suggestions. Arrow keys remain functional for navigating and highlighting options.

# Remove cross-imported test utilities from Cupertino tests

**Link**: [flutter#183350](https://github.com/flutter/flutter/pull/183350)

**Summary**: This PR removes dependencies on cross-package test utilities in `sheet_test.dart` and `tab_scaffold_test.dart`. By inlining local versions of helpers like `simulateSystemBack()` and `TestCallbackPainter`, the Cupertino tests become more self-contained and align with the project's goal of cleaning up test cross-imports.

# Fix DropdownButtonFormField underline alignment

**Link**: [flutter#181040](https://github.com/flutter/flutter/pull/181040)

**Summary**: This PR fixes a visual bug where the underline of a `DropdownButtonFormField` failed to align with the bottom of its container when expanded. The solution involved introducing vertical expansion support while carefully avoiding breaking changes to the existing `isExpanded` property, which historically only governed horizontal expansion.

**Screenshot or video**:

https://github.com/user-attachments/assets/0b1c2fb1-b615-4f7f-9f8b-ff02eae5ec82

https://github.com/user-attachments/assets/27fac6cc-8673-4cfa-8d73-cf7f77198bef

https://github.com/user-attachments/assets/c0ac43d4-d89f-4f77-b685-b953a017d0f2

# [Android] Support predictive back from three-button navigation

**Link**: [flutter#183642](https://github.com/flutter/flutter/pull/183642)

**Summary**: This PR adds support for predictive back gestures when using Android's traditional 3-button navigation bar. It specifically handles the `EDGE_NONE` event introduced in Android API 36, allowing users to see predictive transitions when long-pressing the system back button, matching the behavior previously only available with gesture navigation.

**Screenshot or video**:

https://github.com/user-attachments/assets/b5abb458-93db-43c5-ae22-1ac51b395875

# Fix NavigationDrawer highlight rendering for programmatic index changes

**Link**: [flutter#181960](https://github.com/flutter/flutter/pull/181960)

**Summary**: This PR fixes an issue where the `NavigationDrawer` selection indicator would not render correctly when the index was changed programmatically. By wrapping the indicator in a transparent `Material` widget, it ensures the indicator's `Ink` decoration is painted on the proper layer, restoring correct clipping, layering, and animation behavior.
