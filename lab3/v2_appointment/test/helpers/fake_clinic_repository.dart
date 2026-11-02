import 'dart:convert';
import 'dart:io';

import 'package:lab3_appointment/data/models/appointment_details.dart';
import 'package:lab3_appointment/data/models/clinic_data.dart';
import 'package:lab3_appointment/data/models/doctor.dart';
import 'package:lab3_appointment/data/models/home_data.dart';
import 'package:lab3_appointment/data/repositories/clinic_repository.dart';

/// Citește fișierul JSON real al proiectului (testele rulează din rădăcina
/// proiectului).
ClinicData loadSampleData() {
  final raw = File('assets/data/lab_v2.json').readAsStringSync();
  return ClinicData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

/// Repository fals pentru teste: date din memorie, întârziere configurabilă
/// și eșecuri la cerere.
class FakeClinicRepository implements ClinicRepository {
  FakeClinicRepository(
    this.data, {
    this.delay = Duration.zero,
    this.failuresBeforeSuccess = 0,
  });

  final ClinicData data;
  final Duration delay;
  int failuresBeforeSuccess;

  Future<void> _wait() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (failuresBeforeSuccess > 0) {
      failuresBeforeSuccess--;
      throw const ClinicDataException('Network error');
    }
  }

  @override
  Future<HomeData> fetchHome() async {
    await _wait();
    return data.home;
  }

  @override
  Future<AppointmentDetails> fetchAppointmentDetails() async {
    await _wait();
    return data.appointmentDetails;
  }

  @override
  Future<BookingConfirmation> bookAppointment({
    required Doctor doctor,
    required TimeSlot date,
    required TimeSlot hour,
  }) async {
    await _wait();
    return BookingConfirmation(
      doctorName: doctor.name,
      dateLabel: date.label,
      hourLabel: hour.label,
    );
  }
}
