import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab3_appointment/app.dart';
import 'package:lab3_appointment/presentation/widgets/favorite_button.dart';

import 'helpers/fake_clinic_repository.dart';

const emmly = 'Dr. Emmly Lestiryno';
const sonja = 'Dr. Sonja Litel';

/// Un telefon obișnuit: 1080 × 2340 px la densitatea 2.625 (≈ 411 × 891 dp).
void usePhoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

bool isFavorite(WidgetTester tester, Key key) =>
    tester.widget<FavoriteButton>(find.byKey(key)).isFavorite;

void main() {
  testWidgets('Loading -> Success', (tester) async {
    usePhoneSize(tester);
    final repository = FakeClinicRepository(
      loadSampleData(),
      delay: const Duration(milliseconds: 500),
    );

    await tester.pumpWidget(AppointmentApp(repository: repository));
    await tester.pump();
    expect(find.text('Loading doctors...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text(emmly), findsOneWidget);
    expect(find.text(sonja), findsOneWidget);
  });

  testWidgets('Error -> Try again -> Success', (tester) async {
    usePhoneSize(tester);
    final repository = FakeClinicRepository(
      loadSampleData(),
      failuresBeforeSuccess: 1,
    );

    await tester.pumpWidget(AppointmentApp(repository: repository));
    await tester.pumpAndSettle();
    expect(find.text('Something went wrong'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Jonathan'), findsOneWidget);
  });

  testWidgets('Search, Empty state and clear filters', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(
      AppointmentApp(repository: FakeClinicRepository(loadSampleData())),
    );
    await tester.pumpAndSettle();

    final search = find.byKey(const Key('search-field'));
    await tester.enterText(search, 'sonja');
    await tester.pumpAndSettle();
    expect(find.text(emmly), findsNothing);
    expect(find.text(sonja), findsOneWidget);

    await tester.enterText(search, 'nobody');
    await tester.pumpAndSettle();
    expect(find.text('No doctors found'), findsOneWidget);

    await tapVisible(tester, find.text('Clear filters'));
    expect(find.text(emmly), findsOneWidget);
    expect(find.text(sonja), findsOneWidget);

    // Filtrul „Tooth” din Health Services lasă doar medicul stomatolog.
    await tapVisible(tester, find.byKey(const Key('service-tooth')));
    expect(find.text(emmly), findsNothing);
    expect(find.text(sonja), findsOneWidget);
  });

  testWidgets('Favorite -> details page -> book appointment', (
    tester,
  ) async {
    usePhoneSize(tester);
    await tester.pumpWidget(
      AppointmentApp(repository: FakeClinicRepository(loadSampleData())),
    );
    await tester.pumpAndSettle();

    const listHeart = Key('favorite-doctor-002');
    expect(isFavorite(tester, listHeart), isFalse);
    await tapVisible(tester, find.byKey(listHeart));
    expect(isFavorite(tester, listHeart), isTrue);

    // Pagina de detalii a medicului.
    await tapVisible(tester, find.text(sonja));
    expect(find.text(sonja), findsOneWidget);
    expect(find.text('Dental Specialist'), findsOneWidget);
    expect(find.text(r'$120.00'), findsOneWidget);
    expect(find.text('Book an Appointment'), findsOneWidget);

    // Inima de pe pagina de detalii e sincronizată cu lista.
    const detailsHeart = Key('details-favorite');
    expect(isFavorite(tester, detailsHeart), isTrue);
    await tester.tap(find.byKey(detailsHeart));
    await tester.pumpAndSettle();
    expect(isFavorite(tester, detailsHeart), isFalse);

    // Alegem altă oră și programăm.
    await tester.tap(find.byKey(const Key('slot-10am')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('book-button')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(SnackBar),
        matching: find.textContaining('10.00 AM'),
      ),
      findsOneWidget,
    );

    // Lăsăm SnackBar-ul să dispară (durata implicită 4 s).
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('back-button')));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(isFavorite(tester, listHeart), isFalse);
  });

  testWidgets('See All opens the full list with sorting', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(
      AppointmentApp(repository: FakeClinicRepository(loadSampleData())),
    );
    await tester.pumpAndSettle();

    await tapVisible(tester, find.text('See All').last);
    expect(find.text('Nearby Doctor'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sort-nameDesc')));
    await tester.pumpAndSettle();
    final sonjaY = tester.getTopLeft(find.text(sonja)).dy;
    final emmlyY = tester.getTopLeft(find.text(emmly)).dy;
    expect(sonjaY, lessThan(emmlyY));
  });
}
