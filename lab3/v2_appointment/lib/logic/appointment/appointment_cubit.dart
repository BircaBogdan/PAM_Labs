import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lab3_appointment/data/models/doctor.dart';
import 'package:lab3_appointment/data/repositories/clinic_repository.dart';
import 'package:lab3_appointment/logic/appointment/appointment_state.dart';

/// Logica ecranului de programare: încărcarea detaliilor, alegerea orei
/// și a zilei și trimiterea asincronă a programării.
class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit(this._repository, {Doctor? doctor})
    : super(AppointmentState(doctor: doctor));

  final ClinicRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(status: AppointmentStatus.loading, message: () => null),
    );
    try {
      final details = await _repository.fetchAppointmentDetails();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AppointmentStatus.success,
          details: details,
          selectedHourId: details.workingHours.initialSelectedId,
          selectedDateId: details.dates.initialSelectedId,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AppointmentStatus.error,
          message: () => error.toString(),
        ),
      );
    }
  }

  void selectHour(String id) => emit(state.copyWith(selectedHourId: id));

  void selectDate(String id) => emit(state.copyWith(selectedDateId: id));

  Future<void> book() async {
    final doctor = state.displayedDoctor;
    final hour = state.selectedHour;
    final date = state.selectedDate;
    if (!state.canBook || doctor == null || hour == null || date == null) {
      return;
    }

    emit(
      state.copyWith(
        bookingStatus: BookingStatus.inProgress,
        message: () => null,
      ),
    );
    try {
      final confirmation = await _repository.bookAppointment(
        doctor: doctor,
        date: date,
        hour: hour,
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          bookingStatus: BookingStatus.success,
          message: () => 'Appointment booked: ${confirmation.summary}',
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          bookingStatus: BookingStatus.failure,
          message: () => 'Booking failed: $error',
        ),
      );
    }
  }
}
