import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../constants/firebase_collections.dart';
import 'app_theme_mode.dart';

class ThemeRepository {
  final _users =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);

  Future<AppThemeMode> loadTheme(String userId) async {
    try {
      final doc = await _users.doc(userId).get();

      if (!doc.exists) return AppThemeMode.system;

      final value = doc.data()?[AppConstants.theme] ?? AppConstants.system;

      return AppThemeMode.values.firstWhere(
        (e) => e.name == value,
        orElse: () => AppThemeMode.system,
      );
    } catch (e) {
      debugPrint("Error loading theme: $e");
      return AppThemeMode.system; // fallback
    }
  }

  Future<void> saveTheme(String userId, AppThemeMode mode) async {
    try {
      await _users.doc(userId).set(
        {AppConstants.theme: mode.name},
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint("Error saving theme: $e");
    }
  }
}
