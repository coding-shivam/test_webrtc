import 'package:flutter/material.dart';
import 'package:video_conferening_mobile/meetingscreen.dart';
import 'package:video_conferening_mobile/models/meeting_details.dart';

class JoinMeeting extends StatefulWidget {
  final String? meetingId;
  final MeetingDetail? meetingDetail;
  const JoinMeeting({Key? key, this.meetingDetail, this.meetingId})
      : super(key: key);

  @override
  State<JoinMeeting> createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting> {
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
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: ((context) {
                        return MeetingPage(
                          meetingId: widget.meetingDetail!.id,
                          name: controller.text,
                          meetingDetail: widget.meetingDetail!,
                        ); // Meeting Page
                      }),
                    )); // MaterialPageRoute
                  },
                  child: Text("join")),
            ],
          )
        ],
      ),
    );
  }
}
