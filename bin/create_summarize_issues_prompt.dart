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
Summarize each of the following GitHub issues and pull requests.

Suggest a title for each, in sentence case. If the issue is specific to a
platform, prefix the title with the platform name, e.g. "[Android]" or "[iOS]".

If the issue has a screenshot or video, include a link to it. Ensure there is
an empty line before the screenshot/video URL.
</instructions>

<example_output>

# [Android] Backspace is not sent to TextField

**Link**: [flutter#123](https://github.com/flutter/flutter/issues/123)

**Summary**: When Backspace is pressed on a virtual keyboard of certain Samsung
devices, the keypress is not sent to the TextField. This appears to be a bug in
`_HighlightModeManager`: it assumes all `KeyMessage`s are physical key presses,
however, Android's backspace virtual key can send a `KeyMessage`.

**Screenshot or video**:

https://github.com/user-attachments/assets/abcdef

</example_output>
''');

  // 2. Wrap issues in XML tags
  buffer.writeln('<collection>');
  for (final issueJson in issues) {
    final issue = issueJson as Map<String, dynamic>;
    final number = issue['number'] as int;
    final title = issue['title'] as String;
    final body = issue['body'] as String? ?? '';
    final isPr = issue['pull_request'] != null;
    final type = isPr ? 'pull_request' : 'issue';

    buffer.writeln('  <$type id="$number">');
    buffer.writeln('    <title>$title</title>');
    buffer.writeln('    <body>');
    buffer.writeln(body);
    buffer.writeln('    </body>');
    buffer.writeln('    <comments>');

    // Fetch comments using GitHub API
    if (isPr) {
      final reviewsUri = Uri.https('api.github.com', '/repos/flutter/flutter/pulls/$number/comments');
      final reviewsResponse = await http.get(reviewsUri, headers: headers);
      if (reviewsResponse.statusCode == 200) {
        final reviewsData = jsonDecode(reviewsResponse.body) as List<dynamic>;
        for (final review in reviewsData) {
          final r = review as Map<String, dynamic>;
          final reviewAuthor = r['user']['login'] as String;
          final reviewBody = r['body'] as String? ?? '';

          buffer.writeln('      <comment author="$reviewAuthor">');
          buffer.writeln(reviewBody);
          buffer.writeln('      </comment>');
        }
      } else {
        print('Warning: skipping reviews for $type #$number due to status code ${reviewsResponse.statusCode}');
      }
    } else {
      final commentsUri = Uri.https('api.github.com', '/repos/flutter/flutter/issues/$number/comments');
      final commentsResponse = await http.get(commentsUri, headers: headers);

      if (commentsResponse.statusCode == 200) {
        final commentsData = jsonDecode(commentsResponse.body) as List<dynamic>;
        for (final comment in commentsData) {
          final c = comment as Map<String, dynamic>;
          final commentAuthor = c['user']['login'] as String;
          final commentBody = c['body'] as String? ?? '';

          buffer.writeln('      <comment author="$commentAuthor">');
          buffer.writeln(commentBody);
          buffer.writeln('      </comment>');
        }
      } else {
        print('Warning: skipping comments for $type #$number due to status code ${commentsResponse.statusCode}');
      }
    }

    buffer.writeln('    </comments>');
    buffer.writeln('  </$type>');
  }

  buffer.writeln('</collection>');

  // 3. Output for you to copy-paste
  print(buffer.toString());
}
