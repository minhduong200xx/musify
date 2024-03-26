import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: user != null
              ? Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1659025435463-a039676b45a0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80',
                            ),
                            radius: 60,
                          ),
                        ),
                        Text(
                          user.displayName ??
                              'No Name', // Display name if available, otherwise "No Name"
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Row(
                      children: [
                        Text(
                          '3 danh sách phát công khai', // Replace with actual playlist count
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    // Add widgets to display other user information or functionalities
                  ],
                )
              : Center(
                  child: Text(
                    'Please sign in to view your profile',
                    style: const TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
        ),
      ),
    );
  }
}
