import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindpath/models/meditation_model.dart';

class MeditationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all meditations
  Future<List<MeditationModel>> getAllMeditations() async {
    try {
      final snapshot = await _firestore
          .collection('meditations')
          .orderBy('playCount', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MeditationModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting meditations: $e');
      return [];
    }
  }

  // Get meditations by category
  Future<List<MeditationModel>> getMeditationsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('meditations')
          .where('category', isEqualTo: category)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MeditationModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting meditations by category: $e');
      return [];
    }
  }

  // Get meditation by duration
  Future<List<MeditationModel>> getMeditationsByDuration(int minutes) async {
    try {
      final snapshot = await _firestore
          .collection('meditations')
          .where('durationMinutes', isEqualTo: minutes)
          .get();

      return snapshot.docs
          .map((doc) => MeditationModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting meditations by duration: $e');
      return [];
    }
  }

  // Increment play count
  Future<void> incrementPlayCount(String meditationId) async {
    await _firestore.collection('meditations').doc(meditationId).update({
      'playCount': FieldValue.increment(1),
    });
  }

  // Save user's meditation session
  Future<void> saveMeditationSession({
    required String userId,
    required String meditationId,
    required int durationMinutes,
    bool completed = true,
  }) async {
    await _firestore.collection('meditation_sessions').add({
      'userId': userId,
      'meditationId': meditationId,
      'durationMinutes': durationMinutes,
      'completed': completed,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update user stats
    await _firestore.collection('users').doc(userId).update({
      'stats.totalMeditationMinutes': FieldValue.increment(durationMinutes),
    });
  }

  // Get user's meditation history
  Stream<List<Map<String, dynamic>>> getUserMeditationHistory(String userId) {
    return _firestore
        .collection('meditation_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

