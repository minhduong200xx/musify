class Auth {
  final String name;
  final String bgUrl;
  final int listenCount;

  Auth({
    required this.name,
    required this.bgUrl,
    required this.listenCount,
  });

  static Auth? findArtistByName(String name) {
    return artist?.firstWhere((auth) => auth.name == name,
        orElse: () => null as Auth);
  }

  static List<Auth> artist = [
    Auth(
      name: 'Artist Name 1',
      bgUrl: 'assets/images/auth.jpg',
      listenCount: 990,
    ),
    Auth(
      name: 'Artist Name 2',
      bgUrl: 'assets/images/auth.jpg',
      listenCount: 991,
    ),
    Auth(
      name: 'Artist Name 3',
      bgUrl: 'assets/images/auth.jpg',
      listenCount: 992,
    ),
    Auth(
      name: 'Phương Ly',
      bgUrl: 'assets/images/auth.jpg',
      listenCount: 993,
    )
  ];
}
