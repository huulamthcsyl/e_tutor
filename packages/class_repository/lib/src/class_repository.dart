import 'package:class_repository/class_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassFailure implements Exception {
  final String message;

  ClassFailure(this.message);
}

class ClassRepository {
  final FirebaseFirestore _firestore;

  ClassRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Class>> getClasses(String userId) {
    return _firestore.collection('classes').where('members', arrayContains: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Class(
          id: doc.id,
          name: data['name'],
          description: data['description'],
          members: List<String>.from(data['members']),
          tuition: data['tuition']?.toInt(),
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
          tuition: data['tuition']?.toInt(),
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
        description: data['description'],
        tuition: data['tuition']?.toInt(),
        schedules: (data['schedules'] as List<dynamic>?)?.map((schedule) {
          return Schedule.fromJson(schedule);
        }).toList(),
      );
    });
  }

  Future<void> createClass(Class newClass) async {
    final createdClass = await _firestore.collection('classes').add({
      'name': newClass.name,
      'description': newClass.description,
      'members': newClass.members,
      'tuition': newClass.tuition,
      'schedules': newClass.schedules?.map((schedule) {
        return {
          'startTime': DateTime(2025, 1, 1, schedule.startTime.hour, schedule.startTime.minute).toString(),
          'endTime': DateTime(2025, 1, 1, schedule.endTime.hour, schedule.endTime.minute).toString(),
          'day': schedule.day.index,
        };
      }).toList(),
      'lessons': [],
      'exams': [],
      'isActive': true,
      'startDate': newClass.startDate!.toIso8601String(),
      'endDate': newClass.endDate!.toIso8601String()
    });
    await createLessonSchedule(createdClass.id);
  }

  Future<void> createLessonSchedule(String classId) async {
    final classData = await _firestore.collection('classes').doc(classId).get().then((doc) {
      final data = doc.data();
      if (data == null) {
        throw ClassFailure('Không tìm thấy lớp học');
      }
      return Class(
        id: doc.id,
        name: data['name'],
        description: data['description'],
        tuition: data['tuition']?.toInt(),
        startDate: data['startDate'] != null ? DateTime.parse(data['startDate']) : null,
        endDate: data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
        schedules: (data['schedules'] as List<dynamic>?)?.map((schedule) {
          return Schedule.fromJson(schedule);
        }).toList(),
      );
    }); 
    if(classData.schedules == null || classData.endDate == null || classData.startDate == null) return;
    List<Lesson> lessons = [];
    for (var schedule in classData.schedules!) {
      lessons.addAll(generateLessonFromDateToDateWithSchedule(classData.startDate!, classData.endDate!, schedule));
    }
    await _firestore.collection('classes').doc(classId).update({
      'lessons': lessons.map((lesson) {
        return {
          'startTime': lesson.startTime.toString(),
          'endTime': lesson.endTime.toString(),
        };
      }).toList(),
    });
  }

  List<Lesson> generateLessonFromDateToDateWithSchedule(DateTime startDate, DateTime endDate, Schedule schedule) {
    final lessons = <Lesson>[];
    DateTime firstLessonDate = startDate;
    while (firstLessonDate.weekday != schedule.day.index + 1) {
      firstLessonDate = firstLessonDate.add(const Duration(days: 1));
    }
    for (var date = firstLessonDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 7))) {
      final startTime = DateTime(date.year, date.month, date.day, schedule.startTime.hour, schedule.startTime.minute);
      final endTime = DateTime(date.year, date.month, date.day, schedule.endTime.hour, schedule.endTime.minute);
      lessons.add(Lesson(
        startTime: startTime,
        endTime: endTime,
      ));
    }
    return lessons;
  }
}