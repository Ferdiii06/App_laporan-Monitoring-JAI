import 'package:flutter/material.dart';
import '/features/Report_defect_pre_assy_page.dart';

// ─────────────────────────────────────────
// PAGE: Edit Report Defect Pre Assy
// ─────────────────────────────────────────
class EditReportDefectPreAssyPage extends StatefulWidget {
  final String initialLine;
  final String initialTanggal; // format: "dd Bulan yyyy" misal "25 Juni 2026"
  final String initialJenisDefect;
  final String initialSubDefect;
  final int initialJumlah;
  final int shift;

  const EditReportDefectPreAssyPage({
    super.key,
    required this.initialLine,
    required this.initialTanggal,
    required this.initialJenisDefect,
    required this.initialSubDefect,
    required this.initialJumlah,
    required this.shift,
  });

  @override
  State<EditReportDefectPreAssyPage> createState() =>
      _EditReportDefectPreAssyPageState();
}

class _EditReportDefectPreAssyPageState
    extends State<EditReportDefectPreAssyPage> {
  static const Color yazakiRed = Color(0xFFB71C1C);
  static const Color borderColor = Color(0xFFDDDDDD);

  // ── Data master ──
  final List<String> _lineOptions = const [
    'Line 01',
    'Line 02',
    'Line 03',
    'Line 04',
  ];

  final Map<String, List<String>> _defectMap = const {
    'Core': ['1.A - FRAYING', '1.B - SCRATCH', '1.C - BROKEN'],
    'Insert Circuit': ['1.A - CROSS CIRCUIT', '1.B - SHORT CIRCUIT'],
    'Connector': ['1.A - DAMAGE', '1.B - DEFORM'],
    'Terminal': ['1.A - BENT', '1.B - MISSING'],
  };

  // ── State form ──
  late String? _selectedLine;
  late String? _selectedDefect;
  late String? _selectedSubDefect;
  late DateTime _tanggalTemuan;
  late TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();

    // Pre-fill dengan data yang sudah ada
    _selectedLine = _lineOptions.contains(widget.initialLine)
        ? widget.initialLine
        : null;
    _selectedDefect = _defectMap.containsKey(widget.initialJenisDefect)
        ? widget.initialJenisDefect
        : null;
    _selectedSubDefect = _selectedDefect != null &&
            (_defectMap[_selectedDefect]?.contains(widget.initialSubDefect) ??
                false)
        ? widget.initialSubDefect
        : null;
    _tanggalTemuan = _parseTanggal(widget.initialTanggal);
    _qtyController =
        TextEditingController(text: widget.initialJumlah.toString());
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  // Parse "25 Juni 2026" → DateTime
  DateTime _parseTanggal(String tanggal) {
    const bulanMap = {
      'Januari': 1, 'Februari': 2, 'Maret': 3, 'April': 4,
      'Mei': 5, 'Juni': 6, 'Juli': 7, 'Agustus': 8,
      'September': 9, 'Oktober': 10, 'November': 11, 'Desember': 12,
    };
    try {
      final parts = tanggal.trim().split(' ');
      final day = int.parse(parts[0]);
      final month = bulanMap[parts[1]] ?? 1;
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return DateTime.now();
    }
  }

  String _formatTanggal(DateTime d) {
    return '${d.month.toString().padLeft(2, '0')}/'
        '${d.day.toString().padLeft(2, '0')}/${d.year}';
  }

  String _formatTanggalPanjang(DateTime d) {
    const bulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalTemuan,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: yazakiRed),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _tanggalTemuan = picked);
  }

  List<String> get _subDefectOptions =>
      _selectedDefect == null ? [] : (_defectMap[_selectedDefect] ?? []);

  bool get _isFormValid =>
      _selectedLine != null &&
      _selectedDefect != null &&
      _selectedSubDefect != null &&
      (int.tryParse(_qtyController.text) ?? 0) > 0;

  void _simpanPerubahan() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mohon lengkapi semua data terlebih dahulu.'),
          backgroundColor: yazakiRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final result = DefectReportResult(
      tanggal: _formatTanggalPanjang(_tanggalTemuan),
      shift: widget.shift,
      line: _selectedLine!,
      jenisDefect: _selectedDefect!,
      subDefect: _selectedSubDefect!,
      jumlah: int.tryParse(_qtyController.text) ?? 0,
    );
    Navigator.pop(context, result);
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Expanded(child: _buildForm()),
          ],
        ),
      ),
    );
  }

  // ── App Bar ──
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: yazakiRed),
          ),
          const Text(
            'Edit Report Defect Pre Assy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: yazakiRed,
            ),
          ),
        ],
      ),
    );
  }

  // ── Form ──
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Badge Status ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFFFCCCC)),
            ),
            child: const Text(
              'STATUS: SEDANG DIEDIT',
              style: TextStyle(
                fontSize: 11,
                color: yazakiRed,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── LINE / CONVEYOR ──
          _buildLabel('LINE / CONVEYOR'),
          _buildDropdown<String>(
            value: _selectedLine,
            hint: 'Pilih Area...',
            items: _lineOptions,
            onChanged: (v) => setState(() => _selectedLine = v),
          ),
          const SizedBox(height: 18),

          // ── TANGGAL TEMUAN ──
          _buildLabel('TANGGAL TEMUAN'),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatTanggal(_tanggalTemuan),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const Icon(Icons.calendar_today_outlined,
                      size: 18, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── JENIS DEFECT ──
          _buildLabel('JENIS DEFECT'),
          _buildDropdown<String>(
            value: _selectedDefect,
            hint: 'Pilih Jenis Defect',
            items: _defectMap.keys.toList(),
            onChanged: (v) => setState(() {
              _selectedDefect = v;
              _selectedSubDefect = null;
            }),
          ),
          const SizedBox(height: 18),

          // ── JENIS SUB-DEFECT ──
          _buildLabel('JENIS SUB-DEFECT'),
          _buildDropdown<String>(
            value: _selectedSubDefect,
            hint: 'Pilih Sub-Defect',
            items: _subDefectOptions,
            onChanged: (v) => setState(() => _selectedSubDefect = v),
          ),
          const SizedBox(height: 18),

          // ── JUMLAH ──
          _buildLabel('JUMLAH (QUANTITY)'),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ── Tombol Simpan ──
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _simpanPerubahan,
              icon: const Icon(Icons.save_rounded, color: Colors.white, size: 20),
              label: const Text(
                'Simpan Perubahan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: yazakiRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black54,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint:
              Text(hint, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString(),
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}