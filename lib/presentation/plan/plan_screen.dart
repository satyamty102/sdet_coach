import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/progress_providers.dart';
import '../../domain/models/plan_day.dart';

final planDaysProvider = FutureProvider<List<PlanDay>>((ref) {
  return ref.read(contentRepositoryProvider).loadPlanDays();
});

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(planDaysProvider);
    return plan.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Unable to load the plan: $error')),
      data: (days) => _PlanContent(days: days),
    );
  }
}

class _PlanContent extends ConsumerWidget {
  const _PlanContent({required this.days});
  final List<PlanDay> days;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completion = ref.watch(planCompletionProvider);
    final done = completion.values.where((value) => value).length;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Six-week plan',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Two focused hours a day. Build the explanation, implementation, and evidence together.',
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Week 1 · Baseline and leverage',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            '$done/${days.length} complete',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: days.isEmpty ? 0 : done / days.length,
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (final day in days) _DayCard(day: day),
              const SizedBox(height: 12),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lock_clock_outlined),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Weeks 2–6 unlock after the baseline mock. Use the gap analysis to choose depth instead of trying to cover everything equally.',
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

class _DayCard extends ConsumerWidget {
  const _DayCard({required this.day});
  final PlanDay day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(progressStoreProvider);
    final current =
        ref.watch(planCompletionProvider)[day.day] ??
        store.isDayComplete(day.day);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        initiallyExpanded: day.day == 1,
        leading: CircleAvatar(child: Text('${day.day}')),
        title: Text(
          day.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          day.day == 7
              ? 'Mock interview and gap analysis'
              : '${day.topics.length} focused blocks',
        ),
        trailing: Checkbox(
          value: current,
          onChanged: (value) async {
            final next = value ?? false;
            await store.setDayComplete(day.day, next);
            ref
                .read(planCompletionProvider.notifier)
                .update((state) => {...state, day.day: next});
          },
        ),
        childrenPadding: const EdgeInsets.fromLTRB(72, 0, 20, 20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final topic in day.topics)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('•  '),
                      Expanded(child: Text(topic)),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Expected outcome',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(day.outcome),
            ],
          ),
        ],
      ),
    );
  }
}
