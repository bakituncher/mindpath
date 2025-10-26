import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindpath/models/course_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Tüm kursları getir
  Stream<List<CourseModel>> getAllCourses() {
    return _firestore
        .collection('courses')
        .orderBy('title')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourseModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Belirli bir kursu getir
  Future<CourseModel?> getCourse(String courseId) async {
    try {
      final doc = await _firestore.collection('courses').doc(courseId).get();
      if (doc.exists) {
        return CourseModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error getting course: $e');
      return null;
    }
  }

  /// Kursun derslerini getir
  Stream<List<LessonModel>> getCourseLessons(String courseId) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .collection('lessons')
        .orderBy('orderIndex')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LessonModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Dersi tamamla
  Future<void> completeLesson(
    String userId,
    String courseId,
    String lessonId,
  ) async {
    try {
      // Kullanıcının ders ilerlemesini kaydet
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('course_progress')
          .doc(courseId)
          .set({
        'completedLessons': FieldValue.arrayUnion([lessonId]),
        'lastAccessedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Tüm dersler tamamlandıysa kursu tamamla
      final lessonsSnapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('lessons')
          .get();

      final progressDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('course_progress')
          .doc(courseId)
          .get();

      if (progressDoc.exists) {
        final completedLessons =
            List<String>.from(progressDoc.data()?['completedLessons'] ?? []);

        if (completedLessons.length == lessonsSnapshot.docs.length) {
          // Kursu tamamlandı olarak işaretle
          await _firestore.collection('users').doc(userId).update({
            'stats.completedCourses': FieldValue.arrayUnion([courseId]),
          });
        }
      }
    } catch (e) {
      print('Error completing lesson: $e');
      rethrow;
    }
  }

  /// Kullanıcının kurs ilerlemesini getir
  Future<Map<String, dynamic>?> getCourseProgress(
    String userId,
    String courseId,
  ) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('course_progress')
          .doc(courseId)
          .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting course progress: $e');
      return null;
    }
  }

  /// Kullanıcının tamamladığı tüm kursları getir
  Future<List<String>> getCompletedCourses(String userId) async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        return List<String>.from(
            data?['stats']?['completedCourses'] ?? []);
      }
      return [];
    } catch (e) {
      print('Error getting completed courses: $e');
      return [];
    }
  }
}

