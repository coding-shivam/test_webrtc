import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_conferening_mobile/utils/user.utils.dart';

String MEETING_API_URL = "http://192.168.1.6:4000/api/meeting";
var client = http.Client();
Future<http.Response?> startMeeting() async {
  print(MEETING_API_URL);
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
  var userId = await loadUserId();
  print(userId);
  var response = await client.post(Uri.parse('$MEETING_API_URL/start'),
      headers: requestHeaders,
      body: jsonEncode({'hostId': userId, 'hostName': ''}));
  print(response.body);
  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response> joinMeeting(String meetingId) async {
  var response =
      await http.get(Uri.parse('$MEETING_API_URL/join?meetingId=$meetingId'));
  if (response.statusCode >= 200 && response.statusCode < 400) {
    print(response.body);
    return response;
  }
  throw UnsupportedError('Not a valid Meeting');
}
