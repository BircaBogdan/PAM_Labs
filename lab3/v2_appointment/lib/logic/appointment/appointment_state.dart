import 'package:flutter/foundation.dart';

import 'package:lab3_appointment/data/models/appointment_details.dart';
import 'package:lab3_appointment/data/models/doctor.dart';

enum AppointmentStatus { loading, success, error }

/// Starea trimiterii programării (butonul „Book an Appointment”).
enum BookingStatus { idle, inProgress, success, failure }

@immutable
class AppointmentState {
  const AppointmentState({
    this.status = AppointmentStatus.loading,
    this.doctor,
    this.details,
    this.selectedHourId,
    this.selectedDateId,
    this.bookingStatus = BookingStatus.idle,
    this.message,
  });

  final AppointmentStatus status;

  /// Medicul ales pe Homescreen; dacă e `null` se folosește cel din JSON.
  final Doctor? doctor;
  final AppointmentDetails? details;
  final String? selectedHourId;
  final String? selectedDateId;
  final BookingStatus bookingStatus;

  /// Mesajul de eroare sau de confirmare.
  final String? message;

  /// Medicul afișat pe ecran.
  Doctor? get displayedDoctor => doctor ?? details?.doctor;

  TimeSlot? get selectedHour => details?.workingHours.byId(selectedHourId);
  TimeSlot? get selectedDate => details?.dates.byId(selectedDateId);

  bool get canBook =>
      status == AppointmentStatus.success &&
      (details?.bookEnabled ?? false) &&
      selectedHour != null &&
      selectedDate != null &&
      bookingStatus != BookingStatus.inProgress;

  AppointmentState copyWith({
    AppointmentStatus? status,
    AppointmentDetails? details,
    String? selectedHourId,
    String? selectedDateId,
    BookingStatus? bookingStatus,
    ValueGetter<String?>? message,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      doctor: doctor,
      details: details ?? this.details,
      selectedHourId: selectedHourId ?? this.selectedHourId,
      selectedDateId: selectedDateId ?? this.selectedDateId,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      message: message != null ? message() : this.message,
    );
  }
}
