import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  // args = [
  //   'is:open is:issue label:team-text-input,fyi-text-input no:assignee -label:triaged-text-input',
  // ];
  if (args.length != 1) {
    print('Usage: flutter_triage_tools <issue query>');
    return;
  }

  final query = args[0];

  // 1. Fetch issues using GitHub CLI
  // We grab the title, body, and number (id)
  final result = await Process.run('gh', [
    'issue',
    'list',
    '--repo',
    'flutter/flutter',
    '--search',
    query,
    '--json',
    'number,title,body',
  ]);

  if (result.exitCode != 0) {
    print('Error fetching issues: ${result.stderr}');
    return;
  }
  final issues = jsonDecode(result.stdout) as List<dynamic>;

  final buffer = StringBuffer();
  buffer.writeln('''
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
''');

  // 2. Wrap issues in XML tags
  buffer.writeln('<collection>');
  for (final issueJson in issues) {
    final issue = issueJson as Map<String, dynamic>;
    final number = issue['number'] as int;
    final title = issue['title'] as String;
    final body = issue['body'] as String;

    final dumpResult = await Process.run('gh', [
      'issue',
      'view',
      '--repo',
      'flutter/flutter',
      '--comments',
      number.toString(),
    ]);

    if (dumpResult.exitCode != 0) {
      print('Error fetching issue: ${dumpResult.stderr}');
      return;
    }

    final dump = dumpResult.stdout;
    buffer.writeln('  <issue id="$number">');
    buffer.writeln('    <title>$title</title>');
    buffer.writeln('    <body>');
    buffer.writeln(body);
    buffer.writeln('    </body>');
    buffer.writeln('    <comments>');
    buffer.writeln(dump);
    buffer.writeln('    </comments>');
    buffer.writeln('  </issue>');
  }

  buffer.writeln('</collection>');

  // 3. Output for you to copy-paste
  print(buffer.toString());
}
