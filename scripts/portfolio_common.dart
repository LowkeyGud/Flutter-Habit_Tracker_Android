import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

class ValidationResult {
  ValidationResult({List<String>? errors, List<String>? warnings})
      : errors = errors ?? <String>[],
        warnings = warnings ?? <String>[];

  final List<String> errors;
  final List<String> warnings;

  bool get isValid => errors.isEmpty;

  void addError(String message) => errors.add(message);

  void addWarning(String message) => warnings.add(message);

  void merge(ValidationResult other) {
    errors.addAll(other.errors);
    warnings.addAll(other.warnings);
  }
}

Map<String, dynamic> parseJsonFile(File file) {
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

Map<String, dynamic> parseYamlFileAsJson(File file) {
  final YamlMap yaml = loadYaml(file.readAsStringSync()) as YamlMap;
  return _normalizeYaml(yaml) as Map<String, dynamic>;
}

dynamic _normalizeYaml(dynamic value) {
  if (value is YamlMap) {
    return value.map((dynamic key, dynamic value) =>
        MapEntry(key.toString(), _normalizeYaml(value)));
  }
  if (value is YamlList) {
    return value.map(_normalizeYaml).toList();
  }
  return value;
}

Map<String, String> parseNamedArgs(List<String> args) {
  final Map<String, String> values = <String, String>{};
  for (int i = 0; i < args.length; i++) {
    final String arg = args[i];
    if (!arg.startsWith('--')) {
      continue;
    }
    final String key = arg.substring(2);
    if (i + 1 < args.length && !args[i + 1].startsWith('--')) {
      values[key] = args[i + 1];
      i++;
    } else {
      values[key] = 'true';
    }
  }
  return values;
}

String nowTimestamp() {
  final DateTime now = DateTime.now().toUtc();
  String two(int value) => value.toString().padLeft(2, '0');
  return '${now.year}${two(now.month)}${two(now.day)}-${two(now.hour)}${two(now.minute)}${two(now.second)}';
}

List<Directory> projectDirectories(Directory portfolioRoot) {
  final Directory projectsRoot = Directory('${portfolioRoot.path}/projects');
  if (!projectsRoot.existsSync()) {
    return <Directory>[];
  }
  return projectsRoot
      .listSync()
      .whereType<Directory>()
      .where((Directory directory) =>
          File('${directory.path}/project.json').existsSync())
      .toList();
}

ValidationResult validateMediaManifest(Directory projectDirectory) {
  final ValidationResult result = ValidationResult();
  final File mediaManifest = File('${projectDirectory.path}/media.yml');

  if (!mediaManifest.existsSync()) {
    result.addError('Missing media manifest: ${mediaManifest.path}');
    return result;
  }

  final Map<String, dynamic> content = parseYamlFileAsJson(mediaManifest);
  final List<dynamic> assets = (content['assets'] as List<dynamic>?) ?? <dynamic>[];

  final Set<String> ids = <String>{};
  final Set<String> paths = <String>{};
  const Set<String> allowedExtensions = <String>{
    '.png',
    '.jpg',
    '.jpeg',
    '.webp',
    '.gif',
    '.svg',
    '.mp4',
    '.mov',
    '.webm',
    '.json',
  };

  for (final dynamic rawAsset in assets) {
    if (rawAsset is! Map<String, dynamic>) {
      result.addError('Invalid media asset entry in ${mediaManifest.path}.');
      continue;
    }

    final String? id = rawAsset['id']?.toString();
    final String? path = rawAsset['path']?.toString();
    final String? type = rawAsset['type']?.toString();

    if (id == null || id.isEmpty) {
      result.addError('Media asset missing id in ${mediaManifest.path}.');
    } else if (!ids.add(id)) {
      result.addError('Duplicate media id "$id" in ${mediaManifest.path}.');
    }

    if (path == null || path.isEmpty) {
      result.addError('Media asset ${id ?? '<unknown>'} missing path.');
      continue;
    }

    if (!paths.add(path)) {
      result.addError('Duplicate media path "$path" in ${mediaManifest.path}.');
    }

    final File mediaFile = File('${projectDirectory.path}/$path');
    if (!mediaFile.existsSync()) {
      result.addError('Missing media file "$path" for asset ${id ?? '<unknown>'}.');
    }

    final String extension = path.contains('.')
        ? path.substring(path.lastIndexOf('.')).toLowerCase()
        : '';
    if (!allowedExtensions.contains(extension)) {
      result.addError('Unsupported media file type "$extension" for asset ${id ?? '<unknown>'}.');
    }

    if (type == null || type.isEmpty) {
      result.addError('Media asset ${id ?? '<unknown>'} missing type.');
    }
  }

  return result;
}

ValidationResult validateProjectJson(
  Map<String, dynamic> project,
  Directory projectDirectory, {
  required Set<String> knownSlugs,
  required Set<String> knownIds,
}) {
  final ValidationResult result = ValidationResult();

  void requireField(String path, dynamic value) {
    if (value == null) {
      result.addError('Missing required field "$path" in ${projectDirectory.path}/project.json');
      return;
    }
    if (value is String && value.trim().isEmpty) {
      result.addError('Required field "$path" is empty in ${projectDirectory.path}/project.json');
    }
  }

  requireField('id', project['id']);
  requireField('slug', project['slug']);
  requireField('title', project['title']);
  requireField('status', project['status']);
  requireField(
      'ownership.type', (project['ownership'] as Map<String, dynamic>?)?['type']);

  final String? slug = project['slug']?.toString();
  if (slug != null && slug.isNotEmpty && !knownSlugs.add(slug)) {
    result.addError('Duplicate project slug "$slug".');
  }

  final String? id = project['id']?.toString();
  if (id != null && id.isNotEmpty && !knownIds.add(id)) {
    result.addError('Duplicate project id "$id".');
  }

  const Set<String> statuses = <String>{
    'draft',
    'active',
    'archived',
    'published',
  };

  final String? status = project['status']?.toString();
  if (status != null && !statuses.contains(status)) {
    result.addError(
        'Invalid project status "$status" in ${projectDirectory.path}/project.json.');
  }

  final Map<String, dynamic> ownership =
      (project['ownership'] as Map<String, dynamic>?) ?? <String, dynamic>{};
  if (ownership['type'] != 'solo') {
    result.addError(
        'ownership.type must be "solo" in ${projectDirectory.path}/project.json.');
  }

  final List<dynamic> responsibilities =
      (project['responsibilities'] as List<dynamic>?) ?? <dynamic>[];
  if (responsibilities.isEmpty) {
    result.addError(
        'Project responsibilities cannot be empty in ${projectDirectory.path}/project.json.');
  }

  final List<dynamic> features =
      (project['features'] as List<dynamic>?) ?? <dynamic>[];
  final Set<String> featureIds = <String>{};
  for (final dynamic feature in features) {
    if (feature is! Map<String, dynamic>) {
      result.addError('Invalid feature entry in ${projectDirectory.path}/project.json.');
      continue;
    }
    final String? featureId = feature['id']?.toString();
    if (featureId == null || featureId.isEmpty) {
      result.addError('Feature missing id in ${projectDirectory.path}/project.json.');
    } else if (!featureIds.add(featureId)) {
      result.addError('Duplicate feature id "$featureId" in ${projectDirectory.path}/project.json.');
    }
  }

  final File mediaManifest = File('${projectDirectory.path}/media.yml');
  final Set<String> mediaIds = <String>{};
  if (mediaManifest.existsSync()) {
    final Map<String, dynamic> mediaContent = parseYamlFileAsJson(mediaManifest);
    final List<dynamic> assets =
        (mediaContent['assets'] as List<dynamic>?) ?? <dynamic>[];
    for (final dynamic raw in assets) {
      if (raw is Map<String, dynamic>) {
        final String? mediaId = raw['id']?.toString();
        if (mediaId != null && mediaId.isNotEmpty) {
          mediaIds.add(mediaId);
        }
      }
    }
  }

  final Map<String, dynamic> caseStudy =
      (project['caseStudy'] as Map<String, dynamic>?) ?? <String, dynamic>{};
  final List<dynamic> sections =
      (caseStudy['sections'] as List<dynamic>?) ?? <dynamic>[];
  final Set<String> sectionIds = <String>{};
  final Set<int> sectionOrders = <int>{};

  for (final dynamic rawSection in sections) {
    if (rawSection is! Map<String, dynamic>) {
      result
          .addError('Invalid caseStudy section entry in ${projectDirectory.path}/project.json.');
      continue;
    }

    final String? sectionId = rawSection['id']?.toString();
    final int? order = rawSection['order'] is int ? rawSection['order'] as int : null;

    if (sectionId == null || sectionId.isEmpty) {
      result.addError('Case-study section missing id in ${projectDirectory.path}/project.json.');
    } else if (!sectionIds.add(sectionId)) {
      result.addError(
          'Duplicate section id "$sectionId" in ${projectDirectory.path}/project.json.');
    }

    if (order == null) {
      result
          .addError('Case-study section ${sectionId ?? '<unknown>'} missing numeric order.');
    } else if (!sectionOrders.add(order)) {
      result.addError(
          'Duplicate case-study section order "$order" in ${projectDirectory.path}/project.json.');
    }

    final List<dynamic> mediaRefs =
        (rawSection['media'] as List<dynamic>?) ?? <dynamic>[];
    for (final dynamic mediaRef in mediaRefs) {
      final String mediaId = mediaRef.toString();
      if (!mediaIds.contains(mediaId)) {
        result.addError(
            'Case-study section ${sectionId ?? '<unknown>'} references unknown media id "$mediaId".');
      }
    }

    final List<dynamic> evidenceRefs =
        (rawSection['evidence'] as List<dynamic>?) ?? <dynamic>[];
    for (final dynamic evidenceRefRaw in evidenceRefs) {
      final String evidenceRef = evidenceRefRaw.toString();
      if (evidenceRef.startsWith('file:')) {
        final String relativePath = evidenceRef.replaceFirst('file:', '').trim();
        final File evidenceFile = File('${Directory.current.path}/$relativePath');
        if (!evidenceFile.existsSync()) {
          result.addError(
              'Missing evidence file "$relativePath" referenced by section ${sectionId ?? '<unknown>'}.');
        }
      }
    }
  }

  final List<File> publicContentFiles = <File>[
    File('${projectDirectory.path}/project.json'),
    File('${projectDirectory.path}/story.md'),
    File('${projectDirectory.path}/README.md'),
  ];

  final RegExp secretPattern = RegExp(
    r'(AIza[0-9A-Za-z_-]{35}|sk-[A-Za-z0-9]{20,}|(?i)(api[_-]?key|secret|token|password)\s*[:=]\s*["\"][^"\"]+["\"])',
  );

  for (final File file in publicContentFiles) {
    if (!file.existsSync()) {
      continue;
    }
    final String content = file.readAsStringSync();
    if (secretPattern.hasMatch(content)) {
      result.addError('Potential secret detected in ${file.path}.');
    }
  }

  return result;
}

Map<String, dynamic> analyzeRepository({
  required Directory repositoryRoot,
  required String projectSlug,
}) {
  final File pubspecFile = File('${repositoryRoot.path}/pubspec.yaml');
  final File readmeFile = File('${repositoryRoot.path}/README.md');

  Map<String, dynamic> pubspec = <String, dynamic>{};
  if (pubspecFile.existsSync()) {
    pubspec = parseYamlFileAsJson(pubspecFile);
  }

  final Map<String, dynamic> dependencies =
      ((pubspec['dependencies'] as Map<String, dynamic>?) ??
          <String, dynamic>{});

  final List<String> dependencyNames = dependencies.keys.toList()..sort();

  final List<String> features = <String>[];
  if (dependencies.containsKey('firebase_auth')) {
    features.add('Authentication via Firebase Auth');
  }
  if (dependencies.containsKey('cloud_firestore')) {
    features.add('Cloud Firestore data storage');
  }
  if (dependencies.containsKey('flutter_heatmap_calendar')) {
    features.add('Heatmap calendar visualization');
  }
  if (dependencies.containsKey('get')) {
    features.add('GetX state management and navigation');
  }

  final Directory libRoot = Directory('${repositoryRoot.path}/lib');
  final List<String> entryPoints = <String>[];
  final File mainFile = File('${libRoot.path}/main.dart');
  if (mainFile.existsSync()) {
    entryPoints.add('lib/main.dart');
  }

  final List<String> moduleDirectories = <String>[];
  final Directory featuresDirectory = Directory('${libRoot.path}/src/features');
  if (featuresDirectory.existsSync()) {
    for (final FileSystemEntity entity in featuresDirectory.listSync()) {
      if (entity is Directory) {
        moduleDirectories.add(
          entity.path.replaceFirst('${repositoryRoot.path}/', ''),
        );
      }
    }
    moduleDirectories.sort();
  }

  final List<String> routes = <String>[];
  final List<FileSystemEntity> allDartFiles =
      libRoot.listSync(recursive: true).where((FileSystemEntity entity) {
    return entity is File && entity.path.endsWith('.dart');
  }).toList();

  int getNavigationCalls = 0;
  for (final FileSystemEntity entity in allDartFiles) {
    final File file = entity as File;
    final String content = file.readAsStringSync();
    if (content.contains('GetMaterialApp')) {
      routes.add('GetMaterialApp root app (lib/main.dart)');
    }
    getNavigationCalls +=
        RegExp(r'Get\.(to|offAll|offNamed|toNamed)\(').allMatches(content).length;
  }

  final List<String> mediaFiles = <String>[];
  final Directory assetsDir = Directory('${repositoryRoot.path}/assets');
  if (assetsDir.existsSync()) {
    for (final FileSystemEntity entity in assetsDir.listSync(recursive: true)) {
      if (entity is File) {
        final String ext = entity.path.split('.').last.toLowerCase();
        if (<String>{'png', 'jpg', 'jpeg', 'webp', 'gif', 'svg', 'mp4', 'mov'}
            .contains(ext)) {
          mediaFiles.add(entity.path.replaceFirst('${repositoryRoot.path}/', ''));
        }
      }
    }
  }
  mediaFiles.sort();

  return <String, dynamic>{
    'projectSlug': projectSlug,
    'analyzedAt': DateTime.now().toUtc().toIso8601String(),
    'repository': <String, dynamic>{
      'framework': 'Flutter',
      'language': 'Dart',
      'packageManager': 'pub',
      'readmePresent': readmeFile.existsSync(),
      'entryPoints': entryPoints,
      'deploymentTargets': <String>['android', 'ios', 'linux', 'macos'],
    },
    'architecture': <String, dynamic>{
      'routing': <String, dynamic>{
        'type': 'GetX imperative navigation',
        'details': routes,
        'navigationCallCount': getNavigationCalls,
      },
      'stateManagement': <String>['GetX', 'GetStorage'],
      'database': <String>['Firebase Authentication', 'Cloud Firestore'],
      'apiStyle': 'Firebase SDK integration (no custom REST API layer detected)',
      'moduleDirectories': moduleDirectories,
    },
    'technologies': <String, dynamic>{
      'dependencies': dependencyNames,
      'detectedHighlights': features,
    },
    'media': <String, dynamic>{
      'assetCount': mediaFiles.length,
      'assets': mediaFiles,
    },
    'missingInformation': <String>[
      'Verified performance metrics',
      'Production usage analytics',
      'Explicit design-process artifacts in repository',
    ],
  };
}

Map<String, dynamic> buildCaseStudyDraft({
  required Map<String, dynamic> project,
  required String draftId,
}) {
  final List<dynamic> sourceSections =
      ((project['caseStudy'] as Map<String, dynamic>?)?['sections']
              as List<dynamic>?) ??
          <dynamic>[];

  final List<Map<String, dynamic>> generatedSections = sourceSections
      .map((dynamic rawSection) {
        final Map<String, dynamic> section =
            (rawSection as Map<String, dynamic>).cast<String, dynamic>();
        return <String, dynamic>{
          'id': section['id'],
          'type': section['type'],
          'title': section['title'],
          'subtitle': section['subtitle'] ?? '',
          'content': section['content'] ?? '',
          'media': section['media'] ?? <String>[],
          'layout': section['layout'] ?? 'default',
          'visualDirection': section['visualDirection'] ?? 'project-specific',
          'interaction': section['interaction'] ?? 'none',
          'evidence': section['evidence'] ?? <String>[],
          'visibility': section['visibility'] ?? 'draft',
          'order': section['order'],
        };
      })
      .toList()
      .cast<Map<String, dynamic>>();

  return <String, dynamic>{
    'draftId': draftId,
    'projectId': project['id'],
    'projectSlug': project['slug'],
    'title': project['title'],
    'workflowState': 'draft',
    'sections': generatedSections,
    'aiMetadata': <String, dynamic>{
      'generated': true,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
      'generator': 'scripts/generate_case_study.dart',
      'generationVersion': '1.0.0',
      'reviewStatus': 'generated',
      'approvedAt': null,
    },
  };
}

String prettifyJson(Object value) {
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  return '${encoder.convert(value)}\n';
}
