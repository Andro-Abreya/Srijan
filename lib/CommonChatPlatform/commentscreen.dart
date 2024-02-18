import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/CommonChatPlatform/firestore_service.dart';
import 'package:genesis_flutter/CommonChatPlatform/question_model.dart';
import 'package:genesis_flutter/CommonChatPlatform/comment_model.dart';
import 'package:genesis_flutter/NavScreen/ProfilePage.dart';

class CommentScreen extends StatefulWidget {
  final Question question;

  CommentScreen({required this.question});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  
  @override
  void initState()  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question Details"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                   CircleAvatar(
                    radius: 20.0,
                    backgroundImage: Image.network(widget.question.userProfPic).image, // You can use an image here if you have user profile pictures
                  ),
                      SizedBox(width: 8.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.question.userName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.question.text,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AppComment>>(
              stream: _firestoreService.getCommentsForQuestion(widget.question.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print("not getting object");
                  return Center(child: Text('No comments available.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final comment = snapshot.data![index];
                      return _buildCommentItem(comment, widget.question.id);
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Type your comment here',
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple, // Set the background color to pink
                  ),
                  child: IconButton(
                    onPressed: () async{
                      await _submitComment(widget.question.id, _commentController.text.trim());
                      _commentController.clear();
                    },
                    icon: Icon(Icons.send, size: 30.0, color: Colors.white), // Use the send message icon
                    tooltip: 'Send Message',
                    splashRadius: 30.0, // Adjust the splash radius if needed
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(AppComment comment, String questionId) {
    return ListTile(
      leading:
      CircleAvatar(
        radius: 20.0,
        backgroundImage: Image.network(comment.userImage).image, // You can use an image here if you have user profile pictures
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment.userName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            comment.text,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _firestoreService.likeComment(questionId, comment.id);
                },
                icon: Icon(Icons.thumb_up),
                iconSize: 20.0,
              ),
              Text('${comment.likes}'),
              SizedBox(width: 20,),
              IconButton(
                onPressed: () {
                  _firestoreService.dislikeComment(questionId, comment.id);
                },
                icon: Icon(Icons.thumb_down),
                iconSize: 20.0,
              ),
              Text('${comment.dislikes}'),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> getUserName() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        // Check if the user document exists
        if (userSnapshot.exists) {
          // Access the 'name' field from the user document
          String? userName = userSnapshot.get('name');
          return userName;
        } else {
          // User document does not exist
          return null;
        }
      } catch (e) {
        print("Error fetching user name: $e");
        return null;
      }
    } else {
      // User is not authenticated
      return null;
    }
  }

  Future<void> _submitComment(String questionId, String commentText) async {
    print("this is comment section");
    String? userName = await getUserName();
    final String userPic = auth.currentUser!.photoURL.toString();
    if (commentText.isNotEmpty) {
      final AppComment newComment = AppComment(
        id: questionId+DateTime.now().millisecondsSinceEpoch.toString(),
        userName: userName.toString(),
        userImage: userPic,
        questionId: questionId,
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        text: commentText,
        likes: 0,
        dislikes: 0,
        timestamp: DateTime.now(),
      );
      _firestoreService.addCommentToQuestion(questionId, newComment);
    }
  }
}
