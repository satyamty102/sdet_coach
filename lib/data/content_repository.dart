import 'dart:convert';
import 'package:flutter/services.dart';

import '../domain/models/plan_day.dart';
import '../domain/models/skill.dart';

class ContentRepository {
  Future<List<Skill>> loadSkills() async {
    final raw = await rootBundle.loadString('assets/content/skills.json');
    final data = jsonDecode(raw) as List<dynamic>;
    return data
        .map((item) => Skill.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<PlanDay>> loadPlanDays() async {
    final raw = await rootBundle.loadString('assets/content/plan_days.json');
    final data = jsonDecode(raw) as List<dynamic>;
    return data
        .map((item) => PlanDay.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
