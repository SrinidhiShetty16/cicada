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
  final TextEditingController _acontroller1 = TextEditingController();
  final TextEditingController _acontroller2 = TextEditingController();
  final TextEditingController _acontroller3 = TextEditingController();
  final TextEditingController _acontroller4 = TextEditingController();
  final TextEditingController _acontroller5 = TextEditingController();
  late YoutubePlayerController _controller;
  var wrongAnswer = "";

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'rUPiiUExiq4',
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

  void correct() {
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
  }

  void wrong() {
    setState(
      () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Wrong answer',
          text: 'List of wrong answers$wrongAnswer.\n2 mins added to your time',
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

  void checkAnswer() {
    if (_acontroller1.text.trim().toLowerCase() != "7:24" &&
        _acontroller1.text.trim().toLowerCase() != "7:24pm" &&
        _acontroller1.text.trim().toLowerCase() != "7:24 pm") {
      wrongAnswer = "$wrongAnswer 1";
    }
    if (_acontroller2.text.trim().toLowerCase() != "mrunal thakur" &&
        _acontroller2.text.trim().toLowerCase() != "mrunal") {
      wrongAnswer = "$wrongAnswer 2";
    }
    if (_acontroller3.text.trim().toLowerCase() != "red" &&
        _acontroller3.text.trim().toLowerCase() != "red and white" &&
        _acontroller3.text.trim().toLowerCase() != "white and red") {
      wrongAnswer = "$wrongAnswer 3";
    }
    if (_acontroller4.text.trim().toLowerCase() != "amul") {
      wrongAnswer = "$wrongAnswer 4";
    }
    if (_acontroller5.text.trim().toLowerCase() != "yellow") {
      wrongAnswer = "$wrongAnswer 5";
    }
    if (wrongAnswer == "") {
      correct();
    } else {
      wrong();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Answer all the following questions",
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
                const Text(
                  "1. At what time was Shaay cafe's video shot?",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _acontroller1,
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
                const Text(
                  "2. Which heroine's video was being played?",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _acontroller2,
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
                const Text(
                  "3. What colour shirt was goal keeper wearing?",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _acontroller3,
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
                const Text(
                  "4. Which ice-cream brand's freezer was present in the video?",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _acontroller4,
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
                const Text(
                  "5. What's the colour of the dustbin?",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: _acontroller5,
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
        ),
      ),
    );
  }
}
