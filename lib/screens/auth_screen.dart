import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email/Password Login
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle errors (e.g., user not found, wrong password)
      print(e.code);
      print(e.message);
      return null;
    }
  }

  // Google Sign In (replace with your actual implementation)
  Future<UserCredential?> signInWithGoogle() async {
    // Implement Google Sign In using a suitable plugin
    print('Google sign in not implemented yet');
    return null;
  }

  // Facebook Sign In (replace with your actual implementation)
  Future<UserCredential?> signInWithFacebook() async {
    // Implement Facebook Sign In using a suitable plugin
    print('Facebook sign in not implemented yet');
    return null;
  }
}

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final Authentication _auth =
      Authentication(); // Instance of the Authentication class
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false; // Flag to indicate loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 20.0),
              _isLoading
                  ? const CircularProgressIndicator() // Display progress indicator during login
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true; // Set loading state to true
                          });
                          _formKey.currentState!.save();
                          final userCredential = await _auth
                              .signInWithEmailAndPassword(_email, _password);
                          setState(() {
                            _isLoading =
                                false; // Reset loading state after login
                          });
                          if (userCredential != null) {
                            // Handle successful login (e.g., navigate to home screen)
                            print('Login successful!');
                          } else {
                            // Handle failed login (display error message)
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
