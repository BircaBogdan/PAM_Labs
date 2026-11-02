import 'package:flutter_test/flutter_test.dart';

import 'package:lab3_appointment/data/models/clinic_data.dart';
import 'package:lab3_appointment/logic/appointment/appointment_cubit.dart';
import 'package:lab3_appointment/logic/appointment/appointment_state.dart';
import 'package:lab3_appointment/logic/doctors/doctor_filters.dart';
import 'package:lab3_appointment/logic/doctors/doctors_cubit.dart';
import 'package:lab3_appointment/logic/doctors/doctors_state.dart';

import 'helpers/fake_clinic_repository.dart';

const emmly = 'Dr. Emmly Lestiryno';
const sonja = 'Dr. Sonja Litel';

List<String> names(DoctorsState state) =>
    state.visibleDoctors.map((doctor) => doctor.name).toList();

void main() {
  late ClinicData data;

  setUpAll(() => data = loadSampleData());

  group('DoctorsCubit', () {
    late DoctorsCubit cubit;

    setUp(() => cubit = DoctorsCubit(FakeClinicRepository(data)));
    tearDown(() => cubit.close());

    test('load emits Loading then Success', () async {
      final statuses = <DoctorsStatus>[];
      final subscription = cubit.stream.listen((s) => statuses.add(s.status));

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(statuses, [DoctorsStatus.loading, DoctorsStatus.success]);
      expect(names(cubit.state), [emmly, sonja]);
      await subscription.cancel();
    });

    test('load emits Error when the repository fails', () async {
      final failing = DoctorsCubit(
        FakeClinicRepository(data, failuresBeforeSuccess: 1),
      );
      await failing.load();
      expect(failing.state.status, DoctorsStatus.error);
      expect(failing.state.errorMessage, 'Network error');

      await failing.load();
      expect(failing.state.status, DoctorsStatus.success);
      await failing.close();
    });

    test('search filters by name and shows Empty', () async {
      await cubit.load();

      cubit.search('sonja');
      expect(names(cubit.state), [sonja]);

      cubit.search('dental');
      expect(names(cubit.state), [sonja]);

      cubit.search('nobody');
      expect(cubit.state.status, DoctorsStatus.empty);

      cubit.clearFilters();
      expect(cubit.state.status, DoctorsStatus.success);
      expect(names(cubit.state), [emmly, sonja]);
    });

    test('health service filter toggles on and off', () async {
      await cubit.load();

      cubit.toggleService('tooth');
      expect(names(cubit.state), [sonja]);

      cubit.toggleService('eye');
      expect(cubit.state.status, DoctorsStatus.empty);

      cubit.toggleService('eye');
      expect(cubit.state.serviceId, isNull);
      expect(names(cubit.state), [emmly, sonja]);
    });

    test('sorting', () async {
      await cubit.load();

      cubit.changeSort(DoctorSort.nameDesc);
      expect(names(cubit.state), [sonja, emmly]);

      cubit.changeSort(DoctorSort.nameAsc);
      expect(names(cubit.state), [emmly, sonja]);

      cubit.changeSort(DoctorSort.nearest);
      expect(names(cubit.state), [emmly, sonja]);
    });

    test('favorites: toggle, filter and keep after refresh', () async {
      await cubit.load();

      cubit.setFavoritesOnly(true);
      expect(cubit.state.status, DoctorsStatus.empty);

      cubit.toggleFavorite('doctor-002');
      expect(cubit.state.favoritesCount, 1);
      expect(names(cubit.state), [sonja]);

      await cubit.load();
      expect(cubit.state.doctorById('doctor-002')!.isFavorite, isTrue);

      cubit.toggleFavorite('doctor-002');
      expect(cubit.state.status, DoctorsStatus.empty);
    });
  });

  group('AppointmentCubit', () {
    test('loads details, changes selection and books', () async {
      final doctor = data.home.doctors.last;
      final cubit = AppointmentCubit(
        FakeClinicRepository(data),
        doctor: doctor,
      );

      await cubit.load();
      expect(cubit.state.status, AppointmentStatus.success);
      expect(cubit.state.selectedHour!.label, '11.00 AM');
      expect(cubit.state.selectedDate!.label, 'Sun 4');
      expect(cubit.state.displayedDoctor!.name, sonja);

      cubit.selectHour('10am');
      cubit.selectDate('tue-6');
      await cubit.book();

      expect(cubit.state.bookingStatus, BookingStatus.success);
      expect(
        cubit.state.message,
        'Appointment booked: $sonja · Tue 6 · 10.00 AM',
      );
      await cubit.close();
    });

    test('without a doctor shows the one from the JSON', () async {
      final cubit = AppointmentCubit(FakeClinicRepository(data));
      await cubit.load();
      expect(cubit.state.displayedDoctor!.name, 'Dr.Upul');
      await cubit.close();
    });
  });
}
