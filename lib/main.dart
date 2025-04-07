import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '일정 관리 앱',
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인 화면')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _authService.signInWithGoogle();
          },
          child: const Text('Google 로그인'),
        ),
      ),
    );
  }
}
