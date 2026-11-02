import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';
import 'package:lab3_appointment/data/repositories/clinic_repository.dart';
import 'package:lab3_appointment/logic/doctors/doctors_cubit.dart';
import 'package:lab3_appointment/presentation/screens/home_screen.dart';

/// Rădăcina aplicației.
///
/// Repository-ul și [DoctorsCubit] sunt puse deasupra `MaterialApp`, ca să
/// fie disponibile pe toate ecranele (și în foaia „Filter & Sort”).
class AppointmentApp extends StatelessWidget {
  const AppointmentApp({super.key, required this.repository});

  final ClinicRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ClinicRepository>.value(
      value: repository,
      child: BlocProvider(
        // Încărcarea asincronă pornește imediat ce se creează Cubit-ul.
        create: (context) => DoctorsCubit(repository)..load(),
        child: MaterialApp(
          title: 'Appointment',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            scaffoldBackgroundColor: AppColors.white,
            fontFamily: AppText.openSansFamily,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
