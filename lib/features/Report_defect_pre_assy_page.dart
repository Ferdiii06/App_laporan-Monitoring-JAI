import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

  // ─────────────────────────────────────────
  // MODEL: Hasil Input Report Defect Pre Assy
  // ─────────────────────────────────────────
  class DefectReportResult {
    final String tanggal;
    final String shift;
    final String line;
    final String jenisMobil;
    final String conveyor;
    final String jenisDefect;
    final String subDefect;
    final int jumlah;
    final String? noTerminal;
    final String? noMesin;

    const DefectReportResult({
      required this.tanggal,
      required this.shift,
      required this.line,
      required this.jenisMobil,
      required this.conveyor,
      required this.jenisDefect,
      required this.subDefect,
      required this.jumlah,
      this.noTerminal,
      this.noMesin,
    });
  }

  // ─────────────────────────────────────────
  // PAGE: Report Defect Pre Assy (2 Langkah)
  // ─────────────────────────────────────────
  class ReportDefectPreAssyPage extends StatefulWidget {
    final String shift;

    const ReportDefectPreAssyPage({super.key, required this.shift});

    @override
    State<ReportDefectPreAssyPage> createState() =>
        _ReportDefectPreAssyPageState();
  }

  class _ReportDefectPreAssyPageState extends State<ReportDefectPreAssyPage> {
    static const Color yazakiRed   = Color(0xFFB71C1C);
    static const Color borderColor = Color(0xFFDDDDDD);

    int _step = 0; // 0 = Informasi Dasar, 1 = Konfirmasi

    // ── Data master ──
    final Map<String, List<String>> _conveyorMap = const {
      'TOYOTA': [
        '664W-C5', '664W-C5C', '664W-C5A', '664W-C5B', '664W-C5D',
        '711W TNGA-C5', '711W TNGA-C5A', '737W TNGA-C5A', '737W TNGA-C5',
        '738W-C5C', '858W-C5C', '810W-C5', '941W-C5', '023J-C5', '072Y-C5',
        '718W-AB5.HEV', '718W-C4.CONV', '718W-C4.TNGA', '891W/892W-C1.GAS LHD',
        '853W-AT2.HEV LHD', '853W-AT6.GAS LHD', '853W-AT16.GAS LHD',
        '852W-AT19.HEV PHV LHD', '852W-AT2.HEV PHV LHD', '852W-AT19.HEV PHV RHD',
        '852W-AT6.GAS LHD', '909W-AT7.GAS LHD', '909W-AT11.HEV LHD',
        '909W-AT9.GAS LHD', '910W-AT7.GAS LHD', '910W-AT11.HEV LHD',
        '910W-AT9.GAS LHD', '953W-C6.HEV RHD', '953W-C6.HEV LHD',
        '953W ENG NO.3-C9', '898W-AB5.HEV', '898W-C4.CONV', '898W-C4.TNGA'
      ],
      'NISSAN': [
        'P33A-B1.BAT', 'P33A-B1.CELL', 'J32V-B2.LHD', 'J32V-B2.RHD',
        'J42U-B3.EGI', 'J42U-B3.ENGINE', 'J42U-B2.DOOR RH', 'J42U-B2.DOOR LH',
        'P33C-B1.BAT', 'P33C-B1.CELL'
      ],
      'MAZDA': [
        'J72A-12B.LHD', 'J72A-AB9.RHD', 'J72A-16C.LHD', 'J72K-16C.LHD',
        'J30A-AB6.EXTEND LHD', 'J30A-AB1.INPANEL LHD', 'J30A-AB6.EXTEND RHD', 'J30A-AB1.INPANEL RHD',
        'J69P-AB8.EXTEND LHD', 'J69P-AB8.INPANEL LHD', 'J69P-AB8.EXTEND RHD', 'J69P-AB8.INPANEL RHD',
        'J69P-AB9.EXTEND LHD', 'J69P-AB3.INPANEL LHD'
      ]
    };

    final Map<String, List<String>> _defectMap = const {
      'CORE': ['A.1 - FRAYING', 'A.2 - CUT CORE', 'A.3 - TIDAK TERATUR', 'A.4 - MAJU','A.5 - MUNDUR', 'A.6 - TIDAK TERCRIMPING', 'A.7 - SCRATCH'],
      'TERMINAL': ['B.1 - TERGORES', 'B.2 - BENT UP','B.3 - BENT DOWN', 'B.4 - MELINTIR', 'B.5 - UJUNG TERPOTONG', 'B.6 - OPEN/FLARE', 'B.7 - DEFORM', 'B.8 - BRIDGE TERLALU PANJANG', 'B.9 - CANTILEVER RUSAK', 'B.10 - LEPAS DARI CIRCUIT'],
      'FRONT CRIMPING': ['C.1 - C/H TERLALU TINGGI', 'C.2 - C/H TERLALU RENDAH','C.3 - C/W TERLALU TINGGI', 'C.4 - C/W TERLALU RENDAH',  'C.5 - FLASH'],
      'REAR  CRIMPING': ['D.1 - C/H - TERLALU TINGGI', 'D.2 - C/H TERLALU RENDAH', 'D.3 - C/W TERLALU TINGGI', 'D.4 - C/W TERLALU RENDAH', 'D.5 - ADA DI DALAM INSULASI', 'D.6 - TIDAK SEIMBANG'],
      'INSULATION': ['E.1 - TERCRIMPING', 'E.2 - TERLALU MUNDUR', 'E.3 - DAMAGE', 'E.4 - TIDAK RATA'],
      'SEAL SUMBER': ['F.1 - TERPOTONG', 'F.2 - TERBALIK', 'F.3 - TERLALU MUNDUR', 'F.4 - TERLALU MAJU', 'F.5 - TERCRIMPING', 'F.6 - MISSING', 'F.7 - SEAL SOBEK'],
      'CRIMPING': ['G.1 - FOREIGN MATERIAL', 'G.2 - ADB.1 TERMMINAL TERCIMPING', 'G.3 - NO CORE', 'G.4 - NO STRIPPING'],
      'LAIN-LAIN': ['H.1 - LANCE RUSAK', 'H.2 - STABILIZER RUSAK', 'H.3 - BELLMOUTH TIDAK STANDART', 'H.4 - KONDISI CORE BAG.A', 'H.5 - RESIN MASUK BAG.A', 'H.6 - RESIN BAREL BAG.B TERBUKA', 'H.7 - CORE TERLIHAT ATAS SISI C', 'H.8 - CORE TERLIHAT SAMPING SISI C', 'H.9 - SISI PUNGGUNG', 'H.10 - ABNORMAL RESIN', 'H.11 - PANJANG WELDING N-OK', 'H.12 - CIRCUIT TIDAK TERBONDER', 'H.13 - BONDER RETAK', 'H.14 - STRIPPING KEPANJANGAN'],
    };

    List<String> get _jenisMobilOptions => _conveyorMap.keys.toList();

    List<String> get _conveyorOptions =>
        _selectedJenisMobil == null ? [] : (_conveyorMap[_selectedJenisMobil] ?? []);

    // ── State form ──
    String? _selectedJenisMobil;
    String? _selectedConveyor;
    String? _selectedDefect;
    String? _selectedSubDefect;
    DateTime _tanggalTemuan = DateTime.now();
    final TextEditingController _qtyController =
        TextEditingController(text: '');
    final TextEditingController _noTerminalController = TextEditingController();
    final TextEditingController _noMesinController = TextEditingController();
    final TextEditingController _customSubDefectController = TextEditingController();
    @override
    void dispose() {
      _timer.cancel();
      _qtyController.dispose();
      _noTerminalController.dispose();
      _noMesinController.dispose();
      _customSubDefectController.dispose();
      super.dispose();
    }

    late Timer _timer;

@override
void initState() {
  super.initState();
  _tanggalTemuan = DateTime.now();
  // update setiap menit
  _timer = Timer.periodic(const Duration(minutes: 1), (_) {
    setState(() => _tanggalTemuan = DateTime.now());
  });
}


    List<String> get _subDefectOptions {
      if (_selectedDefect == null) return [];
      final list = _defectMap[_selectedDefect]?.toList() ?? [];
      list.add('LAIN-LAIN');
      return list;
    }

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
        firstDate: DateTime.now(),
        lastDate: DateTime.now(),
        builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: yazakiRed),
          ),
          child: child!,
        ),
      );
      if (picked != null) setState(() => _tanggalTemuan = picked);
    }

    bool get _isFormValid {
      final qty = int.tryParse(_qtyController.text) ?? 0;
      final isSubDefectValid = _selectedSubDefect != null && 
          (_selectedSubDefect != 'LAIN-LAIN' || _customSubDefectController.text.trim().isNotEmpty);
      
      return _selectedJenisMobil != null &&
          _selectedConveyor != null &&
          _selectedDefect != null &&
          isSubDefectValid &&
          qty > 0;
    }

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
      final result = DefectReportResult(
        tanggal: _formatTanggalPanjang(_tanggalTemuan),
        shift: widget.shift,
        line: _selectedConveyor!,
        jenisMobil: _selectedJenisMobil!,
        conveyor: _selectedConveyor!,
        jenisDefect: _selectedDefect!,
        subDefect: (_selectedSubDefect == 'LAIN-LAIN') ? _customSubDefectController.text.trim() : _selectedSubDefect!,
        jumlah: int.tryParse(_qtyController.text) ?? 0,
        noTerminal: _noTerminalController.text.trim().isEmpty ? null : _noTerminalController.text.trim(),
        noMesin: _noMesinController.text.trim().isEmpty ? null : _noMesinController.text.trim(),
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
              'Report Defect Pre Assy',
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

            // ── JENIS MOBIL ──
            _buildLabel('JENIS MOBIL'),
            _buildDropdown<String>(
              value: _selectedJenisMobil,
              hint: 'Pilih Jenis Mobil...',
              items: _jenisMobilOptions,
              onChanged: (v) => setState(() {
                _selectedJenisMobil = v;
                _selectedConveyor = null;
              }),
            ),
            const SizedBox(height: 18),

            // ── KONVEYOR ──
            if (_selectedJenisMobil != null) ...[
              _buildLabel('KONVEYOR'),
              _buildDropdown<String>(
                value: _selectedConveyor,
                hint: 'Pilih Konveyor...',
                items: _conveyorOptions,
                onChanged: (v) => setState(() => _selectedConveyor = v),
              ),
              const SizedBox(height: 18),
            ],

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
              onChanged: (v) => setState(() {
                _selectedSubDefect = v;
                if (v != 'LAIN-LAIN') _customSubDefectController.clear();
              }),
            ),
            if (_selectedSubDefect == 'LAIN-LAIN') ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: _customSubDefectController,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Ketik sub-defect di sini...',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
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
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
      ],
      onChanged: (_) => setState(() {}),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: InputBorder.none,
      ),
    ),
  ),
          const SizedBox(height: 18),
          _buildTextInputField(label: 'NO TERMINAL', controller: _noTerminalController, hint: 'Masukkan Nomor Terminal...'),
          _buildTextInputField(label: 'NO MESIN', controller: _noMesinController, hint: 'Masukkan Nomor Mesin...'),
          const SizedBox(height: 14),

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
                  _buildDetailField('JENIS MOBIL', _selectedJenisMobil ?? '-'),
                  const SizedBox(height: 14),
                  _buildDetailField('KONVEYOR', _selectedConveyor ?? '-'),
                  const SizedBox(height: 14),
                  _buildDetailField('JENIS DEFECT', _selectedDefect ?? '-'),
                  const SizedBox(height: 14),
                  _buildDetailField('JENIS SUB-DEFECT', _selectedSubDefect == 'LAIN-LAIN' ? _customSubDefectController.text.trim() : (_selectedSubDefect ?? '-')),
                  const Divider(height: 24, color: borderColor),
                  _buildDetailField('NO TERMINAL', _noTerminalController.text.trim().isEmpty ? '-' : _noTerminalController.text.trim()),
                  const SizedBox(height: 14),
                  _buildDetailField('NO MESIN', _noMesinController.text.trim().isEmpty ? '-' : _noMesinController.text.trim()),
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
                child: const Text('KEMBALI INPUT',
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

    Widget _buildTextInputField({
      required String label,
      required TextEditingController controller,
      String? hint,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      );
    }
  }