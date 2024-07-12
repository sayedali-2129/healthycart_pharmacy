import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class NetworkTimeService{


Future<DateTime> getNetworkTime() async {
  try {
    var url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Kolkata');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      //datetime: 2024-04-19T15:58:12.048985+05:30
//       [log] datetime: 2024-04-19 10:29:07.527891Z  fake time
// [log] 2024-04-19 15:59:07.290698 real time
      var dateTime = DateTime.parse(body['datetime']);

      return dateTime.toLocal();
    }
  } catch (e) {
    log('Failed to get network time: $e');
  }
  log('error');
  return DateTime.now();
}

Future<String> getFormattedNetworkTime() async {
  try {
    var url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Kolkata');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var dateTime = DateTime.parse(body['datetime']);

      // Format the datetime to 'yyyy-MM-dd'
      final dateFormat = DateFormat('yyyy-MM-dd');
      final formattedDate = dateFormat.format(dateTime.toLocal());

      return formattedDate;
    }
  } catch (e) {
    log('Failed to get network time: $e');
  }
  log('error');
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}









}