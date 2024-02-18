import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesis_flutter/CommonChatPlatform/add_question.dart';
import 'package:genesis_flutter/CommonChatPlatform/commentscreen.dart';
import 'package:genesis_flutter/CommonChatPlatform/firestore_service.dart';
import 'package:genesis_flutter/CommonChatPlatform/question_model.dart';
import 'package:genesis_flutter/CommonChatPlatform/comment_model.dart';


class QnAApp extends StatefulWidget {
  @override
  _QnAAppState createState() => _QnAAppState();
}

class _QnAAppState extends State<QnAApp> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  List<Question> _displayedQuestions = [];
  List<Question> _filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    // Initially, get all questions without any filtering
    _firestoreService.getQuestions().listen((questions) {
      setState(() {
        _displayedQuestions = questions;
        _filteredQuestions = _displayedQuestions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Mumma's Community"),
      ),
      body: Column(
        children: [
          // Text field for typing and submitting questions

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                border: Border.all(color: Colors.grey), // Set the border color
                color: Colors.white, // Set the background color
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search questions...',
                    suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        // Reset the displayed questions to all questions when clearing search
                        setState(() {
                          _filteredQuestions = _displayedQuestions;
                        });
                      },
                    ) : Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(9) ,
                        color: Colors.purple.withOpacity(0.5), // Set the background color to pink
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search, size: 30.0, color: Colors.white),
                        tooltip: 'Send Message',
                        splashRadius: 30.0,
                        onPressed: () {},
                      ),
                    ),
                  ),
                  onChanged: (searchText) {
                    // Update the displayed questions based on the search text
                    setState(() {
                      _filteredQuestions = _displayedQuestions
                          .where((question) =>
                          question.text.toLowerCase().contains(searchText.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
            ),
          ),



          // StreamBuilder to display recently added questions and comments
          Expanded(
            child: ListView.builder(
              itemCount: _filteredQuestions.length,
              itemBuilder: (context, index) {
                final question = _filteredQuestions[index];
                return _buildQuestionItem(question);
              },
            ),
          )
          // StreamBuilder<List<Question>>(
          //   stream: _firestoreService.getQuestions(), // Use a stream from the future
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return CircularProgressIndicator();
          //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //       return Text('No questions available.');
          //     } else {
          //       // Update _displayedQuestions when the stream emits new data
          //       _displayedQuestions = snapshot.data!;
          //
          //       // Display the list of questions and comments
          //       return Expanded(
          //         child: ListView.builder(
          //           itemCount: _displayedQuestions.length,
          //           itemBuilder: (context, index) {
          //             final question = _displayedQuestions[index];
          //             return _buildQuestionItem(question);
          //           },
          //         ),
          //       );
          //     }
          //   },
          // ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddQuestionScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),

    );


  }


  Widget _buildQuestionItem(Question question) {
    return Card(
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
                  backgroundImage: Image.network(question.userProfPic).image, // You can use an image here if you have user profile pictures
                ),
                SizedBox(width: 8.0),
                Text(
                  question.userName, // Replace with the actual user's name
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
               child: Text(
                    question.text,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),),



                SizedBox(width: 10,),
                // Add spacer to push comment icon to the right
           (question.imageUrl != null && question.imageUrl.isNotEmpty)?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                question.imageUrl,
                height: 150, // Adjust the height as needed
                width: double.infinity, // Take the full width of the card
                fit: BoxFit.contain,
              ),
            ):Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 200,),
                      InkWell(
                        onTap: (){

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(question: question),
                            ),
                          );

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all( 8.0),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(right: 2.0),
                                    child: Text(
                                      "Ans",
                                      style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Icon(Icons.edit, color: Colors.blue,size: 20,),

                                ],
                              ),

                          ),

                        ),
                      ),
                    ],
                  ),
                ),


        ],
      ),
    );
  }

  // void _submitComment(String questionId, String commentText) {
  //   if (commentText.isNotEmpty) {
  //     final AppComment newComment = AppComment(
  //       id: DateTime.now().millisecondsSinceEpoch.toString(),
  //       questionId: questionId,
  //       userId: FirebaseAuth.instance.currentUser?.uid ?? '',
  //       text: commentText,
  //       likes: 0,
  //       dislikes: 0,
  //       timestamp: DateTime.now(), userName: '',
  //     );
  //     _firestoreService.addCommentToQuestion(questionId, newComment);
  //   }
  // }


// void _submitQuestion() {
//   final user = FirebaseAuth.instance.currentUser;
//   final  uid =user?.uid;
//   final String questionText = _questionController.text.trim();
//   if (questionText.isNotEmpty) {
//     // Check if the question already exists
//     // You may want to implement a logic to check for existing questions
//     // For simplicity, we'll add the question directly without checking for duplicates
//     final Question newQuestion = Question(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       userName: "my name",
//       userId: uid.toString(), // Replace with the actual user ID
//       text: questionText,
//       timestamp: DateTime.now(),
//       userProfPic:
//     );
//     _firestoreService.addQuestion(newQuestion);
//
//     // Clear the text field after submitting the question
//     _questionController.clear();
//   }
// }
}

