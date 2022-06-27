enum Routes {
  login('/login/'),
  register('/register/'),
  verifyEmail('/verify-email/'),
  notes('/notes/');

  const Routes(this.value);
  final String value;
}
