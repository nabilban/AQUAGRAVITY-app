import 'package:flutter_test/flutter_test.dart';
import 'package:aquagravity/bootstrap.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AquaGravityApp(environment: 'test'));

    // Verify the app builds without errors
    expect(find.text('AQUAGRAVITY'), findsOneWidget);
  });
}
