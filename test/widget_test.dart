import 'package:flutter_test/flutter_test.dart';
import 'package:moneylender/main.dart';

void main() {
  testWidgets('Example test', (WidgetTester tester) async {
    await tester
        .pumpWidget(MyApp()); // Remove 'const' from the constructor invocation
    expect(find.text('Home'), findsOneWidget);
  });
}
