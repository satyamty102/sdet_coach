class PlanDay {
  const PlanDay({
    required this.day,
    required this.week,
    required this.title,
    required this.topics,
    required this.outcome,
  });

  final int day;
  final int week;
  final String title;
  final List<String> topics;
  final String outcome;

  factory PlanDay.fromJson(Map<String, dynamic> json) => PlanDay(
    day: json['day'] as int,
    week: json['week'] as int,
    title: json['title'] as String,
    topics: (json['topics'] as List<dynamic>).cast<String>(),
    outcome: json['outcome'] as String,
  );
}
