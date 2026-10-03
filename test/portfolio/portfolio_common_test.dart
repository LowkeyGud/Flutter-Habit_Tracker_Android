import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../scripts/portfolio_common.dart';

void main() {
  group('media validation', () {
    test('fails when referenced media file is missing', () {
      final Directory root = Directory.systemTemp.createTempSync('portfolio-test-');
      addTearDown(() => root.deleteSync(recursive: true));

      final Directory project = Directory('${root.path}/project')..createSync(recursive: true);
      File('${project.path}/media.yml').writeAsStringSync('''
schemaVersion: 1.0.0
assets:
  - id: hero
    path: media/hero/missing.png
    type: real-product-screenshot
''');

      final ValidationResult result = validateMediaManifest(project);
      expect(result.isValid, isFalse);
      expect(result.errors.join(' '), contains('Missing media file'));
    });
  });

  group('project validation', () {
    test('flags unknown media references in case-study sections', () {
      final Directory root = Directory.systemTemp.createTempSync('portfolio-project-');
      addTearDown(() => root.deleteSync(recursive: true));

      final Directory project = Directory('${root.path}/habit-tracker')..createSync(recursive: true);
      File('${project.path}/media.yml').writeAsStringSync('''
schemaVersion: 1.0.0
assets:
  - id: known-media
    path: media/hero/hero.png
    type: design-artifact
''');
      Directory('${project.path}/media/hero').createSync(recursive: true);
      File('${project.path}/media/hero/hero.png').writeAsBytesSync(<int>[1, 2, 3]);

      final Map<String, dynamic> projectJson = <String, dynamic>{
        'id': 'project-1',
        'slug': 'habit-tracker',
        'title': 'Habit Tracker',
        'status': 'active',
        'ownership': <String, dynamic>{'type': 'solo'},
        'responsibilities': <String>['Architecture'],
        'features': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'f-1',
            'name': 'Feature',
            'description': 'Desc',
            'status': 'done',
            'sourceFiles': <String>[],
            'media': <String>[]
          }
        ],
        'caseStudy': <String, dynamic>{
          'sections': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 's-1',
              'order': 1,
              'media': <String>['unknown-media'],
              'evidence': <String>[]
            }
          ]
        }
      };

      final ValidationResult result = validateProjectJson(
        projectJson,
        project,
        knownSlugs: <String>{},
        knownIds: <String>{},
      );

      expect(result.isValid, isFalse);
      expect(result.errors.join(' '), contains('unknown media id'));
    });
  });

  group('case study generation', () {
    test('buildCaseStudyDraft keeps section ordering and metadata', () {
      final Map<String, dynamic> draft = buildCaseStudyDraft(
        project: <String, dynamic>{
          'id': 'project-habit-tracker',
          'slug': 'habit-tracker',
          'title': 'Habit Tracker',
          'caseStudy': <String, dynamic>{
            'sections': <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 'hero',
                'type': 'cinematic-hero',
                'title': 'Hero',
                'content': 'Hello',
                'media': <String>['asset-1'],
                'evidence': <String>['file:README.md'],
                'order': 1
              }
            ]
          }
        },
        draftId: 'draft-1',
      );

      expect(draft['workflowState'], 'draft');
      expect((draft['sections'] as List<dynamic>).length, 1);
      final Map<String, dynamic> aiMetadata = draft['aiMetadata'] as Map<String, dynamic>;
      expect(aiMetadata['generated'], isTrue);
      expect(aiMetadata['reviewStatus'], 'generated');
    });
  });

  group('repository analysis', () {
    test('detects flutter + pub dependencies from sample repository', () {
      final Directory root = Directory.systemTemp.createTempSync('portfolio-analysis-');
      addTearDown(() => root.deleteSync(recursive: true));

      File('${root.path}/pubspec.yaml').writeAsStringSync('''
name: sample
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  cloud_firestore: ^4.8.1
''');
      Directory('${root.path}/lib/src/features/core').createSync(recursive: true);
      File('${root.path}/lib/main.dart').writeAsStringSync('''
import 'package:get/get.dart';
void main() {
  GetMaterialApp(home: const SizedBox());
}
''');
      File('${root.path}/lib/src/features/core/app.dart').writeAsStringSync('Get.to(() => const SizedBox());');
      Directory('${root.path}/assets/images').createSync(recursive: true);
      File('${root.path}/assets/images/a.png').writeAsBytesSync(<int>[1, 2, 3]);

      final Map<String, dynamic> analysis = analyzeRepository(
        repositoryRoot: root,
        projectSlug: 'sample',
      );

      expect((analysis['repository'] as Map<String, dynamic>)['framework'], 'Flutter');
      expect((analysis['technologies'] as Map<String, dynamic>)['dependencies'], contains('get'));
      expect((analysis['media'] as Map<String, dynamic>)['assetCount'], 1);
      expect(jsonEncode(analysis), contains('GetX'));
    });
  });
}
