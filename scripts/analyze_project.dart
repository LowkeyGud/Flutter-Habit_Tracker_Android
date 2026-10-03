import 'dart:io';

import 'portfolio_common.dart';

void main(List<String> args) {
  final Map<String, String> named = parseNamedArgs(args);
  final String rootPath = named['root'] ?? Directory.current.path;
  final String slug = named['project'] ?? 'habit-tracker';

  final Directory root = Directory(rootPath);
  final Directory outputDir = Directory('${root.path}/portfolio/analysis/$slug');
  outputDir.createSync(recursive: true);

  final Map<String, dynamic> analysis = analyzeRepository(
    repositoryRoot: root,
    projectSlug: slug,
  );

  File('${outputDir.path}/project-analysis.json')
      .writeAsStringSync(prettifyJson(analysis));
  File('${outputDir.path}/features.json').writeAsStringSync(
    prettifyJson(<String, dynamic>{
      'projectSlug': slug,
      'features':
          ((analysis['technologies'] as Map<String, dynamic>)['detectedHighlights']
                  as List<dynamic>?)
              ?.cast<String>() ??
              <String>[],
    }),
  );
  File('${outputDir.path}/technologies.json').writeAsStringSync(
    prettifyJson(<String, dynamic>{
      'projectSlug': slug,
      'technologies': analysis['technologies'],
    }),
  );
  File('${outputDir.path}/architecture.json').writeAsStringSync(
    prettifyJson(<String, dynamic>{
      'projectSlug': slug,
      'architecture': analysis['architecture'],
    }),
  );
  File('${outputDir.path}/media.json').writeAsStringSync(
    prettifyJson(<String, dynamic>{
      'projectSlug': slug,
      'media': analysis['media'],
    }),
  );
  File('${outputDir.path}/missing-information.json').writeAsStringSync(
    prettifyJson(<String, dynamic>{
      'projectSlug': slug,
      'missingInformation': analysis['missingInformation'],
    }),
  );

  stdout.writeln('Analysis generated at ${outputDir.path}');
}
