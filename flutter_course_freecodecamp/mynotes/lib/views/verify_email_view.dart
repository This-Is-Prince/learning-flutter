import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/utils/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  void goToRegister() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.register.toString(),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify email"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
                "We've sent you a email verification. Please open it to verify your account."),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
                "If you have't received a verification email yet, press the button below"),
          ),
          Container(
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Send email verification"),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                goToRegister();
              },
              child: const Text("Restart"),
            ),
          ),
        ],
      ),
    );
  }
}
