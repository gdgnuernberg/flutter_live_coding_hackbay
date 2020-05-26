class RandomUser {
  final String userID;
  final String profilePic;
  final String largeProfilePic;
  final String username;
  final DateTime timestampLastMessage;
  
  String lastMessage;

  RandomUser(
    this.userID,
    this.profilePic,
    this.largeProfilePic,
    this.username,
    this.timestampLastMessage, {
    this.lastMessage,
  });

  factory RandomUser.fromJson(Map<String, dynamic> json) {
    return RandomUser(
      json['login']['uuid'],
      json['picture']['thumbnail'],
      json['picture']['large'],      
      json['login']['username'],
      DateTime.tryParse(json['dob']['date']),
    );
  }
}
