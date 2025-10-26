import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindpath/models/sleep_story_model.dart';

class SleepService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Tüm uyku hikayelerini getir
  Stream<List<SleepStoryModel>> getAllSleepStories() {
    return _firestore
        .collection('sleep_stories')
        .orderBy('title')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                SleepStoryModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Belirli bir uyku hikayesini getir
  Future<SleepStoryModel?> getSleepStory(String storyId) async {
    try {
      final doc =
          await _firestore.collection('sleep_stories').doc(storyId).get();
      if (doc.exists) {
        return SleepStoryModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error getting sleep story: $e');
      return null;
    }
  }

  /// Tag'e göre uyku hikayelerini filtrele
  Stream<List<SleepStoryModel>> getSleepStoriesByTag(String tag) {
    return _firestore
        .collection('sleep_stories')
        .where('tags', arrayContains: tag)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                SleepStoryModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Uyku hikayesi dinleme kaydı
  Future<void> recordSleepStorySession({
    required String userId,
    required String storyId,
    required int durationMinutes,
  }) async {
    try {
      await _firestore.collection('sleep_sessions').add({
        'userId': userId,
        'storyId': storyId,
        'durationMinutes': durationMinutes,
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Kullanıcı istatistiklerini güncelle
      await _firestore.collection('users').doc(userId).update({
        'stats.totalSleepMinutes': FieldValue.increment(durationMinutes),
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error recording sleep story session: $e');
      rethrow;
    }
  }
}

