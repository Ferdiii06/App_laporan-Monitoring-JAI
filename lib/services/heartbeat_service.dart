import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HeartbeatService {
  static Timer? _timer;
  static const String _baseUrl = 'https://untie-mumble-sasquatch.ngrok-free.dev/api';

  static Future<void> sendHeartbeat(String nama) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/heartbeat'),
        headers: {'Content-Type': 'application/json', 'ngrok-skip-browser-warning': 'true', 'Bypass-Tunnel-Reminder': 'true'},
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
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
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
        Uri.parse('$_baseUrl/logout'),
        headers: {'Content-Type': 'application/json', 'ngrok-skip-browser-warning': 'true', 'Bypass-Tunnel-Reminder': 'true'},
        body: jsonEncode({'nama': nama}),
      );
      print('Logout status: ${response.statusCode}');
    } catch (e) {
      print('Logout gagal: $e');
    }
  }
}
