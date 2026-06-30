<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ReportController;

// Route root API - untuk test
Route::get('/', function () {
    return response()->json(['status' => true, 'message' => 'Yazaki API Running']);
});

// Route Login - POST
Route::post('/login', [AuthController::class, 'login']);

// Route Reports
Route::prefix('reports')->group(function () {
    Route::get('/', [ReportController::class, 'index']);
    Route::get('/{id}', [ReportController::class, 'show']);
    Route::post('/', [ReportController::class, 'store']);
    Route::put('/{id}', [ReportController::class, 'update']);
    Route::delete('/{id}', [ReportController::class, 'destroy']);
});

// Tambahkan route untuk cek shift user
Route::post('/check-shift', function (Request $request) {
    $user = App\Models\User::where('nama', $request->nama)->first();
    if (!$user) {
        return response()->json(['status' => false, 'message' => 'User tidak ditemukan']);
    }
    return response()->json([
        'status' => true,
        'data' => [
            'nama' => $user->nama,
            'shift' => $user->shift,
        ]
    ]);
});
