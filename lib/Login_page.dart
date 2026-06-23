import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedShift = '';
  bool _obscurePassword = true;

  static const Color _primaryColor = Color(0xFF534AB7);
  static const Color _primaryLight = Color(0xFFEEEDFE);

  @override
  void dispose() {
    _namaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _doLogin() {
    final nama = _namaController.text.trim();
    final password = _passwordController.text;

    if (nama.isEmpty) {
      _showSnackBar('Nama karyawan wajib diisi', isError: true);
      return;
    }
    if (_selectedShift.isEmpty) {
      _showSnackBar('Pilih shift terlebih dahulu', isError: true);
      return;
    }
    if (password.isEmpty) {
      _showSnackBar('Password wajib diisi', isError: true);
      return;
    }

    if (nama == 'admin' && password == '12345') {
      _showSnackBar('Login berhasil — Selamat bekerja!');
    } else {
      _showSnackBar('Nama atau password tidak sesuai', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFD85A30) : const Color(0xFF1D9E75),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _primaryColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.factory_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Masuk ke sistem',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Silakan isi data untuk melanjutkan',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B6B80),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Field Nama
                    _buildLabel('Nama karyawan'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _namaController,
                      hint: 'Masukkan nama Anda',
                      prefixIcon: Icons.person_outline,
                    ),

                    const SizedBox(height: 20),

                    // Shift
                    _buildLabel('Pilih shift'),
                    const SizedBox(height: 8),
                    Row(
                      children: ['1', '2', '3'].map((shift) {
                        final isActive = _selectedShift == shift;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: shift != '3' ? 8 : 0,
                            ),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedShift = shift),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isActive ? _primaryColor : const Color(0xFFF5F4F8),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isActive
                                        ? _primaryColor
                                        : Colors.black.withOpacity(0.12),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Shift $shift',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isActive ? Colors.white : const Color(0xFF6B6B80),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (_selectedShift.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Shift $_selectedShift dipilih',
                          style: const TextStyle(
                            fontSize: 11,
                            color: _primaryColor,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Password
                    _buildLabel('Password'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Masukkan password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                          color: const Color(0xFF6B6B80),
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Tombol login
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _doLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.login, size: 18),
                        label: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Divider(height: 1, color: Color(0x14000000)),

                    const SizedBox(height: 14),

                    const Center(
                      child: Text(
                        'Hubungi admin jika mengalami kendala login',
                        style: TextStyle(fontSize: 12, color: Color(0xFF9999AA)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF6B6B80),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B0C0), fontSize: 14),
        prefixIcon: Icon(prefixIcon, size: 18, color: const Color(0xFF9999AA)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF5F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x1F000000)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x1F000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF534AB7), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
    );
  }
}