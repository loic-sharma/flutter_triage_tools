# Flutter triage tools

### Accessibility (`team-accessibility`)

* [Incoming issue list](output/Accessibility%20issues.md)

### Design Languages team (`team-design`)

* [Incoming issue list](output/Design%20issues.md)
* [Pull requests](output/Design%20pulls.md)

### Text input (`team-text-input`)

* [Incoming issue list](output/Text%20input%20issues.md)
* [Pull requests](output/Text%20input%20pulls.md)

## Instructions

1. Install [Gemini CLI][Gemini CLI].
2. Optional: Authenticate to GitHub using [GitHub CLI][GitHub CLI].

   ```sh
   export GITHUB_TOKEN=$(gh auth token)
   ```

3. Summarize text input issues:

   ```sh
   query='is:open is:issue label:team-text-input,fyi-text-input no:assignee -label:triaged-text-input -label:"waiting for customer response"'
   dart run bin/create_summarize_issues_prompt.dart "$query" > prompt.md
   cat prompt.md | gemini > "output/Text input issues.md"
   ```

4. Summarize text input pulls:

   ```sh
   query='is:open is:pr sort:created-desc draft:false label:"a: text input",team-text-input,fyi-text-input'
   dart run bin/create_summarize_issues_prompt.dart "$query" > prompt.md
   cat prompt.md | gemini > "output/Text input pulls.md"
   ```

5. Check the `output/` directory.

[Gemini CLI]: https://github.com/gemini-ai/gemini-cli
[GitHub CLI]: https://cli.github.com/
