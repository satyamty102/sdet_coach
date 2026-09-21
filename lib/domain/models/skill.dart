class Skill {
  const Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.current,
    required this.target,
    required this.importance,
  });

  final String id;
  final String name;
  final String category;
  final int current;
  final int target;
  final int importance;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    current: json['current'] as int,
    target: json['target'] as int,
    importance: json['importance'] as int,
  );

  int get gap => target - current;

  Skill copyWith({int? current}) => Skill(
    id: id,
    name: name,
    category: category,
    current: current ?? this.current,
    target: target,
    importance: importance,
  );
}
