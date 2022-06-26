import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void goToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 25, bottom: 10, right: 25),
            child: TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter your email here",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, bottom: 10, right: 25),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Enter your password here",
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blue,
            ),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                debugPrint("\n\n${userCredential.toString()}");
                goToHome();
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  showLoginErrorDialog(context, "Invalid Email");
                } else if (e.code == 'wrong-password') {
                  showLoginErrorDialog(context, "Wrong Password");
                }
              }
            },
            child: const Text("Login"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Not registered yet?'),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/register/', (route) => false);
                },
                child: const Text('Register here'),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Future<bool> showLoginErrorDialog(BuildContext context, String title) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(title),
        ),
      );
    },
  ).then(
    (value) => value ?? false,
  );
}
