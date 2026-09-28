import 'package:flutter_test/flutter_test.dart';
import 'package:ts_studio/main.dart';

void main() {
  testWidgets('TS Studio app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TSStudioApp());
    expect(find.text('TS STUDIO'), findsOneWidget);
  });
}
