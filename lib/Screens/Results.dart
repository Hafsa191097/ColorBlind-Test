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
    late double percentage;

  @override
  void initState() {
    super.initState();
    calculatePercentage();
  }

  void calculatePercentage() {
    if (widget.total > 0) {
      percentage = (widget.correct / widget.total) * 100;
    } else {
      percentage = 0.0;
    }
  }

    @override
  void didUpdateWidget(covariant Results oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.total != widget.total || oldWidget.correct != widget.correct) {
      calculatePercentage();
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'images/doctor1.jpg'; 

    if (percentage < 40) {
      imagePath = 'images/doctor1.jpg';
    } else if (percentage >= 41 && percentage <= 80) {
      imagePath = 'images/doctor2.jpg';
    } else if (percentage > 80) {
      imagePath = 'images/doctor3.jpg';
    }
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
                Image.asset(imagePath),
                SizedBox(height:30),
                Text("${widget.correct} / ${widget.total}"),
                const SizedBox(height: 10),
                Text(
                  " You Have ${widget.correct} correctly done and ${widget.incorrect} incorrectly done!"
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
