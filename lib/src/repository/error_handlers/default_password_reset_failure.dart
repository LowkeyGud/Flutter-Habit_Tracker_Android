class DefaultPasswordResetFailure {
  final String message;
  const DefaultPasswordResetFailure([this.message = "Error Occurred"]);

  factory DefaultPasswordResetFailure.code(String code) {
    switch (code) {
      case 'invalid-email':
        return const DefaultPasswordResetFailure('Email is not valid🤨');
      case 'user-not-found':
        return const DefaultPasswordResetFailure('User not found.😵');
      case 'too-many-requests':
        return const DefaultPasswordResetFailure(
            'Too many unsuccessful login attempts. Please try again later⏳');
      case 'user-mismatch':
        return const DefaultPasswordResetFailure(
            "Doesn't match wilh currently loged in email");
      case 'requires-recent-login':
        return const DefaultPasswordResetFailure(
            'Login requires before reseting');
      default:
        return const DefaultPasswordResetFailure(
            'An error occurred. Please try again later😕');
    }
  }
}
