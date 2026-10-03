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
    stderr.writeln('No draft found to publish.');
    exitCode = 1;
    return;
  }

  final Map<String, dynamic> draft = parseJsonFile(draftFile);
  final Map<String, dynamic> aiMetadata =
      (draft['aiMetadata'] as Map<String, dynamic>?) ?? <String, dynamic>{};

  if (aiMetadata['reviewStatus'] != 'human_reviewed') {
    stderr.writeln(
      'Draft must be reviewed before publishing. Current status: ${aiMetadata['reviewStatus']}',
    );
    exitCode = 1;
    return;
  }

  final Directory publishedDir =
      Directory('${projectDirectory.path}/case-study/published');
  final Directory revisionsDir =
      Directory('${projectDirectory.path}/case-study/revisions');
  publishedDir.createSync(recursive: true);
  revisionsDir.createSync(recursive: true);

  final File approvedFile = File('${publishedDir.path}/case-study.approved.json');
  if (approvedFile.existsSync()) {
    final String backupName = 'case-study.approved-${nowTimestamp()}.json';
    approvedFile.copySync('${revisionsDir.path}/$backupName');
  }

  draft['workflowState'] = 'published';
  aiMetadata['reviewStatus'] = 'approved';
  aiMetadata['approvedAt'] = DateTime.now().toUtc().toIso8601String();
  draft['aiMetadata'] = aiMetadata;

  approvedFile.writeAsStringSync(prettifyJson(draft));
  stdout.writeln('Published case study to ${approvedFile.path}');
}
