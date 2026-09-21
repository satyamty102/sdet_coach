import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/models/skill.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsProvider);
    return skills.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Unable to load offline content: $error')),
      data: (items) => _DashboardContent(skills: items),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.skills});
  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    final priorities = [...skills]
      ..sort((a, b) => (b.gap * b.importance).compareTo(a.gap * a.importance));
    final average =
        skills.fold<double>(0, (sum, skill) => sum + skill.current) /
        skills.length;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, SDET.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Build evidence, not memorized answers. Your next high-leverage moves are below.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricCard(
                    label: 'CURRENT LEVEL',
                    value: '${average.toStringAsFixed(1)} / 5',
                    detail: 'Self-assessed average',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const _MetricCard(
                    label: 'THIS WEEK',
                    value: 'Week 1',
                    detail: 'Senior baseline',
                    color: Color(0xFFE66B4D),
                  ),
                  const _MetricCard(
                    label: 'STREAK',
                    value: '0 days',
                    detail: 'Start with Day 1',
                    color: Color(0xFF6A6D3B),
                  ),
                  const _MetricCard(
                    label: 'MOCK SCORE',
                    value: '-- / 40',
                    detail: 'Complete your first round',
                    color: Color(0xFF405A72),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              LayoutBuilder(
                builder: (context, constraints) {
                  final stacked = constraints.maxWidth < 780;
                  final gap = _SkillGapCard(skills: skills);
                  final priority = _PriorityCard(
                    skills: priorities.take(5).toList(),
                  );
                  return stacked
                      ? Column(
                          children: [gap, const SizedBox(height: 16), priority],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: gap),
                            const SizedBox(width: 16),
                            Expanded(flex: 2, child: priority),
                          ],
                        );
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.route_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s move',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Explain how you would debug a Playwright test that passes locally but fails in Jenkins. Write the evidence you would collect before changing code.',
                            ),
                          ],
                        ),
                      ),
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

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.detail,
    required this.color,
  });
  final String label;
  final String value;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 220,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(detail, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ),
  );
}

class _SkillGapCard extends StatelessWidget {
  const _SkillGapCard({required this.skills});
  final List<Skill> skills;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skill gap to senior target',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your self-rating against the bar expected in senior interviews.',
          ),
          const SizedBox(height: 18),
          for (final skill in skills)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _SkillBar(skill: skill),
            ),
        ],
      ),
    ),
  );
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({required this.skill});
  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final progress = skill.current / skill.target;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(skill.name)),
            Text(
              '${skill.current}/${skill.target}',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            color: skill.gap >= 2
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _PriorityCard extends StatelessWidget {
  const _PriorityCard({required this.skills});
  final List<Skill> skills;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ranked priorities',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 4),
          const Text('Gap x interview importance'),
          const SizedBox(height: 12),
          for (var index = 0; index < skills.length; index++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(radius: 15, child: Text('${index + 1}')),
              title: Text(skills[index].name),
              subtitle: Text('${skills[index].gap} point gap'),
              trailing: Text(
                '${skills[index].gap * skills[index].importance}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
        ],
      ),
    ),
  );
}
