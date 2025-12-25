import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../constants/app_constants.dart';
import '../../../data/models/user.model.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/candidate_repo.dart';
import '../../../data/repositories/user_repo.dart';
import '../../../utils/app_exception.dart';
import '../../../utils/services/notification_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authRepo = AuthRepository();
  final _userRepo = UserRepository();
  final _candidateRepo = CandidateRepository();
  final _firestore = FirebaseFirestore.instance;

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
    emit(AuthLoadingState());
    try {
      final user = _authRepo.currentUser;
      if (user != null) {
        final userDoc = await _userRepo.getUser(user.uid);
        if (userDoc == null) {
          throw "User not found in Database";
        }
        final res =
            await _firestore.collection(userDoc.role).doc(user.uid).get();
        final data = res.data();
        if (data == null) {
          throw "${userDoc.role} not found in database";
        }

        emit(LoggedInState(
          role: userDoc.role,
          userId: user.uid,
        ));
      } else {
        emit(UserNotAuthendicatedState());
        // throw "User not Authenticated";
      }
    } catch (e) {
      emit(
        AuthErrorState(
          AppException(e.toString()),
        ),
      );
    }
    // emit(UserNotAuthendicatedState());
  }

  void _onSignInWithEmailEvent(
    SignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final UserModel user = await _authRepo.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      final res = await _firestore.collection(user.role).doc(user.uid).get();
      final data = res.data();
      if (data == null) {
        throw "${user.role} not found in database";
      }

      // AppMethods.updateFcmToken(user.uid, user.role);
      // if (!kIsWeb) {
      //   await NotificationsService()
      //       .updateTokenForUser(AuthRepository().currentUser!.uid);
      // }
      if (!kIsWeb) {
        await NotificationsService()
            .updateTokenForUser(AuthRepository().currentUser!.uid);
      }

      emit(LoggedInState(
        role: user.role,
        userId: user.uid,
      ));
    } on AppException catch (e) {
      emit(
        AuthErrorState(e),
      );
    } catch (e) {
      print("Error during login: ${e.toString()}");
      emit(
        AuthErrorState(
          AppException(e.toString()),
        ),
      );
    }
  }

  void _onSignUpWithEmailEvent(
    SignUpWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await _authRepo.signUpWithEmailAndPassword(
        event.email,
        event.password,
      );
      final currentUser = _authRepo.currentUser;
      if (currentUser == null) {
        throw "User not found after sign up";
      }

      await _userRepo.createUser(
        {
          AppConstants.email: event.email,
          AppConstants.name: event.name,
          AppConstants.role: AppConstants.candidate,
          AppConstants.createdAt: DateTime.now(),
          AppConstants.updatedAt: DateTime.now(),
        },
        currentUser.uid,
      );
      await _candidateRepo.createCandidate(
        {
          AppConstants.email: event.email,
          AppConstants.name: event.name,
          AppConstants.createdAt: DateTime.now(),
          AppConstants.updatedAt: DateTime.now(),
        },
        currentUser.uid,
      );

      if (!kIsWeb) {
        await NotificationsService()
            .updateTokenForUser(AuthRepository().currentUser!.uid);
      }

      // AppMethods.updateFcmToken(newUser.uid, newUser.role);
      // if (!kIsWeb) {
      //   await NotificationsService()
      //       .updateTokenForUser(AuthRepository().currentUser!.uid);
      // }
      emit(SignUpWithEmailSuccessState(userId: currentUser.uid));
    } on AppException catch (e) {
      emit(
        AuthErrorState(e),
      );
    } catch (e) {
      print("Error during sign up: ${e.toString()}");
      emit(
        AuthErrorState(
          AppException(e.toString()),
        ),
      );
    }
  }

  void _onSignInWithGoogleEvent(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {}

  void _onResetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await _authRepo.sendPasswordResetEmail(event.email);
      emit(ResetPasswordSuccessState());
    } catch (e) {
      print("Error during password reset: ${e.toString()}");
      emit(
        AuthErrorState(
          AppException(e.toString()),
        ),
      );
    }
  }

  void _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await _authRepo.signOut();
      emit(LoggedOutState());
    } on AppException catch (e) {
      emit(
        AuthErrorState(e),
      );
    } catch (e) {
      print("Error during logout: ${e.toString()}");
      emit(
        AuthErrorState(
          AppException(e.toString()),
        ),
      );
    }
  }
}
