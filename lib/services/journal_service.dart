import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindpath/models/journal_model.dart';

class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create journal entry
  Future<String> createJournalEntry(JournalEntry entry) async {
    try {
      final docRef = await _firestore.collection('journal_entries').add(entry.toJson());

      // Update user stats
      await _firestore.collection('users').doc(entry.userId).update({
        'stats.totalJournalEntries': FieldValue.increment(1),
      });

      return docRef.id;
    } catch (e) {
      print('Error creating journal entry: $e');
      rethrow;
    }
  }

  // Get user's journal entries
  Stream<List<JournalEntry>> getUserJournalEntries(String userId) {
    return _firestore
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntry.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Get journal entry by ID
  Future<JournalEntry?> getJournalEntry(String entryId) async {
    try {
      final doc = await _firestore.collection('journal_entries').doc(entryId).get();
      if (doc.exists) {
        return JournalEntry.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error getting journal entry: $e');
      return null;
    }
  }

  // Update journal entry
  Future<void> updateJournalEntry(String entryId, Map<String, dynamic> data) async {
    await _firestore.collection('journal_entries').doc(entryId).update(data);
  }

  // Delete journal entry
  Future<void> deleteJournalEntry(String entryId, String userId) async {
    await _firestore.collection('journal_entries').doc(entryId).delete();

    // Update user stats
    await _firestore.collection('users').doc(userId).update({
      'stats.totalJournalEntries': FieldValue.increment(-1),
    });
  }

  // Get mood analytics for user
  Future<Map<String, dynamic>> getMoodAnalytics(String userId, {int days = 30}) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    final snapshot = await _firestore
        .collection('journal_entries')
        .where('userId', isEqualTo: userId)
        .where('createdAt', isGreaterThan: startDate.toIso8601String())
        .get();

    if (snapshot.docs.isEmpty) {
      return {'averageMood': 0.0, 'moodTrend': [], 'topEmotions': []};
    }

    final entries = snapshot.docs
        .map((doc) => JournalEntry.fromJson({...doc.data(), 'id': doc.id}))
        .toList();

    // Calculate average mood
    final averageMood = entries
        .map((e) => e.moodScore)
        .reduce((a, b) => a + b) / entries.length;

    // Get top emotions
    final emotionCounts = <String, int>{};
    for (final entry in entries) {
      for (final emotion in entry.emotions) {
        emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
      }
    }

    final topEmotions = emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'averageMood': averageMood,
      'totalEntries': entries.length,
      'topEmotions': topEmotions.take(5).map((e) => e.key).toList(),
    };
  }
}

