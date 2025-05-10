import 'package:flutter_test/flutter_test.dart';
import 'package:kindos_app/main.dart';
import 'package:kindos_app/screens/login_screen.dart';

void main() {
  testWidgets('App should show login screen when not logged in',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Verify that login screen appears
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('CATATAN KINERJA DOSEN'), findsNothing);
  });
}
