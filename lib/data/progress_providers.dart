import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'progress_store.dart';

final progressStoreProvider = Provider<ProgressStore>((ref) {
  return ProgressStore(Hive.box<dynamic>('coach_progress'));
});

final planCompletionProvider = StateProvider<Map<int, bool>>((ref) => {});
