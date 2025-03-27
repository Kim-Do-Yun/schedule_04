import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import 'package:schedule_04/constants/ApiConstants.dart'; // ApiConstants 파일 import

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio();

  // ✅ Google 로그인 (회원가입 포함)
  Future<void> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      final UserCredential userCredential =
      await _auth.signInWithProvider(googleProvider);

      final String firebaseUid = userCredential.user?.uid ?? '';
      final String? email = userCredential.user?.email;
      final String? displayName = userCredential.user?.displayName;

      print('Firebase UID: $firebaseUid');
      print('Email: $email, Name: $displayName');

      // 자동 로그인 처리 (Spring Boot로 UID 전송)
      await sendUidToSpringBoot(firebaseUid, email, displayName);
    } catch (e) {
      print('🚨 Google 로그인 오류: $e');
    }
  }

  // ✅ 이메일 회원가입
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final String firebaseUid = userCredential.user?.uid ?? '';
      print('✅ 회원가입 성공 - Firebase UID: $firebaseUid');

      // 자동 로그인 처리
      await sendUidToSpringBoot(firebaseUid, email, "Unknown User");
    } catch (e) {
      print('🚨 회원가입 오류: $e');
    }
  }

  // ✅ 이메일 로그인
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final String firebaseUid = userCredential.user?.uid ?? '';
      print('✅ 로그인 성공 - Firebase UID: $firebaseUid');

      await sendUidToSpringBoot(firebaseUid, email, "Unknown User");
    } catch (e) {
      print('🚨 로그인 오류: $e');
    }
  }

  // ✅ 자동 로그인 (Spring Boot로 UID 전송)
  Future<void> sendUidToSpringBoot(
      String firebaseUid, String? email, String? displayName) async {
    try {
      final response = await _dio.post(
        ApiConstants.autoLoginUrl,
        data: {
          'firebaseUid': firebaseUid,
          'username': displayName ?? 'Unknown User',
          'email': email ?? 'unknown@example.com',
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('✅ 자동 로그인 성공: ${response.data}');
      } else {
        print('❌ 자동 로그인 실패: ${response.data}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          print('🚨 인터넷 연결 오류');
        } else if (e.type == DioExceptionType.connectionTimeout) {
          print('🚨 서버 연결 시간 초과');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          print('🚨 응답 시간 초과');
        } else if (e.type == DioExceptionType.badResponse) {
          print('🚨 서버 오류: ${e.response?.statusCode}');
        } else if (e.type == DioExceptionType.cancel) {
          print('🚨 요청 취소됨');
        } else {
          print('🚨 기타 에러: ${e.message}');
        }
      } else {
        print('🚨 예상치 못한 에러 발생: $e');
      }
    }
  }
}