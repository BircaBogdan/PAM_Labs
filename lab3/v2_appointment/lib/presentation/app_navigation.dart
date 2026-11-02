import 'package:flutter/material.dart';

import 'package:lab3_appointment/data/models/doctor.dart';
import 'package:lab3_appointment/presentation/screens/appointment_screen.dart';
import 'package:lab3_appointment/presentation/screens/doctors_screen.dart';

/// SnackBar folosit în toată aplicația.
void showAppMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

/// Deschide pagina de detalii / programare a medicului.
/// Fără [doctor] se deschide medicul din JSON (`appointmentDetails`).
void openAppointment(BuildContext context, {Doctor? doctor}) {
  Navigator.of(context).push(AppointmentScreen.route(doctor: doctor));
}

/// Deschide lista completă „Nearby Doctor”.
void openDoctors(BuildContext context) {
  Navigator.of(context).push(DoctorsScreen.route());
}
