import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../Auth/firestore.dart';
import '../Constants/Widgets.dart';
import '../Constants/quizWidget.dart';
import '../modelClasses/Question_Model.dart';
import 'Results.dart';

class ActualQuiz extends StatefulWidget {
  final String id;
  const ActualQuiz(this.id, {Key? key});

  @override
  State<ActualQuiz> createState() => _ActualQuizState();
}

int total = 0, notattempted = 0, correct = 0, incorrect = 0;
Stream<List<int>>? infoStream;

class _ActualQuizState extends State<ActualQuiz> {
  final FireStoreDataBase db = FireStoreDataBase();
  List<QuestionModel> quizQuestions = [];

  @override
  void initState() {
    super.initState();
    notattempted = 0;
    correct = 0;
    incorrect = 0;
    fetchData();
    infoStream ??=
        Stream<List<int>>.periodic(const Duration(milliseconds: 100), (x) {
      print("this is x $x");
      return [correct, incorrect];
    });
  }

  void fetchData() async {
    try {
      List<QuestionModel> question = [];
      QuerySnapshot<Map<String, dynamic>> questionSnapshot =
          await db.getQuestionsForQuiz(widget.id);
      question.addAll(questionSnapshot.docs.map((doc) {
        log(doc.toString());
        log(doc.data().toString());
        return QuestionModel(
            image: doc.data()['ImageUrl'],
            options: [
              doc.data()['Option1'] ?? '',
              doc.data()['Option2'] ?? '',
              doc.data()['Option3'] ?? '',
            ],
            correctAnswer: doc.data()['correctOption']);
      }));
      setState(() {
        quizQuestions = question;
        total = questionSnapshot.docs.length;
        notattempted = questionSnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        quizQuestions = [];
      });
    }
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          InfoHeader(
            length: quizQuestions.length,
          ),
          SizedBox(
            height: 10,
          ),
          if (quizQuestions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: quizQuestions.length,
                itemBuilder: (context, index) {
                  return QuizPLayTile(
                    modelClass: quizQuestions[index],
                    index: index,
                  );
                },
              ),
            ),
          if (quizQuestions.isEmpty)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check, color: Colors.white, size: 25),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        onPressed: () {
          if (notattempted != 0) {
            var snackBar = SnackBar(content: Text("Attempt All Questions!"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Results(
                  notAttempted: notattempted,
                  correct: correct,
                  total: total,
                  incorrect: incorrect,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      NoOfQuestionTile(
                        text: "Total",
                        number: widget.length,
                      ),
                      NoOfQuestionTile(
                        text: "Correct",
                        number: correct,
                      ),
                      NoOfQuestionTile(
                        text: "Incorrect",
                        number: incorrect,
                      ),
                      NoOfQuestionTile(
                        text: "NotAttempted",
                        number: notattempted,
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}

class QuizPLayTile extends StatefulWidget {
  final QuestionModel modelClass;
  final int index;
  const QuizPLayTile({required this.modelClass, required this.index, Key? key})
      : super(key: key);

  @override
  State<QuizPLayTile> createState() => _QuizPLayTileState();
}

class _QuizPLayTileState extends State<QuizPLayTile> {
  String optionSelected = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Question image from Firestore
        ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        ),
        const SizedBox(
          height: 20,
        ),
        if (widget.modelClass.image != null)
          CircleAvatar(
            radius: (80),
            backgroundColor: Colors.white,
            child: Image.network(
              widget.modelClass.image!,
              fit: BoxFit.fill,
            ),
          ),

        const SizedBox(
          height: 15,
        ),
        // Answere text from Firestore
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                if (!widget.modelClass.answered) {
                  if (widget.modelClass.options?[0] ==
                      widget.modelClass.correctAnswer) {
                    setState(() {
                      optionSelected = widget.modelClass.options![0];
                      widget.modelClass.answered = true;
                      correct += 1;
                      notattempted -= 1;
                    });
                  } else {
                    setState(() {
                      optionSelected = widget.modelClass.options![0];
                      widget.modelClass.answered = true;
                      incorrect += 1;
                      notattempted -= 1;
                    });
                  }
                }
              },
              child: OptionTile(
                option: "1",
                correctAns: widget.modelClass.correctAnswer ?? '',
                selectedAns: optionSelected,
                description: widget.modelClass.options?[0] ?? '',
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.modelClass.answered) {
                  if (widget.modelClass.options?[1] ==
                      widget.modelClass.correctAnswer) {
                    setState(() {
                      optionSelected = widget.modelClass.options![1];
                      widget.modelClass.answered = true;
                      notattempted -= 1;
                      correct += 1;
                    });
                  } else {
                    setState(() {
                      optionSelected = widget.modelClass.options![1];
                      widget.modelClass.answered = true;
                      incorrect += 1;
                      notattempted -= 1;
                    });
                  }
                }
              },
              child: OptionTile(
                option: "2",
                correctAns: widget.modelClass.correctAnswer ?? '',
                selectedAns: optionSelected,
                description: widget.modelClass.options?[1] ?? '',
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.modelClass.answered) {
                  if (widget.modelClass.options?[2] ==
                      widget.modelClass.correctAnswer) {
                    setState(() {
                      optionSelected = widget.modelClass.options![2];
                      widget.modelClass.answered = true;
                      notattempted -= 1;
                      correct += 1;
                    });
                  } else {
                    setState(() {
                      optionSelected = widget.modelClass.options![2];
                      widget.modelClass.answered = true;
                      incorrect += 1;
                      notattempted -= 1;
                    });
                  }
                }
              },
              child: OptionTile(
                option: "3",
                correctAns: widget.modelClass.correctAnswer ?? '',
                selectedAns: optionSelected,
                description: widget.modelClass.options?[2] ?? '',
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        // ElevatedButton(

        //   onPressed: () {
        //     // Add the logic to check if the user has attempted all questions.
        //     // You can navigate to the result page here when all questions are attempted.
        //   },
        //   child: Text('Submit'),
        // ),
      ],
    );
  }
}
