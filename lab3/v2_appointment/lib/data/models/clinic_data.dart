import 'package:lab3_appointment/data/models/appointment_details.dart';
import 'package:lab3_appointment/data/models/home_data.dart';

/// Rădăcina fișierului `assets/data/lab_v2.json`.
class ClinicData {
  const ClinicData({required this.home, required this.appointmentDetails});

  factory ClinicData.fromJson(Map<String, dynamic> json) {
    return ClinicData(
      home: HomeData.fromJson(json['homeScreen'] as Map<String, dynamic>),
      appointmentDetails: AppointmentDetails.fromJson(
        json['appointmentDetails'] as Map<String, dynamic>,
      ),
    );
  }

  final HomeData home;
  final AppointmentDetails appointmentDetails;
}
