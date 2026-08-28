<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use App\Events\UserStatusUpdated;

class AuthController extends Controller
{
    // --- API METHODS ---

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
        try {
            event(new UserStatusUpdated());
        } catch (\Exception $e) {
            Log::error('Broadcast failed in login: ' . $e->getMessage());
        }

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
        Log::info('=== HEARTBEAT MASUK ===', ['data' => $request->all()]);

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
        try {
            event(new UserStatusUpdated());
        } catch (\Exception $e) {
            Log::error('Broadcast failed in heartbeat: ' . $e->getMessage());
        }

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

        $user = User::where('name', $request->nama)->first();

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
        try {
            event(new UserStatusUpdated());
        } catch (\Exception $e) {
            Log::error('Broadcast failed in logout: ' . $e->getMessage());
        }

        return response()->json([
            'status' => true,
            'message' => 'Logout berhasil',
        ]);
    }

    // --- WEB METHODS ---

    public function showLoginForm()
    {
        if (Auth::check()) {
            return redirect()->route('reports.index');
        }
        return view('auth.login');
    }

    public function loginWeb(Request $request)
    {
        $request->validate([
            'nama' => 'required|string',
            'pin' => 'required|string',
            'shift' => 'required|string|in:1A,1B,2A,2B',
        ]);

        $user = User::where('nama', $request->nama)->first();

        if (!$user || $user->pin !== $request->pin) {
            return back()->with('error', 'Nama atau PIN salah.');
        }

        Auth::login($user);
        
        // Simpan shift yang dipilih ke session
        session(['current_shift' => $request->shift]);

        $user->last_login_at = now();
        $user->last_active_at = now();
        $user->save();

        return redirect()->route('reports.index')->with('success', 'Berhasil login');
    }

    public function logoutWeb(Request $request)
    {
        $user = Auth::user();
        if ($user) {
            $user->last_active_at = null;
            $user->save();
        }

        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route('login');
    }
}

