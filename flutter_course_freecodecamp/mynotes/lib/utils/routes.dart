enum Routes {
  login('/login/'),
  register('/register/'),
  notes('/notes/');

  const Routes(this.value);
  final String value;
}
