import 'package:lab3_appointment/data/models/doctor.dart';

/// Utilizatorul din antetul Homescreen (`homeScreen.user`).
class UserProfile {
  const UserProfile({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      greeting: json['greeting'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;
}

/// Cardul turcoaz „Appointment” (`homeScreen.appointment`).
class UpcomingAppointment {
  const UpcomingAppointment({
    required this.title,
    required this.date,
    required this.time,
    required this.doctor,
  });

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointment(
      title: json['title'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      doctor: Doctor.fromJson(
        json['doctor'] as Map<String, dynamic>,
        fallbackId: 'upcoming-appointment-doctor',
      ),
    );
  }

  final String title;
  final String date;
  final String time;
  final Doctor doctor;
}

/// Un element din „Health Services” (`homeScreen.healthServices`).
class HealthService {
  const HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory HealthService.fromJson(Map<String, dynamic> json) {
    return HealthService(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String? ?? '',
    );
  }

  final String id;
  final String name;
  final String iconUrl;

  /// Iconița exportată din Figma pentru acest serviciu (dacă există).
  String get localIcon => 'assets/images/service_$id.png';
}

/// Toate datele ecranului Homescreen (cheia `homeScreen`).
class HomeData {
  const HomeData({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.services,
    required this.doctors,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final notifications = json['notifications'] as Map<String, dynamic>?;
    final search = json['search'] as Map<String, dynamic>?;
    return HomeData(
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      hasUnreadNotifications: notifications?['hasUnread'] as bool? ?? false,
      searchHint: search?['hint'] as String? ?? 'Search',
      appointment: UpcomingAppointment.fromJson(
        json['appointment'] as Map<String, dynamic>,
      ),
      services: [
        for (final item in json['healthServices'] as List<dynamic>? ?? [])
          HealthService.fromJson(item as Map<String, dynamic>),
      ],
      doctors: [
        for (final item in json['nearbyDoctors'] as List<dynamic>? ?? [])
          Doctor.fromJson(item as Map<String, dynamic>),
      ],
    );
  }

  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final UpcomingAppointment appointment;
  final List<HealthService> services;
  final List<Doctor> doctors;
}
