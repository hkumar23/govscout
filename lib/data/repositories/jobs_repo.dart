import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/app_constants.dart';
import '../../constants/firebase_collections.dart';
import '../models/job.model.dart';
import 'user_repo.dart';

class JobsRepository {
  final _firestore = FirebaseFirestore.instance;
  final _userRepo = UserRepository();

  Future<void> addJob(Job job) async {
    try {
      await _firestore.collection(FirebaseCollections.jobs).add(job.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Initial page (pin first, then recent)
  Query<Map<String, dynamic>> _baseFeedQuery() {
    try {
      return _firestore
          .collection(FirebaseCollections.jobs)
          .orderBy(AppConstants.createdAt, descending: true)
          .orderBy(AppConstants.applicationEndDate, descending: false);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Job>> getFirstPage({int pageSize = 10}) async {
    try {
      final snap = await _baseFeedQuery().limit(pageSize).get();
      return snap.docs.map((doc) => Job.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Job>> getNextPage({
    required DocumentSnapshot lastDoc,
    int pageSize = 10,
  }) async {
    try {
      final snap = await _baseFeedQuery()
          .startAfterDocument(lastDoc)
          .limit(pageSize)
          .get();

      return snap.docs.map((doc) => Job.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Listen for brand-new posts added after first load
  Stream<List<Job>> listenNewJobs(DateTime since) {
    try {
      return _firestore
          .collection(FirebaseCollections.jobs)
          .where(
            AppConstants.createdAt,
            isGreaterThan: Timestamp.fromDate(since),
          )
          .orderBy(AppConstants.applicationEndDate, descending: false)
          .orderBy(AppConstants.createdAt, descending: true)
          .snapshots()
          .map((q) =>
              q.docs.map((doc) => Job.fromJson(doc.data(), doc.id)).toList());
    } catch (e) {
      rethrow;
    }
  }

  Future<Job> getJobById(String jobId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.jobs)
          .doc(jobId)
          .get();
      if (!doc.exists) {
        throw Exception("Job not found");
      }
      return Job.fromJson(doc.data()!, doc.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await _firestore.collection(FirebaseCollections.jobs).doc(jobId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveJob({
    required String jobId,
    required String userId,
  }) async {
    try {
      final user = await _userRepo.getUser(userId);
      if (user == null) {
        throw "User not found in our database";
      }

      final jobDocRef =
          _firestore.collection(FirebaseCollections.jobs).doc(jobId);
      final roleDocRef = _firestore.collection(user.role).doc(userId);

      final jobDoc = await jobDocRef.get();
      final roleDoc = await roleDocRef.get();
      if (!jobDoc.exists) throw "Job does not exist!";
      if (!roleDoc.exists) {
        throw "${user.role} not found in our database!";
      }

      final List<String> jobSavedByUserIds =
          List<String>.from(jobDoc.data()![AppConstants.savedByUserIds] ?? []);
      final List<String> roleSavedJobIds =
          List<String>.from(roleDoc.data()![AppConstants.savedJobIds] ?? []);

      jobSavedByUserIds.add(userId);
      roleSavedJobIds.add(jobId);

      jobDocRef.update({
        AppConstants.savedByUserIds: jobSavedByUserIds,
      });
      roleDocRef.update({
        AppConstants.savedJobIds: roleSavedJobIds,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unsaveJob(String jobId, String userId) async {
    try {
      final user = await _userRepo.getUser(userId);
      if (user == null) {
        throw "User not found in our database";
      }

      final jobDocRef =
          _firestore.collection(FirebaseCollections.jobs).doc(jobId);
      final roleDocRef = _firestore.collection(user.role).doc(userId);

      final jobDoc = await jobDocRef.get();
      final roleDoc = await roleDocRef.get();
      if (jobDoc.data() == null) throw "Job does not exist!";
      if (roleDoc.data() == null) {
        throw "${user.role} not found in our database!";
      }

      final List<String> jobSavedByUserIds =
          List<String>.from(jobDoc.data()![AppConstants.savedByUserIds] ?? []);
      final List<String> roleSavedJobIds =
          List<String>.from(roleDoc.data()![AppConstants.savedJobIds] ?? []);

      jobSavedByUserIds.remove(userId);
      roleSavedJobIds.remove(jobId);

      jobDocRef.update({
        AppConstants.savedByUserIds: jobSavedByUserIds,
      });
      roleDocRef.update({
        AppConstants.savedJobIds: roleSavedJobIds,
      });
    } catch (e) {
      rethrow;
    }
  }
  // Reaction (like/unlike)
  // Future<void> toggleLike({required String postId, required String uid}) async {
  //   final likeRef = _firestore
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('reactions')
  //       .doc(uid);
  //   await _firestore.runTransaction((tx) async {
  //     final likeSnap = await tx.get(likeRef);
  //     final postRef = _firestore.collection('posts').doc(postId);
  //     if (likeSnap.exists) {
  //       tx.delete(likeRef);
  //       tx.update(postRef, {'likesCount': FieldValue.increment(-1)});
  //     } else {
  //       tx.set(likeRef,
  //           {'type': 'like', 'createdAt': FieldValue.serverTimestamp()});
  //       tx.update(postRef, {'likesCount': FieldValue.increment(1)});
  //     }
  // });
  // }
}
