import 'package:hive/hive.dart';

class ProgressStore {
  ProgressStore(this._box);

  final Box<dynamic> _box;

  bool isDayComplete(int day) =>
      _box.get('plan_day_$day', defaultValue: false) as bool;

  Future<void> setDayComplete(int day, bool value) =>
      _box.put('plan_day_$day', value);

  int ratingFor(String skillId, int fallback) =>
      _box.get('skill_rating_$skillId', defaultValue: fallback) as int;

  Future<void> setRating(String skillId, int value) =>
      _box.put('skill_rating_$skillId', value);
}
