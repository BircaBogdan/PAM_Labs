import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:v2_appointment/main.dart';

void main() {
  testWidgets('Homescreen -> Appointment -> Book', (tester) async {
    // Un telefon obișnuit: 1080 × 2340 px la densitatea 2.625 (≈ 411 × 891 dp).
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Homescreen
    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);
    expect(find.text('Nearby Doctor'), findsOneWidget);

    // Cardul „Appointment” deschide ecranul de programare.
    await tester.tap(find.text('Appointment'));
    await tester.pumpAndSettle();

    expect(find.text('Dr.Upul'), findsOneWidget);
    expect(find.text('Working Hours'), findsOneWidget);
    expect(find.text('Book an Appointment'), findsOneWidget);

    // Alegem altă oră și confirmăm programarea.
    await tester.tap(find.text('10.00 AM'));
    await tester.pump();
    await tester.tap(find.text('Book an Appointment'));
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(SnackBar),
        matching: find.textContaining('10.00 AM'),
      ),
      findsOneWidget,
    );

    // Lăsăm SnackBar-ul să apară complet, apoi să dispară (durata implicită 4 s),
    // ca să nu rămână timere active la finalul testului.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Săgeata „înapoi” revine la Homescreen.
    await tester.tap(find.byKey(const Key('back-button')));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Jonathan'), findsOneWidget);
  });
}
