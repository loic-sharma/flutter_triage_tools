# DropdownMenu highlight is missing when enableSearch is false

**Link**: [flutter#184328](https://github.com/flutter/flutter/issues/184328)

**Summary**: When `DropdownMenu.enableSearch` is set to `false`, the selected entry does not show the expected visual highlight (background overlay) in the menu. This occurs even when an `initialSelection` is provided. The issue has been verified on Flutter stable 3.41.6.

**Screenshot or video**:

https://github.com/user-attachments/assets/686a74ad-4917-42d0-9a5d-6876726b084b

https://github.com/user-attachments/assets/1711e486-009c-4138-9a3f-c691709b0c8f

# Autocomplete fails to select the same item after the controller is cleared

**Link**: [flutter#184386](https://github.com/flutter/flutter/issues/184386)

**Summary**: After selecting an item from `Autocomplete` suggestions and programmatically clearing the field using `TextEditingController.clear()`, attempting to select the same item again fails to update the input field. This regression persists on stable and master channels despite a previous fix for a similar issue.

**Screenshot or video**:

https://github.com/user-attachments/assets/090e67e8-4379-4983-9547-c8467011ca44
