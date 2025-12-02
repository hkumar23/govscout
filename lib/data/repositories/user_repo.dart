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

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(user.uid)
          .set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      Map<String, dynamic> userData = user.toJson();
      userData[AppConstants.updatedAt] = Timestamp.now();
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(user.uid)
          .update(user.toJson());
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
