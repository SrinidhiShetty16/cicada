import 'dart:math';
import 'package:cicada1/pages/finished.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class R10 {
  final List<Map<String, String>> _question10 = [
    {
      "question": "B",
      "answer": "b",
    },
    {
      "question": "C",
      "answer": "c",
    },
    {
      "question": "D",
      "answer": "d",
    },
  ];
  Map<String, String> getRandomQuestion() {
    final randomIndex = Random().nextInt(_question10.length);
    return _question10[randomIndex];
  }
}

class QuestionTen extends StatefulWidget {
  final String phoneNumber;
  QuestionTen({required this.phoneNumber});

  @override
  State<QuestionTen> createState() => _QuestionTenState();
}

class _QuestionTenState extends State<QuestionTen> {
  final R10 questionProvider = R10();
  late Map<String, String> currentQuestion;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentQuestion = questionProvider.getRandomQuestion();
  }

  void checkAnswer() {
    if (_controller.text.trim().toLowerCase() ==
        currentQuestion['answer']?.toLowerCase()) {
      setState(
        () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "Congratulations!!",
            text: 'You have finished this online round',
            confirmBtnText: 'Next round',
            onConfirmBtnTap: () async {
              late DateTime endTime;
              endTime = DateTime.now();
              FirebaseFirestore _firestore = FirebaseFirestore.instance;
              try {
                DocumentSnapshot doc = await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .get();
                String nextRound = "11";
                DateTime startTime = doc['startTime'].toDate();
                Duration elapsed = DateTime.now().difference(startTime);
                await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .update({
                  'endTime': endTime,
                  'timeTaken': elapsed.inSeconds,
                  'nextRound': nextRound,
                });
              } catch (e) {
                // print('Error comparing values: $e');
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Finished(),
                ),
              );
            },
          );
        },
      );
    } else {
      setState(
        () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Wrong answer',
            text: 'You have entered wrong answer',
            confirmBtnText: 'Try again',
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Question 10",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Text(
            '${currentQuestion['question']}',
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter your answer',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: checkAnswer,
            child: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
