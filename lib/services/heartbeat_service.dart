import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HeartbeatService {
  static Timer? _timer;
  static const String _heartbeatUrl = 'http://10.49.236.139:8000/api/heartbeat';

  static Future<void> sendHeartbeat(String nama) async {
    try {
      final response = await http.post(
        Uri.parse(_heartbeatUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nama': nama}),
      );
      print('Heartbeat status: ${response.statusCode}');
    } catch (e) {
      print('Heartbeat gagal: $e');
    }
  }

  static void startPeriodicHeartbeat(String nama) {
    sendHeartbeat(nama);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      sendHeartbeat(nama);
    });
  }

  static void stopHeartbeat() {
    _timer?.cancel();
    _timer = null;
  }

  static Future<void> sendLogout(String nama) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.49.236.139:8000/api/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nama': nama}),
      );
      print('Logout status: ${response.statusCode}');
    } catch (e) {
      print('Logout gagal: $e');
    }
  }
}
