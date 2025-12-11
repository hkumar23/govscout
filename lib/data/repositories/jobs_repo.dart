import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/firebase_collections.dart';
import '../models/job.model.dart';

class JobsRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addJob(Job job) async {
    try {
      await _firestore.collection(FirebaseCollections.jobs).add(job.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
