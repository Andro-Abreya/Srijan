import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:genesis_flutter/CommonChatPlatform/question_model.dart';
import 'package:genesis_flutter/CommonChatPlatform/comment_model.dart';
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamController<List<Question>> _questionsController =
  StreamController<List<Question>>.broadcast();
  Stream<List<Question>> get questionsStream =>
      _questionsController.stream;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Create a new question
  Future<void> addQuestion(Question question) async {
    await _firestore.collection('questions').doc(question.id).set(question.toJson());
  }

  // // Get all questions
  Stream<List<Question>> getQuestions() {
    return _firestore.collection('questions').snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return Question.fromJson(doc.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }


  // Add a new comment to a question
  Future<void> addCommentToQuestion(String questionId, AppComment comment) async {
    await _firestore
        .collection('questions')
        .doc(questionId)
        .collection('comments').doc(comment.id)
        .set(comment.toJson());
  }

  // Get all comments for a question
  Stream<List<AppComment>> getCommentsForQuestion(String questionId) {

    return  _firestore
        .collection('questions')
        .doc(questionId)
        .collection('comments')
        .snapshots()
        .map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return AppComment.fromJson(doc.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }

  // Like a comment
  Future<void> likeComment(String questionId, String commentId) async {
    await _firestore
        .collection('questions')
        .doc(questionId)
        .collection('comments')
        .doc(commentId)
        .update({
      'likes': FieldValue.increment(1),
    });
  }

  // Dislike a comment
  Future<void> dislikeComment(String questionId, String commentId) async {
    await _firestore
        .collection('questions')
        .doc(questionId)
        .collection('comments')
        .doc(commentId)
        .update({
      'dislikes': FieldValue.increment(1),
    });
  }


  DocumentSnapshot<Map<String, dynamic>>? getUserData()  {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
         FirebaseFirestore.instance.collection('Users').doc(uid).get() as DocumentSnapshot<Map<String, dynamic>>;

        // Check if the user document exists
        if (userSnapshot.exists) {
          // Access the 'name' field from the user document
          String? userName = userSnapshot.get('name');
          return userSnapshot;
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





  Future<String?> uploadImage(File image, String questionId) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference ref = _storage.ref().child('question_images/$questionId.jpg');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(image);

      // Get the download URL once the upload is complete
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

}
