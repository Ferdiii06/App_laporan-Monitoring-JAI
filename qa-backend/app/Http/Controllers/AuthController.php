<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

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
            'shift' => 'required|integer|in:1,2', // ← VALIDASI SHIFT
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

        // ⭐ CEK SHIFT
        Log::info('Shift check:', [
            'input_shift' => $request->shift,
            'user_shift' => $user->shift
        ]);

        if ((int)$request->shift !== (int)$user->shift) {
            return response()->json([
                'status' => false,
                'message' => 'Shift yang dipilih tidak sesuai. Anda terdaftar sebagai Shift ' . $user->shift . '.'
            ], 403);
        }

        // Login berhasil
        return response()->json([
            'status' => true,
            'message' => 'Login berhasil',
            'data' => [
                'nama' => $user->nama,
                'shift' => $user->shift,
            ]
        ]);
    }
}
