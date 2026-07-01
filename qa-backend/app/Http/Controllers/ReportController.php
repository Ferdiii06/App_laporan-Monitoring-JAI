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
            'jenis_mobil' => 'required|string',   // ← TAMBAHKAN
            'conveyor' => 'required|string',
            'jenis_defect' => 'required|string',
            'sub_defect' => 'required|string',
            'jumlah' => 'required|integer|min:1',
            'tanggal' => 'required|string',
            'type' => 'required|string',
        ]);

        $report = DefectReport::create($validated);

        // Broadcast event ke monitoring-channel (real-time)
        event(new LaporanMonitoringUpdated($report, 'created'));

        return response()->json([
            'status' => true,
            'message' => 'Laporan berhasil disimpan',
            'data' => $report
        ]);
    }

    public function index()
    {
        $reports = DefectReport::orderBy('created_at', 'desc')->get();
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

    public function update(Request $request, $id)
    {
        $report = DefectReport::find($id);
        if (!$report) {
            return response()->json(['status' => false, 'message' => 'Data tidak ditemukan'], 404);
        }

        $validated = $request->validate([
            'line' => 'string',
            'jenis_mobil' => 'required|string',   // ← TAMBAHKAN
            'conveyor' => 'required|string',
            'jenis_defect' => 'string',
            'sub_defect' => 'string',
            'jumlah' => 'integer|min:1',
            'tanggal' => 'string',
        ]);

        $report->update($validated);

        // Broadcast event ke monitoring-channel (real-time)
        event(new LaporanMonitoringUpdated($report, 'updated'));

        return response()->json([
            'status' => true,
            'message' => 'Laporan berhasil diupdate',
            'data' => $report
        ]);
    }

    public function destroy($id)
    {
        $report = DefectReport::find($id);
        if (!$report) {
            return response()->json(['status' => false, 'message' => 'Data tidak ditemukan'], 404);
        }

        // Broadcast sebelum delete agar data masih tersedia
        event(new LaporanMonitoringUpdated($report, 'deleted'));

        $report->delete();

        return response()->json([
            'status' => true,
            'message' => 'Laporan berhasil dihapus'
        ]);
    }
}
