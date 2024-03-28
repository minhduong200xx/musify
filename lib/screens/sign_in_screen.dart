import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_app_ui/screens/sign_up_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with Gradient Text
              Center(
                  child: Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: <Color>[
                        Colors.deepPurple.shade400,
                        Colors.deepPurpleAccent
                      ],
                    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                ),
              )),

              // Sign Up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: Colors.deepPurple.shade800.withOpacity(0.8),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to login/register screen (using your chosen navigation method)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignUpPage()), // Replace with your login screen widget
                      );
                    }, // Navigate to signup page (replace with your route name)
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.deepPurple.shade500.withOpacity(0.8),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Form with Rounded Borders
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: ValueKey('emailField'),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.deepPurple.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email address.';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value!,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      key: ValueKey('passwordField'),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.deepPurple.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        suffixIcon: Icon(Icons.visibility_off),
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
                  ],
                ),
              ),

              SizedBox(height: 16.0),

              // Login Button with Gradient Background
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _formKey.currentState!.save();

                            try {
                              final userCredential =
                                  await _auth.signInWithEmailAndPassword(
                                email: _email,
                                password: _password,
                              );

                              print('Login successful!');
                              Navigator.pushNamed(context, '/');
                            } on FirebaseAuthException catch (e) {
                              print(e.code);
                              print(e.message);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message!),
                                ),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Login'),
                      ),
              ),

              // Forgot Password Text
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextButton(
                    onPressed: () {
                      // Implement Forgot Password functionality
                      print('Forgot Password pressed');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.deepPurple.shade800.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton(
                    Buttons.Google,
                    onPressed: () => print('Google Login pressed'),
                  ),
                  SizedBox(width: 8.0),
                  SignInButton(
                    Buttons.Facebook,
                    onPressed: () => print('Facebook Login pressed'),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
