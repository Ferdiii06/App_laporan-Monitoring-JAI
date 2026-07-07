import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pinController  = TextEditingController();
  int _selectedShift = 1;
  bool _isLoading    = false; // ← tambahan untuk loading state

  static const Color yazakiRed  = Color(0xFFB71C1C);
  static const Color borderColor = Color(0xFFCCCCCC);
  static const Color labelRed   = Color(0xFFCC0000);

  // ⚠️ Ganti dengan IP laptop jaringan apapun biar bisa diakses sesama IP (cek via ipconfig di Windows)
  // Contoh: 'http://192.168.1.10:8000/api'
  static const String _baseUrl = 'http://10.49.236.139:8000/api';

  @override
  void dispose() {
    _nameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  // FUNGSI LOGIN → hit API Laravel
  // ─────────────────────────────────────────
  Future<void> _login() async {
    final name = _nameController.text.trim();
    final pin = _pinController.text.trim();
    final shift = _selectedShift;

    // Validasi
    if (name.isEmpty) {
        _showError('Nama Lengkap tidak boleh kosong.');
        return;
    }
    if (pin.length < 6) {
        _showError('PIN harus 6 digit');
        return;
    }

    setState(() => _isLoading = true);

    try {
        final requestBody = {
            'nama': name,
            'pin': pin,
            'shift': shift, // ← KIRIM SHIFT
        };

        print('🔵 Sending to: $_baseUrl/login');
        print('🔵 Body: $requestBody');

        final response = await http.post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
        );

        final body = jsonDecode(response.body);
        print('🟢 Response: $body');

        if (response.statusCode == 200 && body['status'] == true) {
            final data = body['data'];
            final nama = data['nama'] as String;
            final shiftData = data['shift'] as int;

            if (!mounted) return;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => DashboardPage(
                        userName: nama,
                        shift: shiftData,
                    ),
                ),
            );
        } else {
            // Tampilkan pesan error dari server
            final message = body['message'] ?? 'Login gagal.';
            _showError(message);
        }
    } catch (e) {
        print('🔴 Error: $e');
        _showError('Tidak dapat terhubung ke server.');
    } finally {
        if (mounted) setState(() => _isLoading = false);
    }
}

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: yazakiRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // ── Logo YAZAKI ──
                Center(
                  child: Image.asset(
                    'assets/images/yazaki-logo.jpg',
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 30),

                // ── Label Nama Lengkap ──
                const Text(
                  'Nama Lengkap',
                  style: TextStyle(
                    fontSize: 13,
                    color: labelRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                // ── Field Nama Lengkap ──
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                    fontFamily: 'intern',
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Masukan Nama Lengkap',
                    hintStyle: const TextStyle(
                      fontFamily: 'intern',
                      fontSize: 13,
                      color: Colors.grey,
                      letterSpacing: 1.5,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                      size: 20,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: yazakiRed, width: 1.5),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Tombol Shift ──
                Row(
                  children: [
                    Expanded(
                      child: _ShiftButton(
                        label: 'Shift 1',
                        isSelected: _selectedShift == 1,
                        onTap: () => setState(() => _selectedShift = 1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ShiftButton(
                        label: 'Shift 2',
                        isSelected: _selectedShift == 2,
                        onTap: () => setState(() => _selectedShift = 2),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Label PIN ──
                const Text(
                  'PIN (6 Digit)',
                  style: TextStyle(
                    fontSize: 13,
                    color: labelRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                // ── Field PIN ──
                TextField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  obscuringCharacter: '•',
                  style: const TextStyle(fontSize: 18, letterSpacing: 6),
                  decoration: InputDecoration(
                    hintText: '••••••',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                      size: 20,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: yazakiRed, width: 1.5),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Tombol Masuk ke Sistem ──
                // Loading indicator muncul saat proses login, UI tidak berubah
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _login,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 20),
                    label: Text(
                      _isLoading ? 'Memproses...' : 'Masuk ke Sistem',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yazakiRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// WIDGET: Tombol Shift — tidak berubah
// ─────────────────────────────────────────
class _ShiftButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShiftButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB71C1C) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFB71C1C)
                : const Color(0xFFCCCCCC),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// PAINTER: Logo Segitiga Yazaki — tidak berubah
// ─────────────────────────────────────────
class _YazakiLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintRed  = Paint()..color = const Color(0xFFCC0000);
    final paintDark = Paint()..color = const Color(0xFF8B0000);

    final pathMain = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.55, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(pathMain, paintRed);

    final pathShadow = Path()
      ..moveTo(size.width * 0.38, size.height)
      ..lineTo(size.width * 0.55, size.height * 0.45)
      ..lineTo(size.width * 0.72, size.height)
      ..close();
    canvas.drawPath(pathShadow, paintDark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}