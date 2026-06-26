import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// MODEL: Hasil Input Report Defect Final Assy
// ─────────────────────────────────────────
class FinalAssyReportResult {
  final String tanggal;
  final int shift;
  final String line;
  final String jenisDefect;
  final String subDefect;
  final int jumlah;

  const FinalAssyReportResult({
    required this.tanggal,
    required this.shift,
    required this.line,
    required this.jenisDefect,
    required this.subDefect,
    required this.jumlah,
  });
}

// ─────────────────────────────────────────
// PAGE: Report Defect Final Assy (2 Langkah)
// ─────────────────────────────────────────
class ReportDefectFinalAssyPage extends StatefulWidget {
  final int shift;

  const ReportDefectFinalAssyPage({super.key, required this.shift});

  @override
  State<ReportDefectFinalAssyPage> createState() =>
      _ReportDefectFinalAssyPageState();
}

class _ReportDefectFinalAssyPageState
    extends State<ReportDefectFinalAssyPage> {
  static const Color yazakiRed   = Color(0xFFB71C1C);
  static const Color borderColor = Color(0xFFDDDDDD);

  int _step = 0; // 0 = Informasi Dasar, 1 = Konfirmasi

  // ── Data master (silakan disesuaikan dengan data real Final Assy) ──
  final List<String> _lineOptions = const [
    'Line 01',
    'Line 02',
    'Line 03',
    'Line 04',
  ];

  final Map<String, List<String>> _defectMap = const {
    'INSER CIRCUIT': ['1.A - CROSS CIRCUIT', '1.B - CIRCUIT NOT INSERT', '1.C - WRONG INSERT CIRCUIT', '1.D - WRONG CAVITY', '1.E - MISSING CIRCUIT', '1.F - TPO'],
    'DAMAGE/DEFORM/BROKEN PART': ['2.A - DAMAGE CLIP', '2.B - DAMAGE CONNECTOR', '2.C - DAMAGE GROMMET', '2.D - DAMAGE / SCRATCH INSULATION', '2.E - DAMAGE PROTECTOR', '2.F - DAMAGE SPACER', '2.G - DAMAGE TUBE', '2.H - DAMAGE BOLT / TORQUE', '2.I - DAMAGE R/B', '2.J - DAMAGE FUSE', '2.K - DAMAGE RELAY ', '2.L - DAMAGE N/P', '2.M - DAMAGE COVER', '2.N - DAMAGE SEAL RUBBER', '2.O - DAMAGE BRACKET CONNECTOR', '2.P - DAMAGE WASHER HOSE','2.Q - CUT WIRE', '2.R - DAMAGE USB', '2.S - BENT TERMINAL','2.T - DEFORM TERMINAL','2.U - BROKEN TERMINAL', '2.V - FLARE TERMINAL'],
    'MISSING PART': ['3.A - MISSING CLIP', '3.B - MISSING COVER', '3.C - MISSING GREASE', '3.D - MISSING GROMMET', '3.E - MISSING PROTECTOR', '3.F - MISSING SEAL RUBBER', '3.G - MISSING SPACER', '3.H - MISSING SPOT TAPE', '3.I - MISSING FOAM TAPE', '3.J - MISSING TIE BACK', '3.K - MISSING TUBE', '3.L - MISSING JC / BUSSBAR', '3.M - MISSING PULLER', '3.N - MISSING PLUG', '3.O - MISSING FUSE', '3.P - MISSING RELAY', '3.Q - MISSING N/P', '3.R - MISSING MARKING / STAMP N/P', '3.S - MISSING SOLDER', '3.T - MISSING USB CABLE', '3.U - BRACKET CONNECTOR ', '3.V - WASHER HOSE'],
    'DIMENSON DEFECT': ['4.A - DIMENSION BRANCH', '4.B - DIMENSION TRUNK', '4.C - DIMENSION CLIP', '4.D - DIMENSION PROTECTOR', '4.E - DIMENSION GROMMET', '4.F - DIMENSION TUBE', '4.G - DIM.Y'],
    'HALF LOCK / INCOMPLETE DOCKING': ['5.A - HALF LOCK SPACER / RETAINER', '5.B - MISALIGN', '5.C - HALF LOCK DOCKING J/C', '5.D - HALF LOCK DOCKING LA TERMINAL', '5.E - HALF LOCK COVER R/B', '5.F - HALF LOCK PROTECTOR', '5.G - HALF LOCK INSERT FUSE', '5.H - HALF LOCK INSERT RELAY', '5.I - LOOSE TORQUE'],
    'WRONG PART': ['6.A - CRACK', '6.B - MISALIGN', '6.C - WRONG CIRCUIT', '6.D -  WRONG CLIP', '6.E - WRONG COVER', '6.F - WRONG TAPE', '6.G - WRONG GROMMET', '6.H - WRONG PROTECTOR', '6.I - WRONG SEAL RUBBER', '6.J - WRONG SPACER / HOLDER', '6.K - WRONG FOAM TAPE', '6.L - WRONG TUBE', '6.M - WRONG JC / BUSSBAR', '6.N - WRONG PLUG','6.O - WRONG FUSE','6.P - WRONG RELAY','6.Q - WRONG N/P'],
    'TAPING DEFECT': ['7.A - WRONG TAPING METHOD', '7.B - MISSING TAPING', '7.C - WRONG SPOT TAPE', '7.D - WRONG TIE BACK', '7.E - TAPING BENDERA'],
    'WRONG ORIENTATION PART': ['8.A - ORIENTASI CLIP', '8.B - ORIENTASI BRANCH', '8.C - ORIENTASI GROMMET', '8.D - ORIENTASI COVER CONN.', '8.E - ORIENTASI N/P', '8.F - ORIENTASI TIE BACK' ],
    'CUTTING - CRIMPING PRE ASSY DEFECT': ['9.A -  SALAH BENTUK REAR CRIMPING', '9.B - BUTHYL MELELEH', '9.C - OVER MELT SHRINK TUBE', '9.D - SOLDER N-OK', '9.E - RAYCHAM N-OK', '9.F - BONDER LEPAS', '9.G - OVER CIRCUIT BONDER', '9.H - MISSING CIRCUIT BONDER', '9.I - SALAH CIRCUIT BONDER', '9.J - SALAH KIND WIRE ', '9.K - SALAH SIZE WIRE', '9.L - INSULATION MUNDUR', '9.M - SEAL RUBBER MUNDUR', '9.N - FRAYING CORE', '9.O - CRACK TERMINAL' ],
    'INJECTION GROMMET / SISUI DEFECT': ['10.A - INJECTION GROMMET BERGELEMBUNG', '10.B - INJECTION GROMMET KURANG', '10.C - INJECTION GROMMET TDK MATANG', '10.D - SISUI BOCOR'],
    'OTHERS': ['11.A - FOREIGN MATERIAL', '11.B - CIRCUIT TERJEPIT', '11.C - AIR CHECKER N-OK', '11.D - BAND CLIP KEPENDEKAN', '11.E - BAND CLIP PANJANG'],
  };

  // ── State form ──
  String? _selectedLine;
  String? _selectedDefect;
  String? _selectedSubDefect;
  DateTime _tanggalTemuan = DateTime.now();
  final TextEditingController _qtyController =
      TextEditingController(text: '0');

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  List<String> get _subDefectOptions =>
      _selectedDefect == null ? [] : (_defectMap[_selectedDefect] ?? []);

  String _formatTanggal(DateTime d) {
    return '${d.month.toString().padLeft(2, '0')}/'
        '${d.day.toString().padLeft(2, '0')}/${d.year}';
  }

  String _formatTanggalPanjang(DateTime d) {
    const bulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
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

  bool get _isFormValid =>
      _selectedLine != null &&
      _selectedDefect != null &&
      _selectedSubDefect != null &&
      (int.tryParse(_qtyController.text) ?? 0) > 0;

  void _goToConfirmation() {
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
    setState(() => _step = 1);
  }

  void _kirimLaporan() {
    final result = FinalAssyReportResult(
      tanggal: _formatTanggalPanjang(_tanggalTemuan),
      shift: widget.shift,
      line: _selectedLine!,
      jenisDefect: _selectedDefect!,
      subDefect: _selectedSubDefect!,
      jumlah: int.tryParse(_qtyController.text) ?? 0,
    );
    Navigator.pop(context, result);
  }

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
            Expanded(
              child: _step == 0 ? _buildStepInput() : _buildStepConfirmation(),
            ),
          ],
        ),
      ),
    );
  }

  // ── App Bar dengan tombol back ──
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_step == 1) {
                setState(() => _step = 0);
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back, color: yazakiRed),
          ),
          const Text(
            'Report Defect Final Assy',
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

  // ─────────────────────────────────────────
  // LANGKAH 1 — Informasi Dasar (Gambar 1)
  // ─────────────────────────────────────────
  Widget _buildStepInput() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Step indicator ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Langkah 1 dari 2',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              Text(
                'Informasi Dasar',
                style: TextStyle(
                    fontSize: 13, color: yazakiRed, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: yazakiRed,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD9D9),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildLabel('LINE / CONVEYOR'),
          _buildDropdown<String>(
            value: _selectedLine,
            hint: 'Pilih Area...',
            items: _lineOptions,
            onChanged: (v) => setState(() => _selectedLine = v),
          ),
          const SizedBox(height: 18),

          _buildLabel('TANGGAL TEMUAN'),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

          _buildLabel('JENIS SUB-DEFECT'),
          _buildDropdown<String>(
            value: _selectedSubDefect,
            hint: 'Pilih Sub-Defect',
            items: _subDefectOptions,
            onChanged: (v) => setState(() => _selectedSubDefect = v),
          ),
          const SizedBox(height: 18),

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
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _goToConfirmation,
              style: ElevatedButton.styleFrom(
                backgroundColor: yazakiRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('LANJUT KE KONFIRMASI',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Dot indicator ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: const BoxDecoration(color: yazakiRed, shape: BoxShape.circle),
              ),
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: const BoxDecoration(
                    color: Color(0xFFFFD9D9), shape: BoxShape.circle),
              ),
            ],
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
            letterSpacing: 0.4),
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
          hint: Text(hint, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString(),
                        style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // LANGKAH 2 — Konfirmasi (Gambar 2)
  // ─────────────────────────────────────────
  Widget _buildStepConfirmation() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Detail Laporan Defect',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: yazakiRed)),
                    Icon(Icons.assignment_outlined, color: yazakiRed, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailField(
                          'TANGGAL', _formatTanggalPanjang(_tanggalTemuan)),
                    ),
                    Expanded(
                      child: _buildDetailField('SHIFT', '${widget.shift}',
                          alignEnd: true),
                    ),
                  ],
                ),
                const Divider(height: 24, color: borderColor),
                _buildDetailField('LINE / CONVEYOR', _selectedLine ?? '-'),
                const SizedBox(height: 14),
                _buildDetailField('JENIS DEFECT', _selectedDefect ?? '-'),
                const SizedBox(height: 14),
                _buildDetailField('JENIS SUB-DEFECT', _selectedSubDefect ?? '-'),
                const Divider(height: 24, color: borderColor),
                _buildDetailField('JUMLAH / QUANTITY', _qtyController.text),
              ],
            ),
          ),
          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pastikan semua data di atas sudah benar sebelum mengirimkan '
                    'laporan ke tim pemeliharaan.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _kirimLaporan,
              style: ElevatedButton.styleFrom(
                backgroundColor: yazakiRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('KIRIM LAPORAN',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  SizedBox(width: 8),
                  Icon(Icons.send_rounded, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => setState(() => _step = 0),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: borderColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('KEMBALI KE INPUT',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 0.4)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black)),
      ],
    );
  }
}