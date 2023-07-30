import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total,notAttempted;
  const Results(
      {super.key,
      required this.correct,
      required this.incorrect,
      required this.total,
      required this.notAttempted,
      });

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                Text("${widget.correct} / ${widget.total}"),
                const SizedBox(height: 10),
                Text(
                  " You Have ${widget.correct} correctly done and ${widget.incorrect} incorrectlt done!"
                ),
                const SizedBox(height:50),
                 SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                          
                      },
                      child: Text(
                        'Back To Home',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                        style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.redAccent, //background color of button
                       
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  
              ],
            ),
          ),
        ),
      ),
    );
  }
}
