import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lab3_appointment/app.dart';
import 'package:lab3_appointment/data/repositories/clinic_repository.dart';

/// Pune `true` ca prima încărcare să eșueze intenționat – așa se poate
/// demonstra starea „Error” și butonul „Try again”.
const bool kSimulateLoadError = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Bara de status transparentă cu iconițe închise, ca în design.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(
    AppointmentApp(
      repository: AssetClinicRepository(failFirstLoad: kSimulateLoadError),
    ),
  );
}
