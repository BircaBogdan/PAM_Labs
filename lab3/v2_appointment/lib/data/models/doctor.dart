/// Un medic (elementele din `homeScreen.nearbyDoctors` din JSON).
class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.avatarUrl,
    this.location,
    this.isFavorite = false,
  });

  /// [fallbackId] se folosește pentru medicii din JSON care nu au cheia `id`
  /// (de ex. medicul din cardul „Appointment”).
  factory Doctor.fromJson(Map<String, dynamic> json, {String? fallbackId}) {
    final name = json['name'] as String;
    return Doctor(
      id: json['id'] as String? ?? fallbackId ?? name,
      name: name,
      specialty: json['specialty'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      location: json['distance'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  final String id;
  final String name;
  final String specialty;
  final String avatarUrl;

  /// Adresa + distanța, de ex. „3167 Durgan Shores - 500M from you”.
  final String? location;
  final bool isFavorite;

  /// Distanța în metri extrasă din [location] (folosită la sortare).
  double? get distanceMeters => parseDistanceMeters(location);

  Doctor copyWith({bool? isFavorite}) {
    return Doctor(
      id: id,
      name: name,
      specialty: specialty,
      avatarUrl: avatarUrl,
      location: location,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() => 'Doctor($id, $name)';
}

final RegExp _distancePattern = RegExp(
  r'(\d+(?:[.,]\d+)?)\s*(km|m)\b',
  caseSensitive: false,
);

/// „950 Sigrid Port - 753M from you” → 753, „... 1.2KM from you” → 1200.
///
/// Se ia ultima potrivire, ca numărul din adresă să nu fie confundat
/// cu distanța.
double? parseDistanceMeters(String? text) {
  if (text == null) return null;
  final matches = _distancePattern.allMatches(text).toList();
  if (matches.isEmpty) return null;
  final match = matches.last;
  final value = double.tryParse(match.group(1)!.replaceAll(',', '.'));
  if (value == null) return null;
  return match.group(2)!.toLowerCase() == 'km' ? value * 1000 : value;
}
