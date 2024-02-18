// add_question_screen.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/CommonChatPlatform/firestore_service.dart';
import 'package:genesis_flutter/CommonChatPlatform/question_model.dart';
import 'package:image_picker/image_picker.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Question"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [

                  Container(
                    width: 300,
                    child: TextField(
                      controller: _questionController,
                      decoration: InputDecoration(
                        hintText: 'Type your question here',
                      ),
                    ),
                ),
                IconButton(
                  onPressed: () async{
                    await  _pickImage();
                  },
                  icon: Icon(Icons.camera_alt, color: Colors.black,size: 30,), // Use the send message icon
                  tooltip: 'Pick image',
                  splashRadius: 30.0, // Adjust the splash radius if needed
                ),

              ],
            ),
            _selectedImage != null
                ? Image.file(
              _selectedImage!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            )
                : Container(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitQuestion();
                Navigator.pop(context, _questionController.text.trim());
              },
              child: Text('Add Question'),
            ),
          ],
        ),
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

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
    }
    // Update the UI to display the selected image
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submitQuestion() async {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseAuth auth = FirebaseAuth.instance;
    final  uid =user?.uid;
    String? userName = await getUserName();
    final String questionText = _questionController.text.trim();
    final String userPic = auth.currentUser!.photoURL.toString();
    print("userPic: $userPic");
    if (questionText.isNotEmpty) {
      // Check if the question already exists
      // You may want to implement a logic to check for existing questions
      // For simplicity, we'll add the question directly without checking for duplicates
      String questionId = uid.toString() + DateTime.now().millisecondsSinceEpoch.toString();
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _firestoreService.uploadImage(_selectedImage!, questionId);
      }
      final Question newQuestion = Question(
          id: questionId,
          userName: userName.toString(),
          userId: uid.toString(), // Replace with the actual user ID
          text: questionText,
          timestamp: DateTime.now(),
          userProfPic: userPic,
          imageUrl: imageUrl!=null?imageUrl:"",
      );
      _firestoreService.addQuestion(newQuestion);

      // Clear the text field after submitting the question
      _selectedImage=null;
      _questionController.clear();

    }
  }
}

