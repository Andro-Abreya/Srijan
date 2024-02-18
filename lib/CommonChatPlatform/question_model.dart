import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String userName;
  final String userId;
  final String text;
  final DateTime timestamp;
  final String userProfPic;
  final String imageUrl;

  Question({
    required this.id,
    required this.userName,
    required this.userId,
    required this.text,
    required this.timestamp,
    required this.userProfPic,
    required this.imageUrl,

  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json['id'],
        userName: json['userName'],
        userId: json['userId'],
        text: json['text'],
        timestamp: DateTime.parse(json['timestamp']),
        userProfPic: json['userProfPic']??" ",
        imageUrl: json['imageUrl']??" ",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "userName": userName,
      'userId': userId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'userProfPic': userProfPic,
      'imageUrl':imageUrl,
    };
  }
  factory Question.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Question(
        id: doc.id,
        userName: data['userName'],
        userId: data['userId'],
        text: data['text'],
        timestamp: data['timestamp'] is Timestamp
            ? (data['timestamp'] as Timestamp).toDate()
            : DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
        userProfPic: data['userProfPic'],
        imageUrl: data['imageUrl']
      // Add any other properties as needed
    );
  }
}
