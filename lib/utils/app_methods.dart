import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../constants/app_language.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/auth/auth_event.dart';
import '../widgets/show_modern_dialog.dart';

class AppMethods {
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
