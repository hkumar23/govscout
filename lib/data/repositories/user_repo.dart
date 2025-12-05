import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_constants.dart';
import '../../constants/firebase_collections.dart';
import '../models/user.model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc =
          await _firestore.collection(FirebaseCollections.users).doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser(Map<String, dynamic> userData, String uid) async {
    try {
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(uid)
          .set(userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(Map<String, dynamic> userData, String uid) async {
    try {
      userData[AppConstants.updatedAt] = Timestamp.now();
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(uid)
          .update(userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(FirebaseCollections.users).doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }
}
