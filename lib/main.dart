import 'package:flutter/material.dart';
import 'package:musify/provider/provider_auth_follow.dart';
import 'package:musify/screens/artist_screen.dart';
import 'package:musify/screens/favorite_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'provider/favorite_provider.dart';
import 'screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:musify/screens/library_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAWVDnDoPMXo9hVlflMrU3ROOL8vt-F-vg",
          appId: "1:801043302492:android:bb9dedeafa025e9f3e7e99",
          messagingSenderId: "",
          projectId: "musifyapp-cbe22"));
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9005);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FollowProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteSongsProvider()),
      ],
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
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
      ),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/song', page: () => const SongScreen()),
        GetPage(name: '/playlist', page: () => const PlaylistScreen()),
        GetPage(
            name: '/favorite',
            page: () => const FavoriteSong(
                  userId: '',
                )),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/auth', page: () => const ArtistScreen()),
        GetPage(name: '/library', page: () => const LibraryScreen()),
      ],
    );
  }
}
