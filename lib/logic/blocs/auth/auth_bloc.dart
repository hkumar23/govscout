import 'package:bloc/bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
    on<AppStartedEvent>(_onAppStartedEvent);
    on<SignInWithEmailEvent>(_onSignInWithEmailEvent);
    on<SignUpWithEmailEvent>(_onSignUpWithEmailEvent);
    on<SignInWithGoogleEvent>(_onSignInWithGoogleEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  void _onAppStartedEvent(
    AppStartedEvent event,
    Emitter<AuthState> emit,
  ) async {
    // emit(AuthLoadingState());
    // try {
    // final user = _authRepo.currentUser;
    // if (user != null) {
    //   final userDoc = await _userRepo.getUser(user.uid);
    //   if (userDoc == null) {
    //     throw "User not found in Database";
    //   }
    //   final res =
    //       await _firestore.collection(userDoc.role).doc(user.uid).get();
    //   final data = res.data();
    //   if (data == null) {
    //     throw "${userDoc.role} not found in database";
    //   }
    //   if (userDoc.role == AppConstants.admin) {
    //     emit(LoggedInState(
    //       role: userDoc.role,
    //       isActive: true,
    //     ));
    //   } else {
    //     emit(LoggedInState(
    //       role: userDoc.role,
    //       isActive: data[AppConstants.isActive],
    //     ));
    //   }
    // emit(LoggedInState(role: userDoc.role));
    // } else {
    // emit(UserNotAuthendicatedState());
    // throw "User not Authenticated";
    // }
    // } catch (e) {
    //   emit(
    //     AuthErrorState(
    //       error: AppException(e.toString()),
    //     ),
    //   );
    // }
    emit(UserNotAuthendicatedState());
  }

  void _onSignInWithEmailEvent(
    SignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {}
  void _onSignUpWithEmailEvent(
    SignUpWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {}
  void _onSignInWithGoogleEvent(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {}
  void _onResetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {}
  void _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {}
}
