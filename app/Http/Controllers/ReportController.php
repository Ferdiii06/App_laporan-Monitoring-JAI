<?php
namespace App\Http\Controllers;
use App\Models\DefectReport;
use App\Events\LaporanMonitoringUpdated;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;

class ReportController extends Controller
{
    // --- API METHODS ---
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_user' => 'required|string',
            'shift' => 'required|string|in:1A,1B,2A,2B',
            'line' => 'required|string',
            'jenis_mobil' => 'required|string',
            'conveyor' => 'required|string',
            'jenis_defect' => 'required|string',
            'sub_defect' => 'required|string',
            'jumlah' => 'required|integer|min:1',
            'tanggal' => 'required|string',
            'type' => 'required|string',
            'end_number' => 'nullable|string',
            'specification' => 'nullable|string',
            'actual' => 'nullable|string',
            'area_ditemukan' => 'nullable|string',
            'job_station' => 'nullable|string',
            'no_terminal' => 'nullable|string',
            'no_mesin' => 'nullable|string',
        ]);
        $report = DefectReport::create($validated);


        Log::info('dYY BEFORE EVENT DISPATCH - created', ['id' => $report->id]);
        try {
            event(new LaporanMonitoringUpdated($report, 'created'));
            Log::info('dYY EVENT DISPATCHED SUCCESSFULLY - created');
        } catch (\Exception $e) {
            Log::error('dY"' . ' EVENT DISPATCH FAILED - created: ' . $e->getMessage());
        }

        return response()->json([
            'status' => true,
            'message' => 'Laporan berhasil disimpan',
            'data' => $report
        ]);
    }

    //  UPDATED: filter berdasarkan nama_user kalau dikirim
    public function index(Request $request)
    {
        $query = DefectReport::orderBy('created_at', 'desc');

        if ($request->filled('nama_user')) {
            $query->where('nama_user', $request->query('nama_user'));
        }

        $reports = $query->get();

        return response()->json([
            'status' => true,
            'data' => $reports
        ]);
    }

    public function show($id)
    {
        $report = DefectReport::find($id);
        if (!$report) {
            return response()->json(['status' => false, 'message' => 'Data tidak ditemukan'], 404);
        }
        return response()->json(['status' => true, 'data' => $report]);
    }

    //  UPDATED: cek kepemilikan sebelum update
    public function update(Request $request, $id)
    {
        $report = DefectReport::find($id);
        if (!$report) {
            return response()->json(['status' => false, 'message' => 'Data tidak ditemukan'], 404);
        }

        // Cek kepemilikan
        if ($request->filled('nama_user') && $report->nama_user !== $request->input('nama_user')) {
            return response()->json([
                'status' => false,
                'message' => 'Anda tidak memiliki izin untuk mengubah laporan ini.'
            ], 403);
        }

        $validated = $request->validate([
            'line' => 'string',
            'jenis_mobil' => 'required|string',
            'conveyor' => 'required|string',
            'jenis_defect' => 'string',
            'sub_defect' => 'string',
            'jumlah' => 'integer|min:1',
            'tanggal' => 'string',
            'end_number' => 'nullable|string',
            'specification' => 'nullable|string',
            'actual' => 'nullable|string',
            'area_ditemukan' => 'nullable|string',
            'job_station' => 'nullable|string',
            'no_terminal' => 'nullable|string',
            'no_mesin' => 'nullable|string',
        ]);
        $report->update($validated);
        event(new LaporanMonitoringUpdated($report, 'updated'));
        return response()->json([
            'status' => true,
            'message' => 'Laporan berhasil diupdate',
            'data' => $report
        ]);
    }

    //  UPDATED: cek kepemilikan sebelum hapus
    public function destroy(Request $request, $id)
    {
        $report = DefectReport::find($id);
        if (!$report) {
            return response()->json(['status' => false, 'message' => 'Data tidak ditemukan'], 404);
        }

        // Cek kepemilikan
        if ($request->filled('nama_user') && $report->nama_user !== $request->input('nama_user')) {
            return response()->json([
                'status' => false,
                'message' => 'Anda tidak memiliki izin untuk menghapus laporan ini.'
            ], 403);
        }

        event(new LaporanMonitoringUpdated($report, 'deleted'));
        $report->delete();
        return response()->json([
            'status' => true,
            'message' => 'Laporan berhasil dihapus'
        ]);
    }
    
    // --- WEB METHODS ---
    public function indexWeb(Request $request)
    {
        $query = DefectReport::orderBy('created_at', 'desc');
        
        // Opsional: jika role admin bisa lihat semua, jika user biasa hanya lihat miliknya
        $user = Auth::user();
        if ($user->role !== 'admin') {
            $query->where('nama_user', $user->nama);
        }
        
        $reports = $query->paginate(15);
        return view('reports.index', compact('reports'));
    }

    public function createFinalAssy()
    {
        return view('reports.create', ['type' => 'Final Assy']);
    }

    public function createPreAssy()
    {
        return view('reports.create', ['type' => 'Pre Assy']);
    }

    public function storeWeb(Request $request)
    {
        $validated = $request->validate([
            'line' => 'required|string',
            'jenis_mobil' => 'required|string',
            'conveyor' => 'required|string',
            'jenis_defect' => 'required|string',
            'sub_defect' => 'required|string',
            'jumlah' => 'required|integer|min:1',
            'tanggal' => 'required|string',
            'type' => 'required|string',
            'end_number' => 'nullable|string',
            'specification' => 'nullable|string',
            'actual' => 'nullable|string',
            'area_ditemukan' => 'nullable|string',
            'job_station' => 'nullable|string',
            'no_terminal' => 'nullable|string',
            'no_mesin' => 'nullable|string',
        ]);
        
        $validated['nama_user'] = Auth::user()->nama;
        $validated['shift'] = session('current_shift', Auth::user()->shift ?? '1A');

        $report = DefectReport::create($validated);
        
        try {
            event(new LaporanMonitoringUpdated($report, 'created'));
        } catch (\Exception $e) {
            Log::error('EVENT DISPATCH FAILED: ' . $e->getMessage());
        }

        return redirect()->route('reports.index')->with('success', 'Laporan berhasil dibuat.');
    }

    public function edit($id)
    {
        $report = DefectReport::findOrFail($id);
        
        $user = Auth::user();
        if ($user->role !== 'admin' && $report->nama_user !== $user->nama) {
            return redirect()->route('reports.index')->with('error', 'Anda tidak memiliki akses.');
        }

        return view('reports.edit', compact('report'));
    }

    public function updateWeb(Request $request, $id)
    {
        $report = DefectReport::findOrFail($id);
        
        $user = Auth::user();
        if ($user->role !== 'admin' && $report->nama_user !== $user->nama) {
            return redirect()->route('reports.index')->with('error', 'Anda tidak memiliki akses.');
        }

        $validated = $request->validate([
            'line' => 'required|string',
            'jenis_mobil' => 'required|string',
            'conveyor' => 'required|string',
            'jenis_defect' => 'required|string',
            'sub_defect' => 'required|string',
            'jumlah' => 'required|integer|min:1',
            'tanggal' => 'required|string',
            'type' => 'required|string',
            'end_number' => 'nullable|string',
            'specification' => 'nullable|string',
            'actual' => 'nullable|string',
            'area_ditemukan' => 'nullable|string',
            'job_station' => 'nullable|string',
            'no_terminal' => 'nullable|string',
            'no_mesin' => 'nullable|string',
        ]);

        $report->update($validated);
        
        try {
            event(new LaporanMonitoringUpdated($report, 'updated'));
        } catch (\Exception $e) {
            Log::error('EVENT DISPATCH FAILED: ' . $e->getMessage());
        }

        return redirect()->route('reports.index')->with('success', 'Laporan berhasil diupdate.');
    }

    public function destroyWeb($id)
    {
        $report = DefectReport::findOrFail($id);
        
        $user = Auth::user();
        if ($user->role !== 'admin' && $report->nama_user !== $user->nama) {
            return redirect()->route('reports.index')->with('error', 'Anda tidak memiliki akses.');
        }

        $report->delete();
        
        try {
            event(new LaporanMonitoringUpdated($report, 'deleted'));
        } catch (\Exception $e) {
            Log::error('EVENT DISPATCH FAILED: ' . $e->getMessage());
        }

        return redirect()->route('reports.index')->with('success', 'Laporan berhasil dihapus.');
    }
}
