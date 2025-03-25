import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio(); // Dio 인스턴스 생성

  // Google 로그인 및 UID 전송
  Future<void> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      final UserCredential userCredential =
      await _auth.signInWithProvider(googleProvider);

      final String firebaseUid = userCredential.user?.uid ?? '';
      print('Firebase UID: $firebaseUid');

      // Spring Boot로 firebase_uid 전송
      await sendUidToSpringBoot(firebaseUid);
    } catch (e) {
      print('로그인 오류: $e');
    }
  }

  // UID를 Spring Boot로 전송 (자동 로그인 포함)
  Future<void> sendUidToSpringBoot(String firebaseUid) async {
    const String apiUrl = 'http://localhost:8080/api/users/auto-login';

    try {
      // Google 로그인 후 자동 로그인 처리
      final response = await _dio.post(
        apiUrl,
        data: {
          'firebaseUid': firebaseUid,
          'username': 'Unknown User', // 필요 시 값을 추가
          'email': 'unknown@example.com', // 필요 시 값을 추가
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        print('자동 로그인 성공: ${response.data}');
        // 응답 데이터 처리 (예: user 정보 저장)
      } else {
        print('자동 로그인 실패: ${response.data}');
      }
    } catch (e) {
      // DioException 에러 처리
      if (e is DioException) {
        // DioException에서 발생하는 구체적인 오류 코드 처리
        if (e.error is SocketException) {
          print('인터넷 연결 오류');
        } else if (e.type == DioExceptionType.connectionTimeout) {
          print('서버 연결 시간 초과');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          print('응답 시간 초과');
        } else if (e.type == DioExceptionType.badResponse) {
          print('서버 오류: ${e.response?.statusCode}');
        } else if (e.type == DioExceptionType.cancel) {
          print('요청 취소');
        } else {
          print('기타 에러: ${e.message}');
        }
      } else {
        print('예상치 못한 에러 발생: $e');
      }
    }
  }
}
