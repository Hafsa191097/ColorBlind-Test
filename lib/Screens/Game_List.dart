import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Action;

import '../Auth/firestore.dart';
import 'blindtestscreen.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Quiz').snapshots();

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  FireStoreDataBase db = FireStoreDataBase();
  // ignore: non_constant_identifier_names
  Widget QuizList() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
      
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
      
                return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    data['documentId'] = document.id;
                    return ListTile(
                      title: Text(data['Title'],
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                      subtitle: Text(data['Description']),
                      leading: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                          maxWidth: 58,
                          maxHeight: 100,
                        ),
                        child: Container(
                        width: 130,
                        height:155,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(96),
                          child: Image.network(
                            data['ImageUrl'],
                            fit: BoxFit.fill,
                          ),
                        ),
                          ),
                        ),
                      trailing: IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ActualQuiz(data['documentId'])));
                        },
                        icon: Icon(
                          Icons.play_arrow,
                          size: 30.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
