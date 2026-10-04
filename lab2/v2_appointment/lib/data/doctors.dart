/// Modelul unui medic afișat în aplicație.
class Doctor {
  const Doctor({
    required this.name,
    required this.specialty,
    required this.photo,
    this.price = '\$120.00',
    this.address,
    this.about = Doctors.loremDetails,
  });

  final String name;
  final String specialty;

  /// Calea către imagine în `assets/images/`.
  final String photo;
  final String price;
  final String? address;
  final String about;
}

/// Datele din cele două ecrane Figma.
abstract final class Doctors {
  static const String loremDetails =
      'Worem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate '
      'libero et velit interdum, ac aliquet odio mattis. Class aptent taciti '
      'sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. '
      'Curabitur tempus urna at turpis condimentum lobortis. Ut commodo '
      'efficitur neque. Ut diam quam, semper iaculis condimentum ac, '
      'vestibulum eu nisl.';

  /// Medicul din ecranul „Appointment detailes”.
  static const Doctor upul = Doctor(
    name: 'Dr.Upul',
    specialty: 'Denteeth',
    photo: 'assets/images/doctor_upul.png',
  );

  /// Medicul din cardul „Appointment” de pe Homescreen.
  static const Doctor richar = Doctor(
    name: 'Dr. Richar Kandowen',
    specialty: 'Child Specialist',
    photo: 'assets/images/doctor_richar.png',
  );

  /// Lista „Nearby Doctor” de pe Homescreen.
  static const List<Doctor> nearby = [
    Doctor(
      name: 'Dr. Emmly Lestiryno',
      specialty: 'General Practitioner',
      photo: 'assets/images/doctor_emmly.png',
      address: '3167 Durgan Shores - 500M from you',
    ),
    Doctor(
      name: 'Dr. Sonja Littel',
      specialty: 'Dental Specialist',
      photo: 'assets/images/doctor_sonja.png',
      address: '950 Sigrid Port - 753M from you',
    ),
  ];
}
