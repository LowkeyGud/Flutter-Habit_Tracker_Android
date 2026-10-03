import 'dart:io';

import 'portfolio_common.dart';

void main(List<String> args) {
  final Map<String, String> named = parseNamedArgs(args);
  final String rootPath = named['root'] ?? Directory.current.path;
  final String? slug = named['slug'];
  final String title = named['title'] ?? '';

  if (slug == null || slug.isEmpty) {
    stderr.writeln('Usage: dart run scripts/create_project_entry.dart --slug <slug> [--title "Project Title"]');
    exitCode = 1;
    return;
  }

  final Directory templateDir =
      Directory('$rootPath/portfolio/projects/_template');
  final Directory targetDir = Directory('$rootPath/portfolio/projects/$slug');

  if (!templateDir.existsSync()) {
    stderr.writeln('Template directory missing: ${templateDir.path}');
    exitCode = 1;
    return;
  }

  if (targetDir.existsSync()) {
    stderr.writeln('Project directory already exists: ${targetDir.path}');
    exitCode = 1;
    return;
  }

  targetDir.createSync(recursive: true);
  Directory('${targetDir.path}/media').createSync(recursive: true);
  Directory('${targetDir.path}/documents').createSync(recursive: true);
  Directory('${targetDir.path}/evidence').createSync(recursive: true);
  Directory('${targetDir.path}/case-study/drafts').createSync(recursive: true);
  Directory('${targetDir.path}/case-study/published').createSync(recursive: true);
  Directory('${targetDir.path}/case-study/revisions').createSync(recursive: true);

  final File readmeTemplate = File('${templateDir.path}/README.template.md');
  final File projectTemplate = File('${templateDir.path}/project.template.json');
  final File mediaTemplate = File('${templateDir.path}/media.template.yml');

  final String projectTitle = title.isEmpty ? slug : title;

  final String readme = readmeTemplate
      .readAsStringSync()
      .replaceAll('{{project_title}}', projectTitle);

  final Map<String, dynamic> projectJson = parseJsonFile(projectTemplate)
    ..['slug'] = slug
    ..['id'] = 'project-$slug'
    ..['title'] = projectTitle;

  File('${targetDir.path}/README.md').writeAsStringSync(readme);
  File('${targetDir.path}/story.md').writeAsStringSync('# $projectTitle\n\nDraft narrative.\n');
  File('${targetDir.path}/project.json').writeAsStringSync(prettifyJson(projectJson));
  File('${targetDir.path}/media.yml')
      .writeAsStringSync(mediaTemplate.readAsStringSync());
  File('${targetDir.path}/case-study/latest-draft.json').writeAsStringSync(
    prettifyJson(<String, dynamic>{
      'draftId': null,
      'path': null,
      'generatedAt': null,
    }),
  );

  stdout.writeln('Created project entry at ${targetDir.path}');
}
