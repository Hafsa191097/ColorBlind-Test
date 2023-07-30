import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDataBase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   getQuizData() {
    return _firestore.collection('Quiz').snapshots();
  }

  Future<QuerySnapshot<Map<String,dynamic>>> getQuestionsForQuiz(String QuizId)  {
    return _firestore.collection('Quiz').doc(QuizId).collection('Questions').get();
    
  }
  Stream<QuerySnapshot<Map<String,dynamic>>> getQuestionsForQuizStream(String QuizId)  {
    return _firestore.collection('Quiz').doc(QuizId).collection('Questions').snapshots();
  }
}