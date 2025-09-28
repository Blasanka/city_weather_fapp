import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
  });
}
