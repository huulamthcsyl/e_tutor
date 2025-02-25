import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'models/profile.dart';

class ProfileFailure implements Exception {
  final String message;

  ProfileFailure(this.message);
}

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileRepository({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Stream<List<Profile>> getProfiles() {
    return _firestore
        .collection('profiles')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Profile(
          id: doc.id,
          name: data['name'],
          birthDate: data['birthDate']?.toDate(),
          address: data['address'],
          phoneNumber: data['phoneNumber'],
          avatarUrl: data['avatarUrl'],
          members: List<String>.from(data['members']),
          role: data['role'],
        );
      }).toList();
    });
  }

  Stream<List<Profile>> searchProfiles(String query) {
    return _firestore
        .collection('profiles')
        .where('name', isEqualTo: query)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Profile(
          id: doc.id,
          name: data['name'],
          birthDate: data['birthDate']?.toDate(),
          address: data['address'],
          phoneNumber: data['phoneNumber'],
          avatarUrl: data['avatarUrl'],
          members: List<String>.from(data['members']),
          role: data['role'],
        );
      }).toList();
    });
  }

  Future<Profile> getProfile(String id) {
    return _firestore.collection('profiles').doc(id).get().then((doc) {
      final data = doc.data();
      if (data == null) {
        throw ProfileFailure('Không tìm thấy hồ sơ');
      }
      return Profile(
        id: doc.id,
        name: data['name'],
        birthDate: data['birthDate']?.toDate(),
        address: data['address'],
        phoneNumber: data['phoneNumber'],
        avatarUrl: data['avatarUrl'],
        members: List<String>.from(data['members']),
        role: data['role'],
      );
    });
  }

  Future<void> createProfile(Profile profile) {
    return _firestore.collection('profiles').doc(profile.id).set({
      'name': profile.name,
      'birthDate': profile.birthDate,
      'address': profile.address,
      'phoneNumber': profile.phoneNumber,
      'avatarUrl': profile.avatarUrl,
      'members': [],
      'role': profile.role,
    });
  }

  Future<void> updateProfile(Profile profile) {
    return _firestore.collection('profiles').doc(profile.id).update({
      'name': profile.name,
      'birthDate': profile.birthDate,
      'address': profile.address,
      'phoneNumber': profile.phoneNumber,
      'avatarUrl': profile.avatarUrl,
      'members': profile.members,
      'role': profile.role,
    });
  }

  Future<void> uploadProfileImage(String id, String filePath, Uint8List file) async {
    final ref = _storage.ref().child('profiles/$id/avatar');
    await ref.putData(file);
    final url = await ref.getDownloadURL();
    await _firestore.collection('profiles').doc(id).update({'avatarUrl': url});
  }

  Future<List<Profile>> getProfilesByIds(List<String> ids) {
    return Future.wait(ids.map((id) => getProfile(id)));
  }
}