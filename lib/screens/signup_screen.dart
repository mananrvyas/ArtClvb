import 'package:flutter/material.dart';
// import 'signup_screen.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: const Text('There was an error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              )
            ],
          ),
    );
  }

  void _signUp() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Email and Password cannot be empty");
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog("Incorrect Password");
      return;
    }

    final UserCredential? userCredential = await _authService.signUp(
        email, password);
    if (userCredential != null) {
      // show success dialog
      showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: const Text('Success'),
              content: const Text('Signup successful'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen())
                    );
                  },
                  child: const Text('Okay'),
                )
              ],
            ),
      );

    } else {
      _showErrorDialog("Signup failed (unknown reason)");
    }
  }
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'ArtClvb',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _signUp();
                  },
                  child: const Text('Signup'),
                ),
                TextButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen())
                      );
                    },
                    child: Text('Already have an account? Login here')
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

