class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
      'BASE_URL',
      defaultValue: 'http://10.0.2.2:8080' // 로컬 개발 서버 기본값
  );
  static const String signUpUrl = '$baseUrl/api/users/signup';
  static const String loginUrl = '$baseUrl/api/users/login';
  static const String autoLoginUrl = '$baseUrl/api/users/auto-login';
}
