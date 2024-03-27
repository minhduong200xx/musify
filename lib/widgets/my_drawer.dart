import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/widgets/my_list_tile.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final _auth = FirebaseAuth.instance;
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushNamed(context, '/');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> routeNames = ['/', '/profile'];
    return Drawer(
      backgroundColor: Colors.deepPurple,
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 44,
            ),
          ),
          MyListTile(
            icon: Icons.account_circle,
            text: 'Profile',
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          MyListTile(
            icon: FirebaseAuth.instance.currentUser != null
                ? Icons.logout
                : Icons.login,
            text: FirebaseAuth.instance.currentUser != null
                ? "Sign Out"
                : "Sign In",
            onTap: () {
              if (FirebaseAuth.instance.currentUser != null) {
                _signOut(); // Call sign out function if user is logged in
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
          MyListTile(
            icon: Icons.support_agent,
            text: "Support",
            onTap: () {},
          ),
          MyListTile(
            icon: Icons.verified_user,
            text: "Privacy",
            onTap: () {},
          ),
          MyListTile(
            icon: Icons.gavel,
            text: "Rules",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
