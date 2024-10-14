import 'dart:math';
import 'package:cicada1/pages/round4.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class R3 {
  final List<Map<String, String>> _question3 = [
    {
      "question": "G",
      "answer": "g",
    },
    {
      "question": "H",
      "answer": "h",
    },
    {
      "question": "I",
      "answer": "i",
    }
  ];
  Map<String, String> getRandomQuestion() {
    final randomIndex = Random().nextInt(_question3.length);
    return _question3[randomIndex];
  }
}

class QuestionThree extends StatefulWidget {
  final String phoneNumber;
  QuestionThree({required this.phoneNumber});

  @override
  State<QuestionThree> createState() => _QuestionThreeState();
}

class _QuestionThreeState extends State<QuestionThree> {
  final R3 questionProvider = R3();
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
      setState(() {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "That's right",
          text: 'You have entered right answer',
          confirmBtnText: 'Next round',
          onConfirmBtnTap: () async {
            FirebaseFirestore _firestore = FirebaseFirestore.instance;
            try {
              String nextRound = '4';
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
                    QuestionFour(phoneNumber: widget.phoneNumber),
              ),
            );
          },
        );
      });
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
              "Question 3",
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
