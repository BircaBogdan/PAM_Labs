import 'package:flutter_test/flutter_test.dart';

import 'package:lab3_appointment/data/models/doctor.dart';

import 'helpers/fake_clinic_repository.dart';

void main() {
  test('lab_v2.json is parsed into models', () {
    final data = loadSampleData();

    expect(data.home.user.greeting, 'Hi, Jonathan');
    expect(data.home.hasUnreadNotifications, isTrue);
    expect(data.home.searchHint, 'Search something');
    expect(data.home.appointment.doctor.name, 'Dr. Richar Kandowen');
    expect(data.home.services.map((s) => s.id), [
      'tooth',
      'eye',
      'lungs',
      'ear',
    ]);
    expect(data.home.doctors.map((d) => d.id), ['doctor-001', 'doctor-002']);

    final details = data.appointmentDetails;
    expect(details.doctor.name, 'Dr.Upul');
    expect(details.doctor.specialty, 'Denteeth');
    expect(details.payment.formatted, r'$120.00');
    expect(details.workingHours.slots, hasLength(3));
    expect(details.workingHours.initialSelectedId, '11am');
    expect(details.dates.initialSelectedId, 'sun-4');
    expect(details.bookLabel, 'Book an Appointment');
  });

  test('distance is extracted from the address text', () {
    expect(parseDistanceMeters('3167 Durgan Shores - 500M from you'), 500);
    expect(parseDistanceMeters('950 Sigrid Port - 753M from you'), 753);
    expect(parseDistanceMeters('12 Main St - 1.2KM from you'), 1200);
    expect(parseDistanceMeters('Somewhere'), isNull);
    expect(parseDistanceMeters(null), isNull);
  });
}
