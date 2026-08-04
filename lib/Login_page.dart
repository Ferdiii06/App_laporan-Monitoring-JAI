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
  String _selectedShift = '1A';
  bool _isLoading    = false; // ← tambahan untuk loading state

  static const Color yazakiRed  = Color(0xFFB71C1C);
  static const Color borderColor = Color(0xFFCCCCCC);
  static const Color labelRed   = Color(0xFFCC0000);

  // ⚠️ Ganti dengan IP laptop jaringan apapun biar bisa diakses sesama IP (cek via ipconfig di Windows)
  // Contoh: 'http://192.168.1.10:8000/api'
  static const String _baseUrl = 'http://192.168.230.28:8001/api';

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
            final shiftData = data['shift'] as String;

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
      // Agar konten tidak terangkat saat keyboard muncul — field PIN numerik
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenH = constraints.maxHeight;
            // Ukuran adaptif berdasarkan tinggi layar
            final logoH     = screenH * 0.38;   // 38% tinggi layar
            final vPadTop   = screenH * 0.02;
            final vGapLg    = screenH * 0.015;
            final vGapSm    = screenH * 0.010;
            final fieldH    = screenH * 0.068;
            final btnH      = screenH * 0.068;
            final shiftH    = screenH * 0.065;
            final fontSize  = screenH < 600 ? 11.0 : 13.0;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: vPadTop),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Logo YAZAKI ──
                  Center(
                    child: Image.asset(
                      'assets/images/yazaki-logo.jpg',
                      height: logoH,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: vGapLg),

                  // ── Label Nama Lengkap ──
                  Text(
                    'Nama Lengkap',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: labelRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: vGapSm),

                  // ── Field Nama Lengkap ──
                  SizedBox(
                    height: fieldH,
                    child: TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                        fontFamily: 'intern',
                        fontSize: fontSize,
                        letterSpacing: 1.2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Masukan Nama Lengkap',
                        hintStyle: TextStyle(
                          fontFamily: 'intern',
                          fontSize: fontSize - 1,
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(Icons.person_outline, color: Colors.grey, size: 18),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: yazakiRed, width: 1.5)),
                      ),
                    ),
                  ),

                  SizedBox(height: vGapLg),

                  // ── Label Shift ──
                  Text(
                    'Pilih Shift',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: labelRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: vGapSm),

                  // ── Tombol Shift 4 pilihan (Row 2x2) ──
                  Row(
                    children: [
                      _buildShiftBtn('1A', shiftH),
                      const SizedBox(width: 8),
                      _buildShiftBtn('1B', shiftH),
                      const SizedBox(width: 8),
                      _buildShiftBtn('2A', shiftH),
                      const SizedBox(width: 8),
                      _buildShiftBtn('2B', shiftH),
                    ],
                  ),

                  SizedBox(height: vGapLg),

                  // ── Label PIN ──
                  Text(
                    'PIN (6 Digit)',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: labelRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: vGapSm),

                  // ── Field PIN ──
                  SizedBox(
                    height: fieldH,
                    child: TextField(
                      controller: _pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      obscuringCharacter: '•',
                      style: const TextStyle(fontSize: 18, letterSpacing: 6),
                      decoration: InputDecoration(
                        hintText: '••••••',
                        counterText: '',
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 18),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: yazakiRed, width: 1.5)),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ── Tombol Masuk ke Sistem ──
                  SizedBox(
                    width: double.infinity,
                    height: btnH,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _login,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                      label: Text(
                        _isLoading ? 'Memproses...' : 'Masuk ke Sistem',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize + 1,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yazakiRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        elevation: 0,
                      ),
                    ),
                  ),

                  SizedBox(height: vGapSm),
                  Center(
                  ),
                  SizedBox(height: vGapSm),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShiftBtn(String shift, double height) {
    final isSelected = _selectedShift == shift;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedShift = shift),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: isSelected ? yazakiRed : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? yazakiRed : borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              shift,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
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