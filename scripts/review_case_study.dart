import 'dart:io';

import 'portfolio_common.dart';

void main(List<String> args) {
  final Map<String, String> named = parseNamedArgs(args);
  final String rootPath = named['root'] ?? Directory.current.path;
  final String slug = named['project'] ?? 'habit-tracker';

  final String? explicitDraftPath = named['draft'];
  final Directory projectDirectory =
      Directory('$rootPath/portfolio/projects/$slug');

  File? draftFile;
  if (explicitDraftPath != null) {
    draftFile = File(explicitDraftPath.startsWith('/')
        ? explicitDraftPath
        : '$rootPath/$explicitDraftPath');
  } else {
    final File latest =
        File('${projectDirectory.path}/case-study/latest-draft.json');
    if (latest.existsSync()) {
      final Map<String, dynamic> latestData = parseJsonFile(latest);
      final String relativePath = latestData['path'].toString();
      draftFile = File('$rootPath/$relativePath');
    }
  }

  if (draftFile == null || !draftFile.existsSync()) {
    stderr.writeln('No draft found to review.');
    exitCode = 1;
    return;
  }

  final Map<String, dynamic> draft = parseJsonFile(draftFile);
  final Map<String, dynamic> aiMetadata =
      (draft['aiMetadata'] as Map<String, dynamic>?) ?? <String, dynamic>{};

  aiMetadata['reviewStatus'] = 'human_reviewed';
  aiMetadata['reviewedAt'] = DateTime.now().toUtc().toIso8601String();
  draft['aiMetadata'] = aiMetadata;
  draft['workflowState'] = 'human_review';

  draftFile.writeAsStringSync(prettifyJson(draft));
  stdout.writeln('Draft marked as reviewed: ${draftFile.path}');
}
