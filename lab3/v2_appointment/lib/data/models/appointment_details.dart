import 'package:lab3_appointment/data/models/doctor.dart';

/// Ce butoane de contact are medicul (`appointmentDetails.doctor.actions`).
class DoctorActions {
  const DoctorActions({
    this.message = true,
    this.call = true,
    this.videoCall = true,
  });

  factory DoctorActions.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const DoctorActions();
    return DoctorActions(
      message: json['message'] as bool? ?? false,
      call: json['call'] as bool? ?? false,
      videoCall: json['videoCall'] as bool? ?? false,
    );
  }

  final bool message;
  final bool call;
  final bool videoCall;
}

/// Prețul consultației (`appointmentDetails.payment`).
class Payment {
  const Payment({
    required this.label,
    required this.amount,
    required this.currency,
    required this.formatted,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    final amount = (json['amount'] as num).toDouble();
    final currency = json['currency'] as String? ?? 'USD';
    return Payment(
      label: json['label'] as String? ?? 'Payment',
      amount: amount,
      currency: currency,
      formatted:
          json['formatted'] as String? ??
          '$currency ${amount.toStringAsFixed(2)}',
    );
  }

  final String label;
  final double amount;
  final String currency;
  final String formatted;
}

/// O oră sau o zi ce poate fi aleasă.
class TimeSlot {
  const TimeSlot({
    required this.id,
    required this.label,
    this.selected = false,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] as String,
      label: json['label'] as String,
      selected: json['selected'] as bool? ?? false,
    );
  }

  final String id;
  final String label;

  /// Selecția implicită primită din JSON.
  final bool selected;
}

/// Secțiunile „Working Hours” și „Date”.
class SlotSection {
  const SlotSection({
    required this.title,
    required this.showAll,
    required this.slots,
  });

  factory SlotSection.fromJson(Map<String, dynamic> json) {
    return SlotSection(
      title: json['title'] as String,
      showAll: json['showAll'] as bool? ?? false,
      slots: [
        for (final item in json['slots'] as List<dynamic>? ?? [])
          TimeSlot.fromJson(item as Map<String, dynamic>),
      ],
    );
  }

  final String title;
  final bool showAll;
  final List<TimeSlot> slots;

  /// Slotul marcat `selected: true` în JSON sau, dacă lipsește, primul.
  String? get initialSelectedId {
    for (final slot in slots) {
      if (slot.selected) return slot.id;
    }
    return slots.isEmpty ? null : slots.first.id;
  }

  TimeSlot? byId(String? id) {
    for (final slot in slots) {
      if (slot.id == id) return slot;
    }
    return null;
  }
}

/// Datele ecranului „Appointment detailes” (cheia `appointmentDetails`).
class AppointmentDetails {
  const AppointmentDetails({
    required this.title,
    required this.doctor,
    required this.actions,
    required this.payment,
    required this.detailsTitle,
    required this.description,
    required this.workingHours,
    required this.dates,
    required this.bookLabel,
    required this.bookEnabled,
  });

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    final doctorJson = json['doctor'] as Map<String, dynamic>;
    final details = json['details'] as Map<String, dynamic>;
    final actions = json['actions'] as Map<String, dynamic>?;
    final book = actions?['bookAppointment'] as Map<String, dynamic>?;
    return AppointmentDetails(
      title: json['title'] as String? ?? 'Appointment',
      doctor: Doctor(
        id: 'appointment-details-doctor',
        name: doctorJson['name'] as String,
        // În acest ecran sub nume apare clinica („Denteeth”).
        specialty: doctorJson['clinic'] as String? ?? '',
        avatarUrl: doctorJson['avatarUrl'] as String? ?? '',
      ),
      actions: DoctorActions.fromJson(
        doctorJson['actions'] as Map<String, dynamic>?,
      ),
      payment: Payment.fromJson(json['payment'] as Map<String, dynamic>),
      detailsTitle: details['title'] as String? ?? 'Details',
      description: details['description'] as String? ?? '',
      workingHours: SlotSection.fromJson(
        json['workingHours'] as Map<String, dynamic>,
      ),
      dates: SlotSection.fromJson(json['date'] as Map<String, dynamic>),
      bookLabel: book?['label'] as String? ?? 'Book an Appointment',
      bookEnabled: book?['enabled'] as bool? ?? true,
    );
  }

  final String title;

  /// Medicul din design (Dr.Upul, clinica Denteeth).
  final Doctor doctor;
  final DoctorActions actions;
  final Payment payment;
  final String detailsTitle;
  final String description;
  final SlotSection workingHours;
  final SlotSection dates;
  final String bookLabel;
  final bool bookEnabled;
}

/// Răspunsul la o programare reușită.
class BookingConfirmation {
  const BookingConfirmation({
    required this.doctorName,
    required this.dateLabel,
    required this.hourLabel,
  });

  final String doctorName;
  final String dateLabel;
  final String hourLabel;

  String get summary => '$doctorName · $dateLabel · $hourLabel';
}
