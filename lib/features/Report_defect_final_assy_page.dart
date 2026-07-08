import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
// ─────────────────────────────────────────
// MODEL: Hasil Input Report Defect Final Assy
// ─────────────────────────────────────────
class FinalAssyReportResult {
  final String tanggal;
  final String shift;
  final String line;
  final String jenisMobil;
  final String conveyor;
  final String jenisDefect;
  final String subDefect;
  final int jumlah;
  final String? endNumber;
  final String? specification;
  final String? actual;
  final String? areaDitemukan;
  final String? jobStation;

  const FinalAssyReportResult({
    required this.tanggal,
    required this.shift,
    required this.line,
    required this.jenisMobil,
    required this.conveyor,
    required this.jenisDefect,
    required this.subDefect,
    required this.jumlah,
    this.endNumber,
    this.specification,
    this.actual,
    this.areaDitemukan,
    this.jobStation,
  });
}

// ─────────────────────────────────────────
// PAGE: Report Defect Final Assy (2 Langkah)
// ─────────────────────────────────────────
class ReportDefectFinalAssyPage extends StatefulWidget {
  final String shift;

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
    'LAIN-LAIN': ['11.A - FOREIGN MATERIAL', '11.B - CIRCUIT TERJEPIT', '11.C - AIR CHECKER N-OK', '11.D - BAND CLIP KEPENDEKAN', '11.E - BAND CLIP PANJANG'],
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
      TextEditingController();
  final TextEditingController _endNumberController = TextEditingController();
  final TextEditingController _specificationController = TextEditingController();
  final TextEditingController _actualController = TextEditingController();
  final TextEditingController _areaDitemukanController = TextEditingController();
  final TextEditingController _jobStationController = TextEditingController();
  final TextEditingController _customSubDefectController = TextEditingController();
  @override
  void dispose() {
    _qtyController.dispose();
    _endNumberController.dispose();
    _specificationController.dispose();
    _actualController.dispose();
    _areaDitemukanController.dispose();
    _jobStationController.dispose();
    _customSubDefectController.dispose();
    super.dispose();
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
    final result = FinalAssyReportResult(
      tanggal: _formatTanggalPanjang(_tanggalTemuan),
      shift: widget.shift,
      line: _selectedConveyor!,
      jenisMobil: _selectedJenisMobil!,
      conveyor: _selectedConveyor!,
      jenisDefect: _selectedDefect!,
      subDefect: (_selectedSubDefect == 'LAIN-LAIN') ? _customSubDefectController.text.trim() : _selectedSubDefect!,
      jumlah: int.tryParse(_qtyController.text) ?? 0,
      endNumber: _endNumberController.text.trim().isEmpty ? null : _endNumberController.text.trim(),
      specification: _specificationController.text.trim().isEmpty ? null : _specificationController.text.trim(),
      actual: _actualController.text.trim().isEmpty ? null : _actualController.text.trim(),
      areaDitemukan: _areaDitemukanController.text.trim().isEmpty ? null : _areaDitemukanController.text.trim(),
      jobStation: _jobStationController.text.trim().isEmpty ? null : _jobStationController.text.trim(),
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
          _buildTextInputField(label: 'END (#)', controller: _endNumberController, hint: 'Masukkan END (#)...'),
          _buildTextInputField(label: 'SPECIFICATION', controller: _specificationController, hint: 'Masukkan Spesifikasi...'),
          _buildTextInputField(label: 'ACTUAL', controller: _actualController, hint: 'Masukkan Aktual...'),
          _buildTextInputField(label: 'AREA DITEMUKAN', controller: _areaDitemukanController, hint: 'Masukkan Area ditemukan...'),
          _buildTextInputField(label: 'JOB STATION', controller: _jobStationController, hint: 'Masukkan Job Station...'),
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
                _buildDetailField('END (#)', _endNumberController.text.trim().isEmpty ? '-' : _endNumberController.text.trim()),
                const SizedBox(height: 14),
                _buildDetailField('SPECIFICATION', _specificationController.text.trim().isEmpty ? '-' : _specificationController.text.trim()),
                const SizedBox(height: 14),
                _buildDetailField('ACTUAL', _actualController.text.trim().isEmpty ? '-' : _actualController.text.trim()),
                const SizedBox(height: 14),
                _buildDetailField('AREA DITEMUKAN', _areaDitemukanController.text.trim().isEmpty ? '-' : _areaDitemukanController.text.trim()),
                const SizedBox(height: 14),
                _buildDetailField('JOB STATION', _jobStationController.text.trim().isEmpty ? '-' : _jobStationController.text.trim()),
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