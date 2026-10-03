import 'dart:io';

import 'portfolio_common.dart';

void main(List<String> args) {
  final Map<String, String> named = parseNamedArgs(args);
  final String rootPath = named['root'] ?? Directory.current.path;
  final String? slug = named['project'];

  final Directory portfolioRoot = Directory('$rootPath/portfolio');
  final List<Directory> projects = projectDirectories(portfolioRoot).where(
    (Directory dir) => slug == null || dir.path.endsWith('/$slug'),
  ).toList();

  if (projects.isEmpty) {
    stderr.writeln('No projects found to validate.');
    exitCode = 1;
    return;
  }

  final Set<String> knownSlugs = <String>{};
  final Set<String> knownIds = <String>{};
  final ValidationResult merged = ValidationResult();

  for (final Directory projectDirectory in projects) {
    final File projectFile = File('${projectDirectory.path}/project.json');
    if (!projectFile.existsSync()) {
      merged.addError('Missing project.json in ${projectDirectory.path}.');
      continue;
    }

    final Map<String, dynamic> project = parseJsonFile(projectFile);
    final ValidationResult projectResult = validateProjectJson(
      project,
      projectDirectory,
      knownSlugs: knownSlugs,
      knownIds: knownIds,
    );
    final ValidationResult mediaResult = validateMediaManifest(projectDirectory);

    merged.merge(projectResult);
    merged.merge(mediaResult);
  }

  for (final String warning in merged.warnings) {
    stdout.writeln('WARNING: $warning');
  }
  for (final String error in merged.errors) {
    stderr.writeln('ERROR: $error');
  }

  if (merged.isValid) {
    stdout.writeln('Project validation passed for ${projects.length} project(s).');
  } else {
    exitCode = 1;
  }
}
