import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:senior_sdet_interview_coach/app.dart';

void main() {
  testWidgets('app shell opens dashboard', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SdetCoachApp()));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard'), findsAtLeastNWidgets(1));
  });
}
