<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Events\UserStatusUpdated;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        // Log semua data yang masuk
        Log::info('Login attempt:', $request->all());

        // Validasi input
        $request->validate([
            'nama' => 'required|string',
            'pin' => 'required|string|min:6',
            'shift' => 'required|string|in:1A,1B,2A,2B',
        ]);

        // Cari user berdasarkan nama
        $user = User::where('nama', $request->nama)->first();

        // Cek user
        if (!$user) {
            Log::warning('User not found:', ['nama' => $request->nama]);
            return response()->json([
                'status' => false,
                'message' => 'Nama tidak ditemukan.'
            ], 401);
        }

        // Cek PIN
        if ($request->pin !== $user->pin) {
            Log::warning('Wrong PIN for user:', ['nama' => $request->nama]);
            return response()->json([
                'status' => false,
                'message' => 'PIN salah.'
            ], 401);
        }

        // Cek shift — dihapus: user & admin boleh akses semua shift
        Log::info('Shift login (bebas):', [
            'nama' => $user->nama,
            'shift_dipilih' => $request->shift,
        ]);

        // Simpan waktu login dan keaktifan terakhir
        $user->last_login_at = now();
        $user->last_active_at = now();
        $user->save();

        event(new UserStatusUpdated());

        // Login berhasil — kembalikan shift yang dipilih user (bukan shift di DB)
        return response()->json([
            'status' => true,
            'message' => 'Login berhasil',
            'data' => [
                'nama' => $user->nama,
                'shift' => $request->shift,
            ]
        ]);
    }

    // 🆕 METHOD BARU UNTUK HEARTBEAT (Active Users)
    public function heartbeat(Request $request)
    {
        $request->validate([
            'nama' => 'required|string',
        ]);

        $user = User::where('nama', $request->nama)->first();

        if (!$user) {
            Log::warning('Heartbeat - user not found:', ['nama' => $request->nama]);
            return response()->json([
                'status' => false,
                'message' => 'User tidak ditemukan.'
            ], 404);
        }

        $user->last_active_at = now();
        $user->save();

        event(new UserStatusUpdated());

        return response()->json([
            'status' => true,
            'message' => 'Heartbeat diterima',
            'last_active_at' => $user->last_active_at,
        ]);
    }

    // 🆕 METHOD BARU UNTUK ENDPOINT LOGOUT
    public function logout(Request $request)
    {
        $request->validate([
            'nama' => 'required|string',
        ]);

        $user = User::where('nama', $request->nama)->first();

        if (!$user) {
            Log::warning('Logout - user not found:', ['nama' => $request->nama]);
            return response()->json([
                'status' => false,
                'message' => 'User tidak ditemukan.'
            ], 404);
        }

        // Reset last_active_at saat logout
        $user->last_active_at = null;
        $user->save();

        event(new UserStatusUpdated());

        return response()->json([
            'status' => true,
            'message' => 'Logout berhasil',
        ]);
    }

}


