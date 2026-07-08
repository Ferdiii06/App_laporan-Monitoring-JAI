<?php
namespace App\Http\Controllers;
use App\Models\DefectReport;
use App\Events\LaporanMonitoringUpdated;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_user' => 'required|string',
            'shift' => 'required|integer',
            'line' => 'required|string',
            'jenis_mobil' => 'required|string',
            'conveyor' => 'required|string',
            'jenis_defect' => 'required|string',
            'sub_defect' => 'required|string',
            'jumlah' => 'required|integer|min:1',
            'tanggal' => 'required|string',
            'type' => 'required|string',
        ]);
        $report = DefectReport::create($validated);


        \Log::info('dYY BEFORE EVENT DISPATCH - created', ['id' => $report->id]);
        try {
            event(new LaporanMonitoringUpdated($report, 'created'));
            \Log::info('dYY EVENT DISPATCHED SUCCESSFULLY - created');
        } catch (\Exception $e) {
            \Log::error('dY"' . ' EVENT DISPATCH FAILED - created: ' . $e->getMessage());
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
}