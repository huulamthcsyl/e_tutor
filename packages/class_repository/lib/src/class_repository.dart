import 'package:class_repository/src/models/class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassFailure implements Exception {
  final String message;

  ClassFailure(this.message);
}

class ClassRepository {
  final FirebaseFirestore _firestore;

  ClassRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Class>> getClasses() {
    return _firestore.collection('classes').get().then((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Class(
          id: doc.id,
          name: data['name'],
        );
      }).toList();
    });
  }

  Stream<List<Class>> searchClasses(String query) {
    return _firestore
        .collection('classes')
        .where('name', isEqualTo: query)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Class(
          id: doc.id,
          name: data['name'],
          members: List<String>.from(data['members']),
          tuition: data['tuition']?.toDouble(),
        );
      }).toList();
    });
  }

  Future<Class> getClass(String id) {
    return _firestore.collection('classes').doc(id).get().then((doc) {
      final data = doc.data();
      if (data == null) {
        throw ClassFailure('Không tìm thấy lớp học');
      }
      return Class(
        id: doc.id,
        name: data['name'],
      );
    });
  }

  Future<void> createClass(Class newClass) {
    return _firestore.collection('classes').add({
      'name': newClass.name,
      'description': newClass.description,
      'members': [],
      'tuition': null,
      'schedules': [],
      'lessons': [],
      'exams': [],
      'isActive': true
    });
  }
}