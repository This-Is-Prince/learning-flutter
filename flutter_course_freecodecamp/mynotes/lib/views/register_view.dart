import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/utils/routes.dart';
import 'package:mynotes/utils/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  void goToVerifyEmail() {
    Navigator.of(context).pushNamed(
      Routes.verifyEmail.toString(),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                goToVerifyEmail();
                debugPrint("\n\n$userCredential.toString()");
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'email-already-in-use':
                    await showErrorDialog(
                      context,
                      "Email is already in use",
                    );
                    break;
                  case 'invalid-email':
                    await showErrorDialog(
                      context,
                      "This is an invalid email address",
                    );
                    break;
                  case 'weak-password':
                    await showErrorDialog(
                      context,
                      "Weak password",
                    );
                    break;
                  default:
                    await showErrorDialog(
                      context,
                      "Error: ${e.code}",
                    );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text("Register"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already registered?'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.login.toString(), (route) => false);
                },
                child: const Text('Login here'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
