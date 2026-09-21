import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/progress_providers.dart';
import '../../domain/models/skill.dart';

class AssessmentScreen extends ConsumerWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsProvider);
    return skills.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Unable to load assessment: $error')),
      data: (items) => _AssessmentContent(skills: items),
    );
  }
}

class _AssessmentContent extends ConsumerWidget {
  const _AssessmentContent({required this.skills});
  final List<Skill> skills;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(progressStoreProvider);
    final ratedSkills = skills
        .map(
          (skill) =>
              skill.copyWith(current: store.ratingFor(skill.id, skill.current)),
        )
        .toList();
    final priorities = [...ratedSkills]
      ..sort((a, b) => (b.gap * b.importance).compareTo(a.gap * a.importance));
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skill-gap assessment',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Rate evidence you can defend today. A lower score is useful when it points to the next honest practice loop.',
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      for (final skill in priorities) _RatingRow(skill: skill),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingRow extends ConsumerWidget {
  const _RatingRow({required this.skill});
  final Skill skill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(progressStoreProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                'target ${skill.target}/5',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${skill.category} · interview importance ${skill.importance}/5',
          ),
          Slider(
            value: skill.current.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '${skill.current}',
            onChanged: (value) async {
              await store.setRating(skill.id, value.round());
              ref.invalidate(skillsProvider);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Needs evidence'),
              Text(
                'Current ${skill.current}/5',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const Text('Senior-ready'),
            ],
          ),
        ],
      ),
    );
  }
}
