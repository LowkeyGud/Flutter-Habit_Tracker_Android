class DefaultSignUpFailure {
  final String message;
  const DefaultSignUpFailure([this.message = "Error Occurred"]);

  factory DefaultSignUpFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const DefaultSignUpFailure('Weakling password');
      case 'invalid-email':
        return const DefaultSignUpFailure('Email is not valid🤨');
      case 'user-disabled':
        return const DefaultSignUpFailure(
            'Account has been disabled by an administrator🚫');
      // case 'user-not-found':
      //   return const DefaultSignUpFailure('User not found. Please check your credentials🔍');
      // case 'wrong-password':
      //   return const DefaultSignUpFailure('Incorrect password 😞');
      case 'too-many-requests':
        return const DefaultSignUpFailure(
            'Too many unsuccessful login attempts. Please try again later⏳');
      case 'email-already-in-use':
        return const DefaultSignUpFailure(
            'Email is already in use. Please use a different email address📧');
      case 'operation-not-allowed':
        return const DefaultSignUpFailure(
            'Operation not allowed. Please contact support for assistance❌');
      default:
        return const DefaultSignUpFailure(
            'An error occurred. Please try again later😕');
    }
  }
}
