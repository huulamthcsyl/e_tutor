import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:authentication_repository/authentication_repository.dart';

class LoginInWithEmailAndPasswordFailure implements Exception {
  final String message;

  LoginInWithEmailAndPasswordFailure(this.message);

  factory LoginInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'user-not-found':
        return LoginInWithEmailAndPasswordFailure('Không tìm thấy người dùng');
      case 'wrong-password':
        return LoginInWithEmailAndPasswordFailure('Sai mật khẩu');
      case 'user-disabled':
        return LoginInWithEmailAndPasswordFailure('Tài khoản đã bị vô hiệu hóa');
      case 'too-many-requests':
        return LoginInWithEmailAndPasswordFailure('Quá nhiều yêu cầu');
      case 'operation-not-allowed':
        return LoginInWithEmailAndPasswordFailure('Thao tác không được phép');
      default:
        return LoginInWithEmailAndPasswordFailure('Đã xảy ra lỗi');
    }
  }
}

class SignUpWithEmailAndPasswordFailure implements Exception {
  final String message;

  SignUpWithEmailAndPasswordFailure(this.message);

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure('Email đã được sử dụng');
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure('Mật khẩu quá yếu');
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure('Thao tác không được phép');
      default:
        return SignUpWithEmailAndPasswordFailure('Đã xảy ra lỗi');
    }
  }
}

class SignOutFailure implements Exception {
  final String message;

  SignOutFailure(this.message);
}

class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthenticationRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : User(id: firebaseUser.uid, email: firebaseUser.email);
    });
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LoginInWithEmailAndPasswordFailure.fromCode(e.code);
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignOutFailure(e.message ?? 'Đã xảy ra lỗi');
    }
  }
}

