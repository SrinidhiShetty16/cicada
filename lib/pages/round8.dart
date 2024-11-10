import 'package:cicada1/pages/round9.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuestionEight extends StatefulWidget {
  final String phoneNumber;
  QuestionEight({required this.phoneNumber});

  @override
  State<QuestionEight> createState() => _QuestionEightState();
}

class _QuestionEightState extends State<QuestionEight> {
  final TextEditingController _acontroller = TextEditingController();
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'TMY1g8pAktk',
      flags: YoutubePlayerFlags(
        // autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkAnswer() {
    if (_acontroller.text.trim().toLowerCase() == "some answer") {
      setState(
        () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "That's right!!",
            text: 'You have cleared Round 8',
            confirmBtnText: 'Next Round',
            barrierDismissible: false,
            onConfirmBtnTap: () async {
              FirebaseFirestore _firestore = FirebaseFirestore.instance;
              try {
                String nextRound = '9';
                await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .update({
                  'nextRound': nextRound,
                });
              } catch (e) {}
              _controller.pause();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuestionNine(phoneNumber: widget.phoneNumber),
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
            text: 'You have entered wrong answer\n2 mins added to your time',
            confirmBtnText: 'Try again',
            barrierDismissible: false,
            onConfirmBtnTap: () async {
              FirebaseFirestore _firestore = FirebaseFirestore.instance;
              try {
                DocumentSnapshot userDoc = await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .get();

                var penaltyTime = userDoc['penaltyTime'];
                penaltyTime = penaltyTime + 120;
                await _firestore
                    .collection('users')
                    .doc(widget.phoneNumber)
                    .update({
                  'penaltyTime': penaltyTime,
                });
              } catch (e) {}
              _controller.pause();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuestionEight(phoneNumber: widget.phoneNumber),
                ),
              );
            },
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
              "Round 8",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Add question here",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true, // Show progress bar
              progressIndicatorColor: Colors.red,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _acontroller,
              decoration: InputDecoration(
                labelText: 'Enter your answer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
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
      ),
    );
  }
}
