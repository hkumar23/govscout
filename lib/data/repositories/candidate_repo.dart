import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:govscout/constants/app_constants.dart';

import '../../constants/firebase_collections.dart';
import '../models/candidate.model.dart';

class CandidateRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createCandidate(
    Map<String, dynamic> candidateData,
    String uid,
  ) async {
    try {
      await _firestore
          .collection(FirebaseCollections.candidate)
          .doc(uid)
          .set(candidateData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Candidate?> getCandidate(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.candidate)
          .doc(uid)
          .get();
      if (!doc.exists) return null;
      return Candidate.fromJson(doc.data()!, uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCandidate(
    Map<String, dynamic> candidateData,
    String uid,
  ) async {
    try {
      candidateData[AppConstants.updatedAt] = Timestamp.now();
      await _firestore
          .collection(FirebaseCollections.candidate)
          .doc(uid)
          .update(candidateData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCandidate(String uid) async {
    try {
      await _firestore
          .collection(FirebaseCollections.candidate)
          .doc(uid)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
