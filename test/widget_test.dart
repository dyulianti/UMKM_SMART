import 'package:flutter_test/flutter_test.dart';
import 'package:umkm_smart_assistant/main.dart';

void main() {
  testWidgets('app opens login and navigates to registration', (tester) async {
    await tester.pumpWidget(const UmkmSmartAssistant());
    expect(find.text('UMKM\nSMART ASSISTANT'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1300));
    expect(find.text('Selamat Datang!'), findsOneWidget);

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    expect(find.text('Buat Akun'), findsOneWidget);
  });
}
