import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:video_conferening_mobile/homeScreen.dart';
import 'package:video_conferening_mobile/models/meeting_details.dart';
import 'package:video_conferening_mobile/remoteconnection.dart';
import 'package:video_conferening_mobile/utils/user.utils.dart';
import 'package:video_conferening_mobile/widgets/controlButton.dart';

class MeetingPage extends StatefulWidget {
  final String? meetingId;
  final String? name;
  final MeetingDetail meetingDetail;
  const MeetingPage({
    Key? key,
    this.meetingId,
    this.name,
    required this.meetingDetail,
  }) : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRenderer = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {"audio": true, "video": true};
  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: _buildMeetingRoom(),
        bottomNavigationBar: ControlPanel(
          onAudioToggle: onAudioToggle,
          onVideoToggle: onVideoToggle,
          videoEnabled: isVideoEnabled(),
          audioEnabled: isAudioEnabled(),
          isConnectionFailed: isConnectionFailed, onReconnect: handleReconnect,
          onMeetingEnd: onMeetingEnd, // ControlPanel
        )); // Scaffold
  }

  void startMeeting() async {
    final String userId = await loadUserId();
    meetingHelper = WebRTCMeetingHelper(
      url: "http://192.168.1.9:4000",
      meetingId: widget.meetingDetail.id,
      userId: userId,
      name: widget.name,
    );

    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    meetingHelper!.stream = _localStream;
    meetingHelper!.on("open", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("connection", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    meetingHelper!.on("user-left", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    meetingHelper!.on("video-toggle", context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on("audio-toggle", context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on("meeting-ended", context, (ev, context) {
      onMeetingEnded();
    });

    meetingHelper!.on("connection-setting-changed", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    meetingHelper!.on("stream-changed", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    setState(() {});
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRenderer.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  void onMeetingEnded() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  _buildMeetingRoom() {
    return Stack(children: [
      meetingHelper != null && meetingHelper!.connections.isNotEmpty
          ? GridView.count(
              crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
              children:
                  List.generate(meetingHelper!.connections.length, (index) {
                return Padding(
                  padding: EdgeInsets.all(1),
                  child: RemoteConnection(
                    renderer: meetingHelper!.connections[index].renderer,
                    connection: meetingHelper!.connections[index],
                  ), // RemoteConnection
                ); // Padding
              }), // List.generate
            )
          : Center(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Waiting for participants to join the meeting",
                    style: TextStyle(color: Colors.white),
                  ) // Padding
                  ) // Center
              ),

      Positioned(
        bottom: 10,
        right: 0,
        child: SizedBox(
          width: 150,
          height: 200,
          child: RTCVideoView(_localRenderer),
        ), // SizedBox
      ), // Positioned
    ]);
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }

  void handleReconnect() {}
  bool isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false;
  }

  bool isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }

  void onMeetingEnd() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
  }
}





// class _MeetingPageState extends State<MeetingPage> {
//   final localRenderer = RTCVideoRenderer();
//   @override
//   Widget build(BuildContext context) {
//     return Text("data");
//   }
// }
