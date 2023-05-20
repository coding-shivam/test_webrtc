import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:video_conferening_mobile/join_screen.dart';
import 'package:video_conferening_mobile/models/meeting_details.dart';
import 'package:video_conferening_mobile/utils/api/meeting_api.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
          ),
        ),
        home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebRTC example"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controller,
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () async {
                    var response = await startMeeting();
                    final body = json.decode(response!.body);
                    final meetId = body['data'];
                    validateMeeting(meetId);
                  },
                  child: Text("Start meeting")),
              SizedBox(
                width: 20,
              ),
              TextButton(
                  onPressed: () {
                    validateMeeting(controller.text);
                  },
                  child: Text("join meeting")),
            ],
          )
        ],
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    try {
      Response response = await joinMeeting(meetingId);
      var data = json.decode(response.body);
      final meetingDetails = MeetingDetail.fromJson(data["data"]);
      goToJoinScreen(meetingDetails);
    } catch (err) {
      FormHelper.showSimpleAlertDialog(
          context, "Meeting App", "Invalid Meeting Id", "OK", () {
        Navigator.of(context).pop();
      });
    }
  }

  goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JoinMeeting(
            meetingId: meetingDetail.id,
            meetingDetail: meetingDetail,
          ),
        ));
  }
}
