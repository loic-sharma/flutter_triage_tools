# Flutter triage tools

## Instructions

1. Install [Gemini CLI][Gemini CLI].
2. Install [GitHub CLI][GitHub CLI].
3. Create a prompt to triage issues:

   ```sh
   dart run bin/flutter_triage_tools.dart "is:open is:issue label:team-text-input,fyi-text-input no:assignee -label:triaged-text-input" > prompt.md
   ```

4. Run Gemini:

   ```sh
   cat prompt.md | gemini > output.md
   ```

5. Review the output in `output.md`.

[Gemini CLI]: https://github.com/gemini-ai/gemini-cli
[GitHub CLI]: https://cli.github.com/
