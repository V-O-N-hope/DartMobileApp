import 'package:books/pages/home_page.dart';
import 'package:books/pages/auth/sign_up_page.dart';
import 'package:books/services/FirebaseAuthService.dart';
import 'package:books/widgets/input_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService authService = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (authService.getCurrentUser() != null) {
      return const HomePage();
    } else {
      return Scaffold(
          body: Center(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 30,
            ),
            InputWidget(
              maxLength: 80,
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            const SizedBox(
              height: 10,
            ),
            InputWidget(
              maxLength: 60,
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: _signIn,
                child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text("Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17))))),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                        (route) => false);
                  },
                  child: const Text("Create new account",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 17)),
                )
              ],
            )
          ],
        ),
      )));
    }
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await authService.signInWithEmailAndPassword(email, password);

    if (user != null) {
      Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } else {
      showDialog<void>(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Message or email were incorrect!'),
            content: const Text(''),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
