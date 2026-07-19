import 'package:flutter_test/flutter_test.dart';

import 'package:tarot_app/app.dart';

void main() {
  testWidgets('Home screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const TarotApp());
    await tester.pump();

    expect(find.text('Queen of Swords'), findsWidgets);
    expect(find.text('New reading'), findsOneWidget);
  });
}
