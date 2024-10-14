import 'package:cicada1/pages/round1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Rules extends StatefulWidget {
  final String phoneNumber;
  Rules({required this.phoneNumber});

  @override
  State<Rules> createState() => RulesState();
}

class RulesState extends State<Rules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 29, 22),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Rules",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 49, 29, 22),
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                title: 'Are you ready!!',
                text: 'Your time will starts now',
                confirmBtnText: 'Start',
                onConfirmBtnTap: () async {
                  late DateTime startTime;
                  startTime = DateTime.now();
                  FirebaseFirestore _firestore = FirebaseFirestore.instance;
                  try {
                    await _firestore
                        .collection('users')
                        .doc(widget.phoneNumber)
                        .update({
                      'startTime': startTime,
                    });
                  } catch (e) {
                    print('Error comparing values: $e');
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuestionOne(phoneNumber: widget.phoneNumber),
                    ),
                  );
                },
              );
            },
            child: const Text("Done"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
