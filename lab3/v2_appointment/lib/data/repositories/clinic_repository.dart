import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:lab3_appointment/data/models/appointment_details.dart';
import 'package:lab3_appointment/data/models/clinic_data.dart';
import 'package:lab3_appointment/data/models/doctor.dart';
import 'package:lab3_appointment/data/models/home_data.dart';

/// Sursa de date a aplicației. Cubit-urile depind doar de această interfață,
/// așa că în teste ea poate fi înlocuită cu o implementare falsă.
abstract interface class ClinicRepository {
  /// Datele pentru Homescreen (utilizator, programare, servicii, medici).
  Future<HomeData> fetchHome();

  /// Datele pentru ecranul de programare.
  Future<AppointmentDetails> fetchAppointmentDetails();

  /// Trimite programarea și întoarce confirmarea.
  Future<BookingConfirmation> bookAppointment({
    required Doctor doctor,
    required TimeSlot date,
    required TimeSlot hour,
  });
}

/// Eroare la citirea sau interpretarea datelor.
class ClinicDataException implements Exception {
  const ClinicDataException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Citește asincron fișierul JSON inclus în proiect (`assets/data/`).
///
/// [latency] imită timpul de răspuns al unui server, ca să se vadă starea
/// „Loading”. Cu [failFirstLoad] = true prima încărcare eșuează intenționat,
/// pentru a demonstra starea „Error” și butonul „Try again”.
class AssetClinicRepository implements ClinicRepository {
  AssetClinicRepository({
    this.assetPath = 'assets/data/lab_v2.json',
    AssetBundle? bundle,
    this.latency = const Duration(milliseconds: 900),
    this.failFirstLoad = false,
  }) : _bundle = bundle ?? rootBundle;

  final String assetPath;
  final AssetBundle _bundle;
  final Duration latency;
  final bool failFirstLoad;

  bool _failedOnce = false;

  Future<ClinicData> _readData() async {
    await Future<void>.delayed(latency);

    if (failFirstLoad && !_failedOnce) {
      _failedOnce = true;
      throw const ClinicDataException(
        'The server did not respond. Please try again.',
      );
    }

    final raw = await _loadRaw();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('The root of the JSON must be an object.');
      }
      return ClinicData.fromJson(decoded);
    } on FormatException catch (error) {
      throw ClinicDataException('Invalid JSON: ${error.message}');
    } on TypeError {
      throw const ClinicDataException(
        'The JSON file does not have the expected structure.',
      );
    }
  }

  Future<String> _loadRaw() async {
    try {
      return await _bundle.loadString(assetPath);
    } catch (_) {
      throw ClinicDataException('Data file not found: $assetPath');
    }
  }

  @override
  Future<HomeData> fetchHome() async => (await _readData()).home;

  @override
  Future<AppointmentDetails> fetchAppointmentDetails() async {
    return (await _readData()).appointmentDetails;
  }

  @override
  Future<BookingConfirmation> bookAppointment({
    required Doctor doctor,
    required TimeSlot date,
    required TimeSlot hour,
  }) async {
    await Future<void>.delayed(latency);
    return BookingConfirmation(
      doctorName: doctor.name,
      dateLabel: date.label,
      hourLabel: hour.label,
    );
  }
}
