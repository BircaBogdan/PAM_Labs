import 'package:lab3_appointment/data/models/doctor.dart';
import 'package:lab3_appointment/data/models/home_data.dart';

/// Criteriile de sortare a listei de medici.
enum DoctorSort {
  nearest('Nearest'),
  nameAsc('Name A–Z'),
  nameDesc('Name Z–A');

  const DoctorSort(this.label);

  final String label;
}

/// Cuvintele-cheie din specialitate care corespund fiecărui serviciu
/// din „Health Services” (id-urile din JSON).
const Map<String, List<String>> _serviceKeywords = {
  'tooth': ['dental', 'dentist', 'tooth', 'teeth', 'orthodont'],
  'eye': ['eye', 'ophthalm', 'optometr', 'vision'],
  'lungs': ['lung', 'pulmo', 'respirat'],
  'ear': ['ear', 'ent', 'otolaryng', 'audiolog', 'hearing'],
};

final RegExp _nonLetters = RegExp(r'[^a-z]+');
final RegExp _doctorPrefix = RegExp(r'^dr\.?\s*');

/// `true` dacă specialitatea medicului ține de [service].
bool doctorMatchesService(Doctor doctor, HealthService service) {
  final keywords =
      _serviceKeywords[service.id] ?? [service.name.toLowerCase()];
  final words = doctor.specialty
      .toLowerCase()
      .split(_nonLetters)
      .where((word) => word.isNotEmpty);
  return words.any(
    (word) => keywords.any((keyword) => word.startsWith(keyword)),
  );
}

/// Căutarea: după nume, specialitate sau adresă (fără diferență de majuscule).
bool doctorMatchesQuery(Doctor doctor, String query) {
  final text = query.trim().toLowerCase();
  if (text.isEmpty) return true;
  return doctor.name.toLowerCase().contains(text) ||
      doctor.specialty.toLowerCase().contains(text) ||
      (doctor.location?.toLowerCase().contains(text) ?? false);
}

String _sortableName(Doctor doctor) =>
    doctor.name.toLowerCase().replaceFirst(_doctorPrefix, '');

int _compareByName(Doctor a, Doctor b) =>
    _sortableName(a).compareTo(_sortableName(b));

/// Aplică pe rând căutarea, filtrul de serviciu, filtrul de favorite
/// și sortarea. Lista inițială nu este modificată.
List<Doctor> applyDoctorFilters({
  required List<Doctor> doctors,
  String query = '',
  HealthService? service,
  bool favoritesOnly = false,
  DoctorSort sort = DoctorSort.nearest,
}) {
  final result = doctors
      .where((doctor) => doctorMatchesQuery(doctor, query))
      .where((doctor) => service == null || doctorMatchesService(doctor, service))
      .where((doctor) => !favoritesOnly || doctor.isFavorite)
      .toList();

  switch (sort) {
    case DoctorSort.nearest:
      result.sort((a, b) {
        final byDistance = (a.distanceMeters ?? double.infinity).compareTo(
          b.distanceMeters ?? double.infinity,
        );
        return byDistance != 0 ? byDistance : _compareByName(a, b);
      });
    case DoctorSort.nameAsc:
      result.sort(_compareByName);
    case DoctorSort.nameDesc:
      result.sort((a, b) => _compareByName(b, a));
  }
  return result;
}
