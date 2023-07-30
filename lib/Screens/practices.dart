import 'package:flutter/material.dart';

class Practices extends StatelessWidget {
  const Practices({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: ColorBlindEyePracticesPage(),
    );
  }
}


class ColorBlindEyePracticesPage extends StatefulWidget {
  @override
  _ColorBlindEyePracticesPageState createState() =>
      _ColorBlindEyePracticesPageState();
}

class _ColorBlindEyePracticesPageState extends State<ColorBlindEyePracticesPage>
    with SingleTickerProviderStateMixin {
  final List<String> eyePractices = [
    "Focus on distinguishing different shades of colors used in traffic signals..",
    "Practice identifying common color combinations used in traffic signals.",
    "Use color-blind simulation apps to see how color-blind individuals perceive the world.",
    "Try color-blind glasses to experience a different perspective used in traffic signals..",
    "Avoid relying solely on color to convey information; use labels and symbols as well.",
  ];

  List<bool> completedPractices = List.generate(5, (index) => false);

  void toggleCompletionStatus(int index) {
    setState(() {
      completedPractices[index] = !completedPractices[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: eyePractices.length,
              itemBuilder: (context, index) {
                return _buildAnimatedPracticeCard(index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width:double.infinity,
              height:45,
              child: ElevatedButton(
                
                onPressed: () {
                  var snackBar = SnackBar(content: Text("Great Good To Go!"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text(
                  'Done ',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildAnimatedPracticeCard(int index) {
    final isCompleted = completedPractices[index];

    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuad,
          margin: EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: () => toggleCompletionStatus(index),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              color: isCompleted ? Colors.green[100] : Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isCompleted ? Colors.green : Colors.redAccent,
                  child: Icon(
                    isCompleted ? Icons.check : Icons.remove_circle,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  eyePractices[index],
                  style: TextStyle(
                    decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                trailing: Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              
            ),
          ),
          
        ),
         
      ],
    );
    
  }
}