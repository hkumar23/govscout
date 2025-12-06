import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_constants.dart';

class UserModel {
  final String email;
  final String role;
  final String uid;
  final DateTime createdAt;
  final DateTime updatedAt;
  UserModel({
    required this.email,
    required this.role,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      AppConstants.email: email,
      AppConstants.role: role,
      AppConstants.createdAt: Timestamp.fromDate(createdAt),
      AppConstants.updatedAt: Timestamp.fromDate(updatedAt),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      email: json[AppConstants.email],
      uid: uid,
      role: json[AppConstants.role],
      createdAt: (json[AppConstants.createdAt] as Timestamp).toDate(),
      updatedAt: (json[AppConstants.updatedAt] as Timestamp).toDate(),
    );
  }
}
