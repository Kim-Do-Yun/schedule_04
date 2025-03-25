import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // UID를 Spring Boot로 전송
  Future<void> sendUidToSpringBoot(String firebaseUid) async {
    const String apiUrl = 'http://localhost:8080/api/users/register';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'firebaseUid': firebaseUid}),
    );

    if (response.statusCode == 200) {
      print('UID 전송 성공');
    } else {
      print('UID 전송 실패: ${response.body}');
    }
  }
}
