import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/skill.dart';
import 'content_repository.dart';

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => ContentRepository(),
);
final skillsProvider = FutureProvider<List<Skill>>(
  (ref) => ref.read(contentRepositoryProvider).loadSkills(),
);
