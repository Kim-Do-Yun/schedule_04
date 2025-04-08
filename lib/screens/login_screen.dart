import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인 화면')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool success = await _authService.signInWithGoogle();
            if (!context.mounted) return;

            if (success) {
              context.go('/home');
            }
          },
          child: const Text('Google 로그인'),
        ),
      ),
    );
  }
}
