import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Login_page.dart';
import 'features/Report_defect_pre_assy_page.dart';
import 'features/Report_defect_final_assy_page.dart';
import 'features/edit/Edit_report_defect_final_assy_page.dart';
import 'features/edit/Edit_report_defect_pre_assy_page.dart';
import '../services/heartbeat_service.dart';

// ─────────────────────────────────────────
// MODEL: Data Report
// ─────────────────────────────────────────
class ReportItem {
  final int? id;
  final String date;
  final String type;
  final String line;
  final String jenisMobil;
  final String conveyor;
  final String defect;
  final int jumlah;
  final String subDefect;

  const ReportItem({
    this.id,
    required this.date,
    required this.type,
    required this.line,
    required this.jenisMobil,
    required this.conveyor,
    required this.defect,
    required this.jumlah,
    required this.subDefect,
  });
}

// ─────────────────────────────────────────
// PAGE: Dashboard
// ─────────────────────────────────────────
class DashboardPage extends StatefulWidget {
  final String userName;
  final int shift;

  const DashboardPage({
    super.key,
    required this.userName,
    required this.shift,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const Color yazakiRed = Color(0xFFB71C1C);
  static const Color borderColor = Color(0xFFDDDDDD);

  // ── Static Map untuk menampung riwayat defect per user ──
  static final Map<String, List<ReportItem>> _userReports = {};

  late List<ReportItem> _reports = [];
  bool _isLoading = false;
  static const String _baseUrl = 'http://192.168.1.58:8000/api';

  @override
  void initState() {
    super.initState();
    _reports = [];
    _fetchReports();
    HeartbeatService.startPeriodicHeartbeat(widget.userName);
  }

  @override
  void dispose() {
    HeartbeatService.stopHeartbeat();
    super.dispose();
  }

  // ✅ UPDATED: hanya fetch laporan milik user yang sedang login
  Future<void> _fetchReports() async {
    setState(() => _isLoading = true);
    try {
      final uri = Uri.parse('$_baseUrl/reports').replace(queryParameters: {
        'nama_user': widget.userName,
      });
      print('🔵 Fetching reports from $uri');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          final List<dynamic> data = body['data'];
          setState(() {
            _reports = data.map((json) => ReportItem(
              id: json['id'],
              date: json['tanggal'] ?? '',
              type: json['type'] ?? '',
              line: json['line'] ?? '',
              jenisMobil: json['jenis_mobil'] ?? '',
              conveyor: json['conveyor'] ?? '',
              defect: json['jenis_defect'] ?? '',
              jumlah: json['jumlah'] ?? 0,
              subDefect: json['sub_defect'] ?? '',
            )).toList();
          });
        }
      }
    } catch (e) {
      print('🔴 Error fetching reports: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ✅ UPDATED: kirim nama_user di body agar backend bisa cek kepemilikan
  Future<void> _deleteReportFromApi(int reportId, int index) async {
    setState(() => _isLoading = true);
    try {
      print('🔵 Deleting report: $reportId');
      final request = http.Request('DELETE', Uri.parse('$_baseUrl/reports/$reportId'));
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({'nama_user': widget.userName});

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _reports.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Laporan berhasil dihapus.'),
            backgroundColor: yazakiRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        );
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda tidak memiliki izin menghapus laporan ini.')),
        );
      } else {
        print('🔴 Server delete failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus laporan di server.')),
        );
      }
    } catch (e) {
      print('🔴 Error deleting report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi bermasalah.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ─────────────────────────────────────────
  // DIALOG HAPUS
  // ─────────────────────────────────────────
  void _deleteReport(int index) {
    final report = _reports[index];
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: yazakiRed,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hapus Laporan?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Apakah yakin ingin menghapus data ini?\nTindakan ini tidak dapat dibatalkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: yazakiRed,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (report.id != null) {
                      _deleteReportFromApi(report.id!, index);
                    } else {
                      setState(() {
                        _reports.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Laporan berhasil dihapus.'),
                          backgroundColor: yazakiRed,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yazakiRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // DIALOG LOGOUT
  // ─────────────────────────────────────────
  void _logout() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: yazakiRed,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Keluar dari Sistem?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Apakah Anda yakin ingin keluar\ndari sistem ini?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: yazakiRed,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    HeartbeatService.stopHeartbeat();
                    await HeartbeatService.sendLogout(widget.userName);
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yazakiRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editReport(int index) async {
    final report = _reports[index];
    final tanggalForEdit = _parseDateLabel(report.date);

    if (report.type == 'Pre Assy') {
      final result = await Navigator.push<DefectReportResult>(
        context,
        MaterialPageRoute(
          builder: (_) => EditReportDefectPreAssyPage(
            initialTanggal: tanggalForEdit,
            initialJenisMobil: report.jenisMobil,
            initialConveyor: report.conveyor,
            initialJenisDefect: report.defect,
            initialSubDefect: report.subDefect,
            initialJumlah: report.jumlah,
            shift: widget.shift,
          ),
        ),
      );
      if (result != null && mounted) {
        await _updateReportToApi(report.id, index, result.tanggal.toUpperCase(), 'Pre Assy', result);
      }
      return;
    }

    if (report.type == 'Final Assy') {
      final result = await Navigator.push<FinalAssyReportResult>(
        context,
        MaterialPageRoute(
          builder: (_) => EditReportDefectFinalAssyPage(
            initialTanggal: tanggalForEdit,
            initialJenisMobil: report.jenisMobil,
            initialConveyor: report.conveyor,
            initialJenisDefect: report.defect,
            initialSubDefect: report.subDefect,
            initialJumlah: report.jumlah,
            shift: widget.shift,
          ),
        ),
      );
      if (result != null && mounted) {
        await _updateReportToApi(report.id, index, result.tanggal.toUpperCase(), 'Final Assy', result);
      }
      return;
    }
  }

  // ✅ UPDATED: kirim nama_user di body agar backend bisa cek kepemilikan
  Future<void> _updateReportToApi(
    int? reportId,
    int index,
    String tanggal,
    String type,
    dynamic result,
  ) async {
    setState(() => _isLoading = true);
    try {
      if (reportId != null) {
        print('🔵 Updating report: $reportId');
        final response = await http.put(
          Uri.parse('$_baseUrl/reports/$reportId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nama_user': widget.userName,
            'tanggal': tanggal,
            'line': result.line,
            'jenis_mobil': result.jenisMobil,
            'conveyor': result.conveyor,
            'jenis_defect': result.jenisDefect,
            'sub_defect': result.subDefect,
            'jumlah': result.jumlah,
          }),
        );
        if (response.statusCode == 200) {
          // Reload dari server agar data sinkron
          await _fetchReports();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Laporan berhasil diperbarui.'),
                backgroundColor: yazakiRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            );
          }
        } else if (response.statusCode == 403) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Anda tidak memiliki izin mengubah laporan ini.')),
            );
          }
        } else {
          print('🔴 Server update failed: ${response.body}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal memperbarui laporan di server.')),
            );
          }
        }
      }
    } catch (e) {
      print('🔴 Error updating report: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Koneksi bermasalah saat update.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper: konversi label tanggal "25 JUNE 2026" → "25 Juni 2026"
  String _parseDateLabel(String dateLabel) {
    const englishToIndonesian = {
      'JANUARY': 'Januari',
      'FEBRUARY': 'Februari',
      'MARCH': 'Maret',
      'APRIL': 'April',
      'MAY': 'Mei',
      'JUNE': 'Juni',
      'JULY': 'Juli',
      'AUGUST': 'Agustus',
      'SEPTEMBER': 'September',
      'OCTOBER': 'Oktober',
      'NOVEMBER': 'November',
      'DECEMBER': 'Desember',
      'JANUARI': 'Januari',
      'FEBRUARI': 'Februari',
      'MARET': 'Maret',
      'MEI': 'Mei',
      'AGUSTUS': 'Agustus',
      'JULI': 'Juli',
      'OKTOBER': 'Oktober',
    };
    final parts = dateLabel.trim().split(' ');
    if (parts.length < 3) return dateLabel;
    final day = parts[0];
    final month = englishToIndonesian[parts[1].toUpperCase()] ?? parts[1];
    final year = parts[2];
    return '$day $month $year';
  }

  void _navigateToInput(String type) async {
    if (type == 'Pre Assy') {
      final result = await Navigator.push<DefectReportResult>(
        context,
        MaterialPageRoute(
          builder: (_) => ReportDefectPreAssyPage(shift: widget.shift),
        ),
      );
      if (result != null) {
        await _postReportToApi(
          tanggal: result.tanggal,
          type: 'Pre Assy',
          line: result.line,
          jenisMobil: result.jenisMobil,
          conveyor: result.conveyor,
          jenisDefect: result.jenisDefect,
          subDefect: result.subDefect,
          jumlah: result.jumlah,
        );
      }
      return;
    }

    if (type == 'Final Assy') {
      final result = await Navigator.push<FinalAssyReportResult>(
        context,
        MaterialPageRoute(
          builder: (_) => ReportDefectFinalAssyPage(shift: widget.shift),
        ),
      );
      if (result != null) {
        await _postReportToApi(
          tanggal: result.tanggal,
          type: 'Final Assy',
          line: result.line,
          jenisMobil: result.jenisMobil,
          conveyor: result.conveyor,
          jenisDefect: result.jenisDefect,
          subDefect: result.subDefect,
          jumlah: result.jumlah,
        );
      }
      return;
    }
  }

  Future<void> _postReportToApi({
    required String tanggal,
    required String type,
    required String line,
    required String jenisMobil,
    required String conveyor,
    required String jenisDefect,
    required String subDefect,
    required int jumlah,
  }) async {
    setState(() => _isLoading = true);
    try {
      print('🔵 Posting report to $_baseUrl/reports');
      final response = await http.post(
        Uri.parse('$_baseUrl/reports'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_user': widget.userName,
          'shift': widget.shift,
          'tanggal': tanggal,
          'type': type,
          'line': line,
          'jenis_mobil': jenisMobil,
          'conveyor': conveyor,
          'jenis_defect': jenisDefect,
          'sub_defect': subDefect,
          'jumlah': jumlah,
        }),
      );
      if (response.statusCode == 200) {
        print('🟢 Report posted successfully');
        // Reload dari server agar data sinkron dengan dashboard
        await _fetchReports();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Laporan defect berhasil dikirim ke server!'),
              backgroundColor: yazakiRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      } else {
        print('🔴 Server post failed: ${response.body}');
        final errBody = jsonDecode(response.body);
        final msg = errBody['message'] ?? 'Gagal mengirim laporan.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        }
      }
    } catch (e) {
      print('🔴 Error posting report: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat terhubung ke server.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _logout();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── App Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: yazakiRed,
                      ),
                    ),
                    GestureDetector(
                      onTap: _logout,
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Colors.black87,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // ── Badge Shift ──
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: const Color(0xFFFFCCCC)),
                        ),
                        child: Text(
                          'Shift ${widget.shift} aktif',
                          style: const TextStyle(
                            fontSize: 12,
                            color: yazakiRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Tombol Input Report ──
                      Row(
                        children: [
                          Expanded(
                            child: _InputReportButton(
                              label: 'Input Report\nFinal Assy',
                              onTap: () => _navigateToInput('Final Assy'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InputReportButton(
                              label: 'Input Report\nPre Assy',
                              onTap: () => _navigateToInput('Pre Assy'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'Riwayat Report',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: CircularProgressIndicator(
                              color: Color(0xFFB71C1C),
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      else if (_reports.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                const Icon(Icons.inbox_outlined,
                                    size: 48, color: Colors.grey),
                                const SizedBox(height: 8),
                                const Text(
                                  'Belum ada riwayat report.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                                TextButton.icon(
                                  onPressed: _fetchReports,
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('Muat ulang'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFFB71C1C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _reports.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final report = _reports[index];
                            return _ReportCard(
                              report: report,
                              onEdit: () => _editReport(index),
                              onDelete: () => _deleteReport(index),
                            );
                          },
                        ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// WIDGET: Tombol Input Report
// ─────────────────────────────────────────
class _InputReportButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  static const Color yazakiRed = Color(0xFFB71C1C);

  const _InputReportButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: yazakiRed,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// WIDGET: Kartu Report (LENGKAP dengan Jenis Mobil & Conveyor)
// ─────────────────────────────────────────
class _ReportCard extends StatelessWidget {
  final ReportItem report;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const Color yazakiRed = Color(0xFFB71C1C);
  static const Color borderColor = Color(0xFFDDDDDD);

  const _ReportCard({
    required this.report,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Tanggal + Ikon Aksi ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.edit_outlined,
                            size: 18, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: yazakiRed,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.delete_outline,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── TYPE ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
            child: Text(
              report.type,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          const Divider(height: 1, color: borderColor),

          // ── JENIS MOBIL ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
            child: Row(
              children: const [
                Text(
                  'Jenis Mobil',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Text(
              report.jenisMobil,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          // ── CONVEYOR ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
            child: Row(
              children: const [
                Text(
                  'Conveyor',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Text(
              report.conveyor,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          const Divider(height: 1, color: borderColor),

          // ── Label Defect & Jumlah ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    'Defect',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                Text(
                  'Jumlah',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // ── Value Defect & Jumlah ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    report.defect,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${report.jumlah} Unit',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: borderColor),

          // ── Sub-Defect ──
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Text(
              'Sub-Defect',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Text(
              report.subDefect,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}