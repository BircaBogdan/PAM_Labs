import 'package:flutter/foundation.dart';

import 'package:lab3_appointment/data/models/doctor.dart';
import 'package:lab3_appointment/data/models/home_data.dart';
import 'package:lab3_appointment/logic/doctors/doctor_filters.dart';

/// Stările principale ale ecranelor cu medici.
enum DoctorsStatus {
  /// Încă nu s-a cerut nimic.
  initial,

  /// Datele se încarcă asincron din JSON.
  loading,

  /// Există medici de afișat.
  success,

  /// Datele s-au încărcat, dar lista (după căutare/filtre) e goală.
  empty,

  /// Încărcarea a eșuat.
  error,
}

@immutable
class DoctorsState {
  const DoctorsState({
    this.status = DoctorsStatus.initial,
    this.home,
    this.doctors = const [],
    this.visibleDoctors = const [],
    this.query = '',
    this.serviceId,
    this.sort = DoctorSort.nearest,
    this.favoritesOnly = false,
    this.errorMessage,
  });

  final DoctorsStatus status;

  /// Datele Homescreen; `null` până la prima încărcare reușită.
  final HomeData? home;

  /// Toți medicii (cu starea „favorit” curentă).
  final List<Doctor> doctors;

  /// Medicii rămași după căutare, filtrare și sortare.
  final List<Doctor> visibleDoctors;

  final String query;

  /// Id-ul serviciului selectat din „Health Services” (filtru).
  final String? serviceId;
  final DoctorSort sort;
  final bool favoritesOnly;
  final String? errorMessage;

  bool get isLoading =>
      status == DoctorsStatus.initial || status == DoctorsStatus.loading;

  /// Câte filtre sunt active (pentru indicatorul de pe butonul de filtre).
  int get activeFilterCount =>
      (query.trim().isNotEmpty ? 1 : 0) +
      (serviceId != null ? 1 : 0) +
      (favoritesOnly ? 1 : 0) +
      (sort != DoctorSort.nearest ? 1 : 0);

  bool get hasActiveFilters => activeFilterCount > 0;

  int get favoritesCount => doctors.where((doctor) => doctor.isFavorite).length;

  HealthService? get selectedService {
    final services = home?.services ?? const <HealthService>[];
    for (final service in services) {
      if (service.id == serviceId) return service;
    }
    return null;
  }

  /// Medicul cu [id] (cu starea „favorit” la zi) sau `null`.
  Doctor? doctorById(String id) {
    for (final doctor in doctors) {
      if (doctor.id == id) return doctor;
    }
    return null;
  }

  /// Câmpurile nullable se transmit ca funcții, ca să poată fi setate la `null`.
  DoctorsState copyWith({
    DoctorsStatus? status,
    HomeData? home,
    List<Doctor>? doctors,
    List<Doctor>? visibleDoctors,
    String? query,
    ValueGetter<String?>? serviceId,
    DoctorSort? sort,
    bool? favoritesOnly,
    ValueGetter<String?>? errorMessage,
  }) {
    return DoctorsState(
      status: status ?? this.status,
      home: home ?? this.home,
      doctors: doctors ?? this.doctors,
      visibleDoctors: visibleDoctors ?? this.visibleDoctors,
      query: query ?? this.query,
      serviceId: serviceId != null ? serviceId() : this.serviceId,
      sort: sort ?? this.sort,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
