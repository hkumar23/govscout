import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../constants/app_language.dart';
import '../constants/firebase_collections.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/auth/auth_event.dart';
import '../widgets/show_modern_dialog.dart';

class AppMethods {
  static Future<void> logUserActivity() async {
    final userActivity =
        FirebaseFirestore.instance.collection(FirebaseCollections.userActivity);
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) return;
    try {
      final userId = auth.currentUser!.uid;
      final userDoc = await userActivity.doc(userId).get();
      if (userDoc.exists) {
        await userActivity.doc(userId).update({
          AppConstants.updatedAt: Timestamp.now(),
        });
      } else {
        await userActivity.doc(userId).set({
          AppConstants.email: auth.currentUser!.email,
          AppConstants.createdAt: Timestamp.now(),
        });
      }
    } catch (e) {
      debugPrint("Saving Log Error: $e");
    }
  }

  static Future<bool> sendNewJobPostNotification(
    String postTitle,
    String postBody,
    String createdBy,
  ) async {
    final apiUrl =
        "https://nodejs-serverless-lac.vercel.app/api/send-new-job-post-notification";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          AppConstants.postTitle: postTitle,
          AppConstants.postBody: postBody,
          AppConstants.createdBy: createdBy,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["message"] == "Post notifications processed" ||
            data["sent"] > 0;
      } else {
        debugPrint("Notification not sent: ${response.body}");
        throw "Notification not sent: ${response.body}";
      }
    } catch (e) {
      debugPrint("Error sending notification: $e");
      return false;
    }
  }

  static void logoutWithDialog(BuildContext ctx) {
    showModernDialog(
      context: ctx,
      title: AppLanguage.logout,
      content: "Are you sure you want to logout?",
      onConfirm: (context) {
        Navigator.of(context).pop();
        BlocProvider.of<AuthBloc>(ctx).add(LogoutEvent());
      },
    );
  }
}
