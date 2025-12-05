import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_constants.dart';

class Candidate {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profilePhotoUrl;
  final String? gender;
  final String? dob;
  final String? city;
  final String? state;
  final String? pincode;

  final String? highestQualification;
  final String? fieldOfStudy;
  final int? yearOfPassing;
  final List<String> skills;

  final List<String> preferredJobLocations;
  final List<String> preferredDepartments;
  final List<String> jobTypes;
  final List<String> examPreferences;

  final List<String> savedJobIds;
  final List<String> appliedJobIds;
  final List<String> viewedJobIds;
  final bool notificationEnabled;

  final DateTime createdAt;
  final DateTime updatedAt;

  Candidate({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profilePhotoUrl,
    this.gender,
    this.dob,
    this.city,
    this.state,
    this.pincode,
    this.highestQualification,
    this.fieldOfStudy,
    this.yearOfPassing,
    this.skills = const [],
    this.preferredJobLocations = const [],
    this.preferredDepartments = const [],
    this.jobTypes = const [],
    this.examPreferences = const [],
    this.savedJobIds = const [],
    this.appliedJobIds = const [],
    this.viewedJobIds = const [],
    this.notificationEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Candidate.fromJson(
    Map<String, dynamic> json,
    String uid,
  ) {
    return Candidate(
      id: uid,
      name: json[AppConstants.name],
      email: json[AppConstants.email],
      phone: json[AppConstants.phone],
      profilePhotoUrl: json[AppConstants.profilePhotoUrl],
      gender: json[AppConstants.gender],
      dob: json[AppConstants.dob],
      city: json[AppConstants.city],
      state: json[AppConstants.state],
      pincode: json[AppConstants.pincode],
      highestQualification: json[AppConstants.highestQualification],
      fieldOfStudy: json[AppConstants.fieldOfStudy],
      yearOfPassing: json[AppConstants.yearOfPassing],
      skills: List<String>.from(json[AppConstants.skills] ?? []),
      preferredJobLocations:
          List<String>.from(json[AppConstants.preferredJobLocations] ?? []),
      preferredDepartments:
          List<String>.from(json[AppConstants.preferredDepartments] ?? []),
      jobTypes: List<String>.from(json[AppConstants.jobTypes] ?? []),
      examPreferences:
          List<String>.from(json[AppConstants.examPreferences] ?? []),
      savedJobIds: List<String>.from(json[AppConstants.savedJobIds] ?? []),
      appliedJobIds: List<String>.from(json[AppConstants.appliedJobIds] ?? []),
      viewedJobIds: List<String>.from(json[AppConstants.viewedJobIds] ?? []),
      notificationEnabled: json[AppConstants.notificationEnabled] ?? true,
      createdAt: (json[AppConstants.createdAt] as Timestamp).toDate(),
      updatedAt: (json[AppConstants.updatedAt] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppConstants.name: name,
      AppConstants.email: email,
      AppConstants.phone: phone,
      AppConstants.profilePhotoUrl: profilePhotoUrl,
      AppConstants.gender: gender,
      AppConstants.dob: dob,
      AppConstants.city: city,
      AppConstants.state: state,
      AppConstants.pincode: pincode,
      AppConstants.highestQualification: highestQualification,
      AppConstants.fieldOfStudy: fieldOfStudy,
      AppConstants.yearOfPassing: yearOfPassing,
      AppConstants.skills: skills,
      AppConstants.preferredJobLocations: preferredJobLocations,
      AppConstants.preferredDepartments: preferredDepartments,
      AppConstants.jobTypes: jobTypes,
      AppConstants.examPreferences: examPreferences,
      AppConstants.savedJobIds: savedJobIds,
      AppConstants.appliedJobIds: appliedJobIds,
      AppConstants.viewedJobIds: viewedJobIds,
      AppConstants.notificationEnabled: notificationEnabled,
      AppConstants.createdAt: Timestamp.fromDate(createdAt),
      AppConstants.updatedAt: Timestamp.fromDate(updatedAt),
    };
  }
}
