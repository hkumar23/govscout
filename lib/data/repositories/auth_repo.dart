import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants/firebase_collections.dart';
import '../../utils/app_exception.dart';
import '../models/user.model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AppException("Firebase Exception: ${e.code}");
    } catch (_) {
      throw AppException("Sign Up with email and password failure!");
    }
  }

  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw "User not found";
      }
      final res = await _firestore
          .collection(FirebaseCollections.users)
          .doc(userCredential.user!.uid)
          .get();
      final userData = res.data();

      if (userData == null) {
        await signOut();
        throw "User authenticated but not found in database!";
      }
      final user = UserModel.fromJson(userData);
      final userRoleRef = _firestore.collection(user.role).doc(user.uid);
      final userRoleSnap = await userRoleRef.get();
      if (!userRoleSnap.exists) {
        await signOut();
        throw "User authenticated but not found in database!";
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw AppException("Firebase Exception: ${e.code}");
    } catch (e) {
      print(e.toString());
      throw AppException("Sign In with email and password failure");
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw AppException("Sign Out failure");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      switch (e.code) {
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'user-not-found':
          throw Exception('No user found with this email.');
        default:
          throw Exception('Something went wrong. Please try again.');
      }
    } catch (e) {
      // Handle any other errors
      rethrow;
    }
  }
}
