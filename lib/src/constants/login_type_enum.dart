enum LoginType {
  google,
  apple,
  facebook,
  email,
}

extension LoginTypeExtension on LoginType {
  String get value {
    switch (this) {
      case LoginType.google:
        return 'google';
      case LoginType.apple:
        return 'apple';
      case LoginType.facebook:
        return 'facebook';
      case LoginType.email:
        return 'email';
    }
  }

  static LoginType fromString(String value) {
    switch (value) {
      case 'google':
        return LoginType.google;
      case 'apple':
        return LoginType.apple;
      case 'facebook':
        return LoginType.facebook;
      case 'email':
        return LoginType.email;
      default:
        throw ArgumentError('Invalid login type: $value');
    }
  }

  static String fromLoginType(LoginType loginType) {
    switch (loginType) {
      case LoginType.google:
        return '구글';
      case LoginType.apple:
        return '애플';
      case LoginType.facebook:
        return '페이스북';
      case LoginType.email:
        return '이메일';
    }
  }
}
