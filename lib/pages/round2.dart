import 'dart:math';
import 'package:cicada1/pages/round3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class R2 {
  final List<Map<String, String>> _question2 = [
    {
      "question": "D",
      "answer": "d",
    },
    {
      "question": "E",
      "answer": "e",
    },
    {
      "question": "F",
      "answer": "f",
    }
  ];
  Map<String, String> getRandomQuestion() {
    final randomIndex = Random().nextInt(_question2.length);
    return _question2[randomIndex];
  }
}

class QuestionTwo extends StatefulWidget {
  final String phoneNumber;
  QuestionTwo({required this.phoneNumber});

  @override
  State<QuestionTwo> createState() => _QuestionTwoState();
}

class _QuestionTwoState extends State<QuestionTwo> {
  final R2 questionProvider = R2();
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
            title: "That's right!!",
            text: 'You have entered right answer',
            confirmBtnText: 'Next Round',
            onConfirmBtnTap: () async {
              FirebaseFirestore _firestore = FirebaseFirestore.instance;
              try {
                String nextRound = '3';
                await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .update({
                  'nextRound': nextRound,
                });
              } catch (e) {}
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuestionThree(phoneNumber: widget.phoneNumber),
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
              "Question 2",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )
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
          )
        ],
      ),
    );
  }
}
