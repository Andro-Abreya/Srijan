class AppComment {
  final String id;
  final String userName;
  final String userImage;
  final String userId;
  final String questionId;
  final String text;
  final int likes;
  final int dislikes;
  final DateTime timestamp;

  AppComment({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.userId,
    required this.questionId,
    required this.text,
    required this.likes,
    required this.dislikes,
    required this.timestamp,
  });

  factory AppComment.fromJson(Map<String, dynamic> json) {
    return AppComment(
      id: json['id'],
      userName: json['userName'],
      userImage: json['userImage'],
      userId: json['userId'],
      questionId: json['questionId'],
      text: json['text'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userImage': userImage,
      'userId': userId,
      'questionId': questionId,
      'text': text,
      'likes': likes,
      'dislikes': dislikes,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
