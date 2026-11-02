import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab3_appointment/data/repositories/clinic_repository.dart';
import 'package:lab3_appointment/logic/doctors/doctor_filters.dart';
import 'package:lab3_appointment/logic/doctors/doctors_state.dart';

/// Gestionează datele Homescreen și lista de medici:
/// încărcare asincronă, căutare, filtrare, sortare și favorite.
///
/// Este creat o singură dată, deasupra `MaterialApp`, așa că toate ecranele
/// (Homescreen, lista completă, detalii) văd aceleași favorite și filtre.
class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this._repository) : super(const DoctorsState());

  final ClinicRepository _repository;

  /// Încarcă (sau reîncarcă, la pull-to-refresh) datele din JSON.
  ///
  /// La reîncărcare nu se mai afișează „Loading” peste ecran, iar favoritele
  /// alese de utilizator se păstrează.
  Future<void> load() async {
    final previous = state.home == null ? null : state;
    emit(
      state.copyWith(
        status: previous == null ? DoctorsStatus.loading : null,
        errorMessage: () => null,
      ),
    );

    try {
      final home = await _repository.fetchHome();
      if (isClosed) return;

      final favoriteIds = previous?.doctors
          .where((doctor) => doctor.isFavorite)
          .map((doctor) => doctor.id)
          .toSet();
      final doctors = [
        for (final doctor in home.doctors)
          favoriteIds == null
              ? doctor
              : doctor.copyWith(isFavorite: favoriteIds.contains(doctor.id)),
      ];

      _emitFiltered(
        state.copyWith(
          home: home,
          doctors: doctors,
          errorMessage: () => null,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      // La reîncărcare păstrăm datele vechi și doar anunțăm eroarea.
      emit(
        state.copyWith(
          status: previous == null ? DoctorsStatus.error : previous.status,
          errorMessage: () => error.toString(),
        ),
      );
    }
  }

  void search(String query) {
    if (query == state.query) return;
    _emitFiltered(state.copyWith(query: query));
  }

  /// Apăsarea pe un serviciu îl selectează; a doua apăsare anulează filtrul.
  void toggleService(String serviceId) {
    final next = state.serviceId == serviceId ? null : serviceId;
    _emitFiltered(state.copyWith(serviceId: () => next));
  }

  void selectService(String? serviceId) {
    _emitFiltered(state.copyWith(serviceId: () => serviceId));
  }

  void changeSort(DoctorSort sort) {
    if (sort == state.sort) return;
    _emitFiltered(state.copyWith(sort: sort));
  }

  void setFavoritesOnly(bool value) {
    _emitFiltered(state.copyWith(favoritesOnly: value));
  }

  void toggleFavorite(String doctorId) {
    final doctors = [
      for (final doctor in state.doctors)
        doctor.id == doctorId
            ? doctor.copyWith(isFavorite: !doctor.isFavorite)
            : doctor,
    ];
    _emitFiltered(state.copyWith(doctors: doctors));
  }

  void clearFilters() {
    _emitFiltered(
      state.copyWith(
        query: '',
        serviceId: () => null,
        favoritesOnly: false,
        sort: DoctorSort.nearest,
      ),
    );
  }

  /// Recalculează lista vizibilă și starea Success / Empty.
  void _emitFiltered(DoctorsState next) {
    if (next.home == null) {
      // Datele nu sunt încă încărcate: memorăm doar criteriile.
      emit(next);
      return;
    }
    final visible = applyDoctorFilters(
      doctors: next.doctors,
      query: next.query,
      service: next.selectedService,
      favoritesOnly: next.favoritesOnly,
      sort: next.sort,
    );
    emit(
      next.copyWith(
        visibleDoctors: visible,
        status: visible.isEmpty ? DoctorsStatus.empty : DoctorsStatus.success,
      ),
    );
  }
}
