import 'dart:io';

import 'portfolio_common.dart';

void main(List<String> args) {
  final Map<String, String> named = parseNamedArgs(args);
  final String rootPath = named['root'] ?? Directory.current.path;
  final String slug = named['project'] ?? 'habit-tracker';

  final Directory projectDirectory =
      Directory('$rootPath/portfolio/projects/$slug');
  final File projectFile = File('${projectDirectory.path}/project.json');
  if (!projectFile.existsSync()) {
    stderr.writeln('Missing project.json for $slug.');
    exitCode = 1;
    return;
  }

  final Map<String, dynamic> project = parseJsonFile(projectFile);
  final String timestamp = nowTimestamp();
  final String draftId = 'draft-$timestamp';

  final Map<String, dynamic> draft =
      buildCaseStudyDraft(project: project, draftId: draftId);

  final Directory draftsDir =
      Directory('${projectDirectory.path}/case-study/drafts');
  draftsDir.createSync(recursive: true);

  final File draftFile = File('${draftsDir.path}/case-study-$timestamp.json');
  draftFile.writeAsStringSync(prettifyJson(draft));

  final File latestPointer =
      File('${projectDirectory.path}/case-study/latest-draft.json');
  latestPointer.writeAsStringSync(prettifyJson(<String, dynamic>{
    'draftId': draftId,
    'path': draftFile.path.replaceFirst('$rootPath/', ''),
    'generatedAt': (draft['aiMetadata'] as Map<String, dynamic>)['generatedAt'],
  }));

  stdout.writeln('Generated case-study draft: ${draftFile.path}');
}
