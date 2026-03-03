# Flutter triage tools

## Instructions

1. Install [Gemini CLI][Gemini CLI].
2. Optional: Authenticate to GitHub using [GitHub CLI][GitHub CLI].

   ```sh
   export GITHUB_TOKEN=$(gh auth token) 
   ```

3. Create a prompt to triage issues:

   ```sh
   query="is:open is:issue label:team-text-input,fyi-text-input no:assignee -label:triaged-text-input"
   dart run bin/create_summarize_issues_prompt.dart "$query" > prompt.md
   ```

4. Run Gemini:

   ```sh
   cat prompt.md | gemini > output.md
   ```

5. Review the output in `output.md`.

[Gemini CLI]: https://github.com/gemini-ai/gemini-cli
[GitHub CLI]: https://cli.github.com/
