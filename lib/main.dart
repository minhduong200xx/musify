import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/screens/favorite_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'provider/favorite_provider.dart';
import 'screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9005);
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoriteSongsProvider(),
      child: const MyApp(),
    ),
  );
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  FirebaseAuth.instance.idTokenChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Name, email address, and profile photo URL
    final name = user.displayName;
    final email = user.email;
    final photoUrl = user.photoURL;

    // Check if user's email is verified
    final emailVerified = user.emailVerified;

    // The user's ID, unique to the Firebase project. Do NOT use this value to
    // authenticate with your backend server, if you have one. Use
    // User.getIdToken() instead.
    final uid = user.uid;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.deepPurple,
              displayColor: Colors.deepPurple,
            ),
      ),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/song', page: () => const SongScreen()),
        GetPage(name: '/playlist', page: () => const PlaylistScreen()),
        GetPage(name: '/favorite', page: () => const FavoriteSong()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
    );
  }
}
