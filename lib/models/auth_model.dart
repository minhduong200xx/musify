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
      // Lấy reference tới collection "artists" trong Firestore
      CollectionReference artists =
          FirebaseFirestore.instance.collection('singer');

      // Lấy dữ liệu từ Firestore
      QuerySnapshot querySnapshot = await artists.get();

      // Duyệt qua từng tài liệu và thêm vào danh sách artist
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
      // Xử lý lỗi nếu có
      print("Error fetching data: $e");
    }
  }
}
