class ChatUser {
  ChatUser({
    required this.name,
    required this.email,
    required this.about,
    required this.id,
    required this.isOnline,
    required this.createdAt,
    required this.lastActive,
    required this.pushToken,
    required this.image,
  });

  late String name;
  late String email;
  late String about;
  late String id;
  late bool isOnline;
  late String createdAt;
  late String lastActive;
  late String pushToken;
  late String image;

  ChatUser.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    about = json['about'] ?? '';
    id = json['id'] ?? '';
    isOnline = json['isOnline'] ?? '';
    createdAt = json['createdAt'] ?? '';
    lastActive = json['lastActive'] ?? '';
    pushToken = json['pushToken'] ?? '';
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['about'] = about;
    data['id'] = id;
    data['isOnline'] = isOnline;
    data['createdAt'] = createdAt;
    data['lastActive'] = lastActive;
    data['pushToken'] = pushToken;
    data['image'] = image;
    return data;
  }
}
