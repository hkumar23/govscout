import '../../../utils/app_exception.dart';

abstract class AuthState {}

class InitialAuthState extends AuthState {}

class LoggedInState extends AuthState {
  final String role;
  final String userId;
  LoggedInState({
    required this.role,
    required this.userId,
  });
}

// class SignInWithEmailSuccessState extends AuthState {
//   final String role;
//   SignInWithEmailSuccessState({
//     required this.role,
//   });
// }

// class SignInWithGoogleSuccessState extends AuthState {
//   final String role;
//   SignInWithGoogleSuccessState({
//     required this.role,
//   });
// }

class SignUpWithEmailSuccessState extends AuthState {
  final String userId;
  SignUpWithEmailSuccessState({
    required this.userId,
  });
}

class LoggedOutState extends AuthState {}

class AuthLoadingState extends AuthState {}

class UserNotAuthendicatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final AppException e;
  AuthErrorState(this.e);
}

class ResetPasswordSuccessState extends AuthState {}
