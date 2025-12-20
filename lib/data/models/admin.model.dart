import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govscout/constants/app_constants.dart';

class Admin {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;

  final List<String> savedJobIds;
  final List<String> permissions;
  final List<String> createdJobIds;
  final List<String> editedJobIds;

  final DateTime createdAt;
  final DateTime updatedAt;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.savedJobIds = const [],
    this.permissions = const [],
    this.createdJobIds = const [],
    this.editedJobIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json[AppConstants.id],
      name: json[AppConstants.name],
      email: json[AppConstants.email],
      phone: json[AppConstants.phone],
      photoUrl: json[AppConstants.photoUrl],
      savedJobIds: List<String>.from(json[AppConstants.savedJobIds] ?? []),
      permissions: List<String>.from(json[AppConstants.permissions] ?? []),
      createdJobIds: List<String>.from(json[AppConstants.createdJobIds] ?? []),
      editedJobIds: List<String>.from(json[AppConstants.editedJobIds] ?? []),
      createdAt: (json[AppConstants.createdAt] as Timestamp).toDate(),
      updatedAt: (json[AppConstants.updatedAt] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppConstants.id: id,
      AppConstants.name: name,
      AppConstants.email: email,
      AppConstants.phone: phone,
      AppConstants.photoUrl: photoUrl,
      AppConstants.savedJobIds: savedJobIds,
      AppConstants.permissions: permissions,
      AppConstants.createdJobIds: createdJobIds,
      AppConstants.editedJobIds: editedJobIds,
      AppConstants.createdAt: Timestamp.fromDate(createdAt),
      AppConstants.updatedAt: Timestamp.fromDate(updatedAt),
    };
  }
}
