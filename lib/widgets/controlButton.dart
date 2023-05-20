import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final bool? videoEnabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;
  ControlPanel({
    this.audioEnabled,
    this.videoEnabled,
    this.onAudioToggle,
    this.onVideoToggle,
    this.isConnectionFailed,
    this.onMeetingEnd,
    this.onReconnect,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildControls(),
      ),
      color: Colors.blueGrey,
    );
  }

  List<Widget> buildControls() {
    if (!isConnectionFailed!) {
      return <Widget>[
        IconButton(
          onPressed: onVideoToggle,
          icon: Icon(videoEnabled! ? Icons.videocam : Icons.videocam_off),
          color: Colors.white,
          iconSize: 32.0,
        ), // IconButton
        IconButton(
          onPressed: onAudioToggle,
          icon: Icon(audioEnabled! ? Icons.mic : Icons.mic_off),
          color: Colors.white,
          iconSize: 32.0,
        ), // IconButton
        SizedBox(
          width: 100,
        ),
        IconButton(
          onPressed: onMeetingEnd!,
          icon: Icon(Icons.call_end),
          color: Colors.red,
          iconSize: 32.0,
        ), // IconButton
      ]; // <Widget>[]
    } else {
      return [
        IconButton(
          onPressed: onReconnect!,
          icon: Icon(Icons.refresh),
          color: Colors.red,
          iconSize: 32.0,
        ),
      ];
    }
  }
}
