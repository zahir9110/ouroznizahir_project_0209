class User {
  final String id;
  final String name;
  final String avatar;
  final bool isOnline;
  final DateTime? lastSeen;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    this.isOnline = false,
    this.lastSeen,
  });
}
