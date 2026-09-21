import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/skill.dart';
import 'content_repository.dart';
import 'progress_providers.dart';

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => ContentRepository(),
);
final skillsProvider = FutureProvider<List<Skill>>((ref) async {
  final skills = await ref.read(contentRepositoryProvider).loadSkills();
  final store = ref.read(progressStoreProvider);
  return skills
      .map(
        (skill) =>
            skill.copyWith(current: store.ratingFor(skill.id, skill.current)),
      )
      .toList();
});
