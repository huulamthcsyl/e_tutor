import 'package:class_repository/class_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class ClassFailure implements Exception {
  final String message;

  ClassFailure(this.message);
}

class ClassRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ClassRepository({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

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
        startDate: data['startDate'] != null ? DateTime.parse(data['startDate']) : null,
        endDate: data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
        members: List<String>.from(data['members']),
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
      'endDate': newClass.endDate!.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
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
    for (var schedule in classData.schedules!) {
      await generateLessonFromDateToDateWithSchedule(classId, classData.startDate!, classData.endDate!, schedule);
    }
  }

  Future<void> generateLessonFromDateToDateWithSchedule(String classId, DateTime startDate, DateTime endDate, Schedule schedule) async {
    final lessonDocs  = _firestore.collection('lessons');
    final firstLessonDate = startDate.add(Duration(days: (schedule.day.index - startDate.weekday + 8) % 7));
    for (var date = firstLessonDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 7))) {
      final startTime = DateTime(date.year, date.month, date.day, schedule.startTime.hour, schedule.startTime.minute);
      final endTime = DateTime(date.year, date.month, date.day, schedule.endTime.hour, schedule.endTime.minute);
      lessonDocs.add({
        'classId': classId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'materials': [],
        'homeworks': [],
        'isPaid': false,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<LessonResponse>> getLessonsInMonthOnDate(DateTime date, String userId) async {
    final lessons = <LessonResponse>[];
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 0);
    final snapshot = await _firestore.collection('classes').where('members', arrayContains: userId).get();
    for (var doc in snapshot.docs) {
      final classData = doc.data();
      final lessonSnapshot = await _firestore.collection('lessons')
        .where('classId', isEqualTo: doc.id)
        .where('startTime', isGreaterThanOrEqualTo: startOfMonth.toIso8601String())
        .where('endTime', isLessThanOrEqualTo: endOfMonth.toIso8601String())
        .get();
      for (var lessonDoc in lessonSnapshot.docs) {
        final lessonData = lessonDoc.data();
        lessons.add(LessonResponse(
          classId: doc.id,
          className: classData['name'],
          lesson: Lesson(
            id: lessonDoc.id,
            classId: doc.id,
            materials: (lessonData['materials'] as List<dynamic>).map((material) {
              return Material(
                name: material['name'],
                url: material['url'],
              );
            }).toList(),
            homeworks: List<String>.from(lessonData['homeworks']),
            isPaid: lessonData['isPaid'],
            tutorFeedback: lessonData['tutorFeedback'],
            studentFeedback: lessonData['studentFeedback'],
            startTime: lessonData['startTime'] != null ? DateTime.parse(lessonData['startTime']) : null,
            endTime: lessonData['endTime'] != null ? DateTime.parse(lessonData['endTime']) : null,
            createdAt: lessonData['createdAt'] != null ? DateTime.parse(lessonData['createdAt']) : null,
          )
        ));
      }
    }
    return lessons;
  }

  Future<Lesson> getLesson(String classId, String lessonId) {
    return _firestore.collection('lessons').doc(lessonId).get().then((doc) {
      final data = doc.data();
      if (data == null) {
        throw ClassFailure('Không tìm thấy bài học');
      }
      return Lesson(
        id: doc.id,
        classId: classId,
        materials: (data['materials'] as List<dynamic>).map((material) {
          return Material(
            name: material['name'],
            url: material['url'],
          );
        }).toList(),
        homeworks: List<String>.from(data['homeworks']),
        isPaid: data['isPaid'],
        tutorFeedback: data['tutorFeedback'],
        studentFeedback: data['studentFeedback'],
        startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
        endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      );
    });
  }

  Future<void> uploadLessonMaterial(String classId, Lesson lesson, String fileName, Uint8List file) async {
    final ref = _storage.ref().child('lessons/${lesson.id}/materials/$fileName');
    await ref.putData(file);
    _firestore.collection('lessons').doc(lesson.id).update({
      'materials': FieldValue.arrayUnion([
        {
          'name': fileName,
          'url': ref.fullPath,
        }
      ])
    });
  }

  Future<void> deleteLessonMaterial(String lessonId, Material material) async {
    final ref = _storage.ref().child(material.url);
    await ref.delete();
    _firestore.collection('lessons').doc(lessonId).update({
      'materials': FieldValue.arrayRemove([
        {
          'name': material.name,
          'url': material.url,
        }
      ])
    });
  }

  Future<void> cancelLesson(String lessonId) async {
    await _firestore.collection('lessons').doc(lessonId).delete();
  }

  Future<String> getMaterialUrl(String url) {
    return _storage.ref().child(url).getDownloadURL();
  }

  Future<List<Homework>> getHomeworks(List<String> homeworkIds) {
    return Future.wait(homeworkIds.map((id) {
      return _firestore.collection('homeworks').doc(id).get().then((doc) {
        final data = doc.data();
        if (data == null) {
          throw ClassFailure('Không tìm thấy bài tập');
        }
        return Homework(
          id: doc.id,
          title: data['title'],
          classId: data['classId'],
          lessonId: data['lessonId'],
          materials: (data['materials'] as List<dynamic>?)?.map((material) {
            return Material(
              name: material['name'],
              url: material['url'],
            );
          }).toList(),
          studentWorks: (data['studentWorks'] as List<dynamic>?)?.map((work) {
            return Material(
              name: work['name'],
              url: work['url'],
            );
          }).toList(),
          score: data['score'],
          feedback: data['feedback'],
          createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
          dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
          status: data['status'],
          submittedAt: data['submittedAt'] != null ? DateTime.parse(data['submittedAt']) : null,
        );
      });
    }));
  }

  Future<String> uploadHomeworkMaterial(String homeworkId, String fileName, Uint8List file) async {
    final ref = _storage.ref().child('homeworks/$homeworkId/materials/$fileName');
    await ref.putData(file);
    return ref.fullPath;
  }

  Future<void> createHomework(String classId, String lessonId, Homework homework) async {
    await _firestore.collection('homeworks').doc(homework.id).set({
      'classId': classId,
      'lessonId': lessonId,
      'title': homework.title,
      'materials': homework.materials?.map((material) {
        return {
          'name': material.name,
          'url': material.url,
        };
      }).toList(),
      'studentWorks': [],
      'score': null,
      'feedback': null,
      'createdAt': homework.createdAt?.toIso8601String(),
      'dueDate': homework.dueDate?.toIso8601String(),
      'status': 'pending',
    });
    _firestore.collection('lessons').doc(lessonId).update({
      'homeworks': FieldValue.arrayUnion([homework.id])
    });
  }

  Future<Homework> getHomework(String homeworkId) {
    return _firestore.collection('homeworks').doc(homeworkId).get().then((doc) {
      final data = doc.data();
      if (data == null) {
        throw ClassFailure('Không tìm thấy bài tập');
      }
      return Homework(
        id: doc.id,
        title: data['title'],
        classId: data['classId'],
        lessonId: data['lessonId'],
        materials: (data['materials'] as List<dynamic>?)?.map((material) {
          return Material(
            name: material['name'],
            url: material['url'],
          );
        }).toList(),
        studentWorks: (data['studentWorks'] as List<dynamic>?)?.map((work) {
          return Material(
            name: work['name'],
            url: work['url'],
          );
        }).toList(),
        score: data['score'],
        feedback: data['feedback'],
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
        dueDate: data['dueDate'] != null ? DateTime.parse(data['dueDate']) : null,
        status: data['status'],
        submittedAt: data['submittedAt'] != null ? DateTime.parse(data['submittedAt']) : null,
      );
    });
  }

  Future<void> updateHomework(String homeworkId, Homework homework) async {
    await _firestore.collection('homeworks').doc(homeworkId).update({
      'title': homework.title,
      'materials': homework.materials?.map((material) {
        return {
          'name': material.name,
          'url': material.url,
        };
      }).toList(),
    });
  }

  Future<void> addMembersToClass(String classId, List<String> memberIds) {
    return _firestore.collection('classes').doc(classId).update({
      'members': FieldValue.arrayUnion(memberIds)
    });
  }

  Future<String> uploadStudentWork(String homeworkId, String fileName, Uint8List file) async {
    final ref = _storage.ref().child('homeworks/$homeworkId/studentWorks/$fileName');
    await ref.putData(file);
    return ref.fullPath;
  }

  Future<void> submitHomework(String homeworkId, List<Material> studentWorks) {
    return _firestore.collection('homeworks').doc(homeworkId).update({
      'studentWorks': studentWorks.map((work) {
        return {
          'name': work.name,
          'url': work.url,
        };
      }).toList(),
      'status': 'submitted',
      'submittedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> gradeHomework(String homeworkId, double score, String feedback) {
    return _firestore.collection('homeworks').doc(homeworkId).update({
      'score': score,
      'feedback': feedback,
      'status': 'graded',
    });
  }

  Future<LessonResponse> getUpcomingLesson(String classId) async {
    final snapshot = await _firestore.collection('lessons')
      .where('classId', isEqualTo: classId)
      .where('startTime', isGreaterThanOrEqualTo: DateTime.now().toIso8601String())
      .orderBy('startTime')
      .limit(1)
      .get();
    if (snapshot.docs.isEmpty) {
      return LessonResponse(classId: classId, className: '', lesson: Lesson(
        classId: classId,
        materials: const [],
        homeworks: const [],
      ));
    }
    final classData = await getClass(classId);
    final doc = snapshot.docs.first;
    final data = doc.data();
    return LessonResponse(
      classId: classId,
      className: classData.name ?? "",
      lesson: Lesson(
        id: doc.id,
        classId: classId,
        materials: (data['materials'] as List<dynamic>).map((material) {
          return Material(
            name: material['name'],
            url: material['url'],
          );
        }).toList(),
        homeworks: List<String>.from(data['homeworks']),
        isPaid: data['isPaid'],
        tutorFeedback: data['tutorFeedback'],
        studentFeedback: data['studentFeedback'],
        startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
        endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
      )
    );
  }

  Future<List<Lesson>> getLessonsInRange(String classId, DateTime start, DateTime end) async {
    final snapshot = await _firestore.collection('lessons')
      .where('classId', isEqualTo: classId)
      .where('startTime', isGreaterThanOrEqualTo: start.toIso8601String())
      .where('endTime', isLessThanOrEqualTo: end.toIso8601String())
      .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Lesson(
        id: doc.id,
        classId: classId,
        materials: (data['materials'] as List<dynamic>).map((material) {
          return Material(
            name: material['name'],
            url: material['url'],
          );
        }).toList(),
        homeworks: List<String>.from(data['homeworks']),
        isPaid: data['isPaid'],
        tutorFeedback: data['tutorFeedback'],
        studentFeedback: data['studentFeedback'],
        startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
        endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
      );
    }).toList();
  }

  Future<Lesson> createLesson(String classId, DateTime startTime, DateTime endTime) async {
    final doc = await _firestore.collection('lessons').add({
      'classId': classId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'materials': [],
      'homeworks': [],
      'isPaid': false,
    });
    return Lesson(
      id: doc.id,
      classId: classId,
      materials: const [],
      homeworks: const [],
      startTime: startTime,
      endTime: endTime,
    );
  }

  Future<void> createExam(String classId, Exam exam) async {
    await _firestore.collection('exams').doc(exam.id).set({
      'classId': classId,
      'title': exam.title,
      'materials': exam.materials?.map((material) {
        return {
          'name': material.name,
          'url': material.url,
        };
      }).toList(),
      'studentWorks': [],
      'score': null,
      'feedback': null,
      'startTime': exam.startTime?.toIso8601String(),
      'endTime': exam.endTime?.toIso8601String(),
      'returnTime': exam.returnTime?.toIso8601String(),
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Exam> getRecentExam(String classId) async {
    final snapshot = await _firestore.collection('exams')
      .where('classId', isEqualTo: classId)
      .where('startTime', isLessThanOrEqualTo: DateTime.now().toIso8601String())
      .orderBy('startTime', descending: true)
      .limit(1)
      .get();
    if (snapshot.docs.isEmpty) {
      return Exam(
        classId: classId,
        materials: const [],
        studentWorks: const [],
      );
    }
    final doc = snapshot.docs.first;
    final data = doc.data();
    return Exam(
      id: doc.id,
      classId: classId,
      title: data['title'],
      materials: (data['materials'] as List<dynamic>).map((material) {
        return Material(
          name: material['name'],
          url: material['url'],
        );
      }).toList(),
      studentWorks: (data['studentWorks'] as List<dynamic>).map((work) {
        return Material(
          name: work['name'],
          url: work['url'],
        );
      }).toList(),
      score: data['score'],
      feedback: data['feedback'],
      startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
      endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
      returnTime: data['returnTime'] != null ? DateTime.parse(data['returnTime']) : null,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
    );
  }

  Future<String> uploadExamMaterial(String examId, String fileName, Uint8List file) async {
    final ref = _storage.ref().child('exams/$examId/materials/$fileName');
    await ref.putData(file);
    return ref.fullPath;
  }

  Future<List<Exam>> getExamsInRange(String classId, DateTime start, DateTime end) async {
    final snapshot = await _firestore.collection('exams')
      .where('classId', isEqualTo: classId)
      .where('startTime', isGreaterThanOrEqualTo: start.toIso8601String())
      .where('endTime', isLessThanOrEqualTo: end.toIso8601String())
      .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Exam(
        id: doc.id,
        classId: classId,
        title: data['title'],
        materials: (data['materials'] as List<dynamic>).map((material) {
          return Material(
            name: material['name'],
            url: material['url'],
          );
        }).toList(),
        studentWorks: (data['studentWorks'] as List<dynamic>).map((work) {
          return Material(
            name: work['name'],
            url: work['url'],
          );
        }).toList(),
        score: data['score'],
        feedback: data['feedback'],
        startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
        endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
        returnTime: data['returnTime'] != null ? DateTime.parse(data['returnTime']) : null,
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      );
    }).toList();
  }

  Future<List<Exam>> getExamsInMonthOnDate(DateTime date, String userId) async {
    final exams = <Exam>[];
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 0);
    final snapshot = await _firestore.collection('classes').where('members', arrayContains: userId).get();
    for (var doc in snapshot.docs) {
      final examSnapshot = await _firestore.collection('exams')
        .where('classId', isEqualTo: doc.id)
        .where('startTime', isGreaterThanOrEqualTo: startOfMonth.toIso8601String())
        .where('endTime', isLessThanOrEqualTo: endOfMonth.toIso8601String())
        .get();
      for (var examDoc in examSnapshot.docs) {
        final examData = examDoc.data();
        exams.add(Exam(
          id: examDoc.id,
          classId: doc.id,
          title: examData['title'],
          materials: (examData['materials'] as List<dynamic>).map((material) {
            return Material(
              name: material['name'],
              url: material['url'],
            );
          }).toList(),
          studentWorks: (examData['studentWorks'] as List<dynamic>).map((work) {
            return Material(
              name: work['name'],
              url: work['url'],
            );
          }).toList(),
          score: examData['score'],
          feedback: examData['feedback'],
          startTime: examData['startTime'] != null ? DateTime.parse(examData['startTime']) : null,
          endTime: examData['endTime'] != null ? DateTime.parse(examData['endTime']) : null,
          returnTime: examData['returnTime'] != null ? DateTime.parse(examData['returnTime']) : null,
          createdAt: examData['createdAt'] != null ? DateTime.parse(examData['createdAt']) : null,
        ));
      }
    }
    return exams;
  }

  Future<Exam> getExamById(String examId) {
    return _firestore.collection('exams').doc(examId).get().then((doc) {
      final data = doc.data();
      if (data == null) {
        throw ClassFailure('Không tìm thấy bài thi');
      }
      return Exam(
        id: doc.id,
        classId: data['classId'],
        title: data['title'],
        materials: (data['materials'] as List<dynamic>).map((material) {
          return Material(
            name: material['name'],
            url: material['url'],
          );
        }).toList(),
        studentWorks: (data['studentWorks'] as List<dynamic>).map((work) {
          return Material(
            name: work['name'],
            url: work['url'],
          );
        }).toList(),
        score: data['score'],
        feedback: data['feedback'],
        startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
        endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
        returnTime: data['returnTime'] != null ? DateTime.parse(data['returnTime']) : null,
        status: data['status'],
        submittedAt: data['submittedAt'] != null ? DateTime.parse(data['submittedAt']) : null,
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      );
    });
  }

  Future<String> uploadExamStudentWork(String examId, String fileName, Uint8List file) async {
    final ref = _storage.ref().child('exams/$examId/studentWorks/$fileName');
    await ref.putData(file);
    return ref.fullPath;
  }

  Future<void> submitExam(String examId, List<Material> studentWorks) {
    return _firestore.collection('exams').doc(examId).update({
      'studentWorks': studentWorks.map((work) {
        return {
          'name': work.name,
          'url': work.url,
        };
      }).toList(),
      'status': 'submitted',
      'submittedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> gradeExam(String examId, double score, String feedback) {
    return _firestore.collection('exams').doc(examId).update({
      'score': score,
      'feedback': feedback,
      'status': 'graded',
      'returnTime': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeMemberFromClass(String classId, String memberId) {
    return _firestore.collection('classes').doc(classId).update({
      'members': FieldValue.arrayRemove([memberId])
    });
  }

  Future<List<Lesson>> getUnpaidLessons(String classId) async {
    final snapshot = await _firestore.collection('lessons')
      .where('classId', isEqualTo: classId)
      .where('isPaid', isEqualTo: false)
      .where('startTime', isLessThanOrEqualTo: DateTime.now().toIso8601String())
      .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Lesson(
        id: doc.id,
        classId: classId,
        materials: (data['materials'] as List<dynamic>).map((material) {
          return Material(
            name: material['name'],
            url: material['url'],
          );
        }).toList(),
        homeworks: List<String>.from(data['homeworks']),
        isPaid: data['isPaid'],
        tutorFeedback: data['tutorFeedback'],
        studentFeedback: data['studentFeedback'],
        startTime: data['startTime'] != null ? DateTime.parse(data['startTime']) : null,
        endTime: data['endTime'] != null ? DateTime.parse(data['endTime']) : null,
      );
    }).toList();
  }
}