import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final String name;
  final String bgUrl;
  final String listens;

  Auth({
    required this.name,
    required this.bgUrl,
    required this.listens,
  });

  static List<Auth> artist = [];

  static Future<void> fetchDataFromFirestore() async {
    try {
      CollectionReference artists =
          FirebaseFirestore.instance.collection('singer');

      QuerySnapshot querySnapshot = await artists.get();

      querySnapshot.docs.forEach((doc) {
        artist.add(
          Auth(
            name: doc['name'],
            bgUrl: doc['bgUrl'],
            listens: doc['listens'],
          ),
        );
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
