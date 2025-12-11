import '../constants/app_language.dart';

abstract class AppValidators {
  static String? upiIdRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "UPI ID is required";
    }

    // Basic UPI ID format: username@bank
    final upiRegex = RegExp(r'^[\w.\-]{2,256}@[a-zA-Z]{2,64}$');

    if (!upiRegex.hasMatch(value.trim())) {
      return "Enter a valid UPI ID (e.g. name@bank)";
    }

    return null; // valid
  }

  static String? addressRequired(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your address";
    }
    return null;
  }

  static String? passwordRequired(String? value) {
    if (value == null || value.isEmpty) return AppLanguage.required;
    return value.length < 6 ? "Password must be at least 6 characters" : null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;

    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? emailRequired(String? value) {
    if (value == null || value.isEmpty) {
      return AppLanguage.required;
    }
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? integerType(String? value) {
    if (value == null || value.isEmpty) return null;
    // Regex to allow only digits 0–9
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value)) {
      return 'Only digits (0-9) are allowed';
    }
    return null; // Valid input
  }

  static String? integerTypeRequired(String? value) {
    if (value == null || value.isEmpty) return AppLanguage.required;
    // Regex to allow only digits 0–9
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value)) {
      return 'Only digits (0-9) are allowed';
    }
    return null; // Valid input
  }

  static String? doubleType(String? value) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) {
      return "Please enter a valid number";
    }
    return null;
  }

  static String? doubleTypeRequired(String? value) {
    if (value == null || value.isEmpty) return AppLanguage.required;
    if (double.tryParse(value) == null) {
      return "Please enter a valid number";
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) return null;
    // Basic regex for phone number validation (10 digits)
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null; // valid
  }

  static String? phoneNumberRequired(String? value) {
    if (value == null || value.isEmpty) return AppLanguage.required;
    // Basic regex for phone number validation (10 digits)
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null; // valid
  }

  static String? textRequired(String? value) {
    return value == null || value.isEmpty ? AppLanguage.required : null;
  }
}
