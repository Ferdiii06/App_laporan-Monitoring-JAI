import 'package:flutter/material.dart';
import 'Login_page.dart';
import 'features/Report_defect_pre_assy_page.dart';
import 'features/Report_defect_final_assy_page.dart';
import 'features/edit/Edit_report_defect_final_assy_page.dart';
import 'features/edit/Edit_report_defect_pre_assy_page.dart';


// ─────────────────────────────────────────
// MODEL: Data Report
// ─────────────────────────────────────────
class ReportItem {
  final String date;
  final String type;
  final String line;
  final String defect;
  final int jumlah;
  final String subDefect;

  const ReportItem({
    required this.date,
    required this.type,
    required this.line,
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
  static const Color yazakiRed   = Color(0xFFB71C1C);
  static const Color borderColor = Color(0xFFDDDDDD);

  late List<ReportItem> _reports;

  @override
  void initState() {
    super.initState();
    _reports = [
      const ReportItem(
        date: '23 JUNE 2026',
        type: 'Pre Assy',
        line: 'Line 01',
        defect: 'Core',
        jumlah: 5,
        subDefect: '1.A - FRAYING',
      ),
      const ReportItem(
        date: '23 JUNE 2026',
        type: 'Final Assy',
        line: 'Line 01',
        defect: 'Insert Circuit',
        jumlah: 5,
        subDefect: '1.A - CROSS CIRCUIT',
      ),
    ];
  }

  // ─────────────────────────────────────────
  // DIALOG HAPUS — style baru (gambar 1)
  // ─────────────────────────────────────────
  void _deleteReport(int index) {
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
              // ── Ikon tempat sampah dalam lingkaran merah muda ──
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

              // ── Judul ──
              const Text(
                'Hapus Laporan?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              // ── Pesan peringatan warna merah ──
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

              // ── Tombol HAPUS (merah penuh, lebar) ──
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _reports.removeAt(index));
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Laporan berhasil dihapus.'),
                        backgroundColor: yazakiRed,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    );
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

              // ── Tombol BATAL (outline, lebar) ──
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
  // DIALOG LOGOUT — style sama
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
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
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
            initialLine: report.line,
            initialTanggal: tanggalForEdit,
            initialJenisDefect: report.defect,
            initialSubDefect: report.subDefect,
            initialJumlah: report.jumlah,
            shift: widget.shift,
          ),
        ),
      );
      if (result != null && mounted) {
        setState(() {
          _reports[index] = ReportItem(
            date: result.tanggal.toUpperCase(),
            type: 'Pre Assy',
            line: result.line,
            defect: result.jenisDefect,
            jumlah: result.jumlah,
            subDefect: result.subDefect,
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Laporan berhasil diperbarui.'),
            backgroundColor: yazakiRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
      return;
    }

    if (report.type == 'Final Assy') {
      final result = await Navigator.push<FinalAssyReportResult>(
        context,
        MaterialPageRoute(
          builder: (_) => EditReportDefectFinalAssyPage(
            initialLine: report.line,
            initialTanggal: tanggalForEdit,
            initialJenisDefect: report.defect,
            initialSubDefect: report.subDefect,
            initialJumlah: report.jumlah,
            shift: widget.shift,
          ),
        ),
      );
      if (result != null && mounted) {
        setState(() {
          _reports[index] = ReportItem(
            date: result.tanggal.toUpperCase(),
            type: 'Final Assy',
            line: result.line,
            defect: result.jenisDefect,
            jumlah: result.jumlah,
            subDefect: result.subDefect,
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Laporan berhasil diperbarui.'),
            backgroundColor: yazakiRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
      return;
    }
  }

  // Helper: konversi label tanggal "25 JUNE 2026" → "25 Juni 2026"
  String _parseDateLabel(String dateLabel) {
    const englishToIndonesian = {
      'JANUARY': 'Januari', 'FEBRUARY': 'Februari', 'MARCH': 'Maret',
      'APRIL': 'April', 'MAY': 'Mei', 'JUNE': 'Juni',
      'JULY': 'Juli', 'AUGUST': 'Agustus', 'SEPTEMBER': 'September',
      'OCTOBER': 'Oktober', 'NOVEMBER': 'November', 'DECEMBER': 'Desember',
      // fallback jika sudah dalam bahasa Indonesia (uppercase)
      'JANUARI': 'Januari', 'FEBRUARI': 'Februari', 'MARET': 'Maret',
      'MEI': 'Mei', 'AGUSTUS': 'Agustus',
      'JULI': 'Juli', 'OKTOBER': 'Oktober',
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
      setState(() {
        _reports.insert(
          0,
          ReportItem(
            date: result.tanggal.toUpperCase(),
            type: 'Pre Assy',
            line: result.line,
            defect: result.jenisDefect,
            jumlah: result.jumlah,
            subDefect: result.subDefect,
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Laporan defect berhasil dikirim.'),
          backgroundColor: yazakiRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    return;
  }

  // Final Assy — navigasi ke ReportDefectFinalAssyPage
  if (type == 'Final Assy') {
    final result = await Navigator.push<FinalAssyReportResult>(
      context,
      MaterialPageRoute(
        builder: (_) => ReportDefectFinalAssyPage(shift: widget.shift),
      ),
    );

    if (result != null) {
      setState(() {
        _reports.insert(
          0,
          ReportItem(
            date: result.tanggal.toUpperCase(),
            type: 'Final Assy',
            line: result.line,
            defect: result.jenisDefect,
            jumlah: result.jumlah,
            subDefect: result.subDefect,
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Laporan defect berhasil dikirim.'),
          backgroundColor: yazakiRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    return;
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                          border: Border.all(color: const Color(0xFFFFCCCC)),
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

                      if (_reports.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(Icons.inbox_outlined,
                                    size: 48, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  'Belum ada riwayat report.',
                                  style: TextStyle(color: Colors.grey),
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
// WIDGET: Kartu Report
// ─────────────────────────────────────────
class _ReportCard extends StatelessWidget {
  final ReportItem report;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const Color yazakiRed   = Color(0xFFB71C1C);
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

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
            child: Text(
              report.type,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),

          const Divider(height: 1, color: borderColor),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Defect',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('Jumlah',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(report.defect,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                Text('${report.jumlah} Unit',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
              ],
            ),
          ),

          const Divider(height: 1, color: borderColor),

          const Padding(
            padding: EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Text('Sub-Defect',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Text(
              report.subDefect,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}