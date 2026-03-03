import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  if (args.length != 1) {
    print('Usage: create_summarize_issues_prompt <issue query>');
    return;
  }

  final query = args[0];
  final token = Platform.environment['GITHUB_TOKEN'];

  final headers = {
    'Accept': 'application/vnd.github.v3+json',
    if (token != null) 'Authorization': 'token $token',
    'User-Agent': 'flutter_triage_tools',
  };

  // 1. Fetch issues using GitHub SEARCH API
  // We grab the title, body, and number
  final searchUri = Uri.https('api.github.com', '/search/issues', {
    'q': '$query repo:flutter/flutter',
  });

  final searchResponse = await http.get(searchUri, headers: headers);
  if (searchResponse.statusCode != 200) {
    print('Error fetching issues: ${searchResponse.statusCode} ${searchResponse.body}');
    return;
  }

  final searchData = jsonDecode(searchResponse.body) as Map<String, dynamic>;
  final issues = searchData['items'] as List<dynamic>;

  final buffer = StringBuffer();
  buffer.writeln('''
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
''');

  // 2. Wrap issues in XML tags
  buffer.writeln('<collection>');
  for (final issueJson in issues) {
    final issue = issueJson as Map<String, dynamic>;
    final number = issue['number'] as int;
    final title = issue['title'] as String;
    final body = issue['body'] as String? ?? '';
    final user = issue['user'] as Map<String, dynamic>;
    final author = user['login'] as String;
    final association = issue['author_association'] as String;

    // Fetch comments using GitHub API
    final commentsUri = Uri.https('api.github.com', '/repos/flutter/flutter/issues/$number/comments');
    final commentsResponse = await http.get(commentsUri, headers: headers);

    if (commentsResponse.statusCode != 200) {
      print('Error fetching comments for issue #$number: ${commentsResponse.statusCode}');
      return;
    }

    final commentsData = jsonDecode(commentsResponse.body) as List<dynamic>;
    
    // Structure the comments dump similarly to how `gh issue view --comments` does it
    final dumpBuffer = StringBuffer();
    dumpBuffer.writeln('author: $author');
    dumpBuffer.writeln('association: ${association.toLowerCase()}');
    dumpBuffer.writeln('edited: false');
    dumpBuffer.writeln('status: none');
    dumpBuffer.writeln('--');
    dumpBuffer.writeln(body);
    dumpBuffer.writeln('--');

    for (final comment in commentsData) {
      final c = comment as Map<String, dynamic>;
      final cAuthor = c['user']['login'] as String;
      final cAssociation = c['author_association'] as String;
      final cBody = c['body'] as String? ?? '';

      dumpBuffer.writeln('author: $cAuthor');
      dumpBuffer.writeln('association: ${cAssociation.toLowerCase()}');
      dumpBuffer.writeln('edited: false');
      dumpBuffer.writeln('status: none');
      dumpBuffer.writeln('--');
      dumpBuffer.writeln(cBody);
      dumpBuffer.writeln('--');
    }

    buffer.writeln('  <issue id="$number">');
    buffer.writeln('    <title>$title</title>');
    buffer.writeln('    <body>');
    buffer.writeln(body);
    buffer.writeln('    </body>');
    buffer.writeln('    <comments>');
    buffer.writeln(dumpBuffer.toString());
    buffer.writeln('    </comments>');
    buffer.writeln('  </issue>');
  }

  buffer.writeln('</collection>');

  // 3. Output for you to copy-paste
  print(buffer.toString());
}

