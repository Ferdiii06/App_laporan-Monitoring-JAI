<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class UserApiController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => true,
            // Sertakan 'role' dan 'pin' agar dashboard bisa cek autentikasi
            'data' => User::select('id', 'nama', 'pin', 'shift', 'role', 'last_login_at', 'last_active_at')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama'  => 'required|string|max:255',
            'pin'   => 'required|digits:6',
            'role'  => 'required|string|in:Admin,User',
            // shift wajib hanya jika role = User
            'shift' => 'required_if:role,User|nullable|string|in:1A,1B,2A,2B',
        ]);

        $user = User::create([
            'name'     => $validated['nama'],
            'nama'     => $validated['nama'],
            'pin'      => $validated['pin'],
            'shift'    => $validated['role'] === 'User' ? ($validated['shift'] ?? null) : null,
            'role'     => $validated['role'],
            'password' => Hash::make($validated['pin']),
        ]);

        return response()->json([
            'status'  => true,
            'message' => 'User berhasil dibuat.',
            'data'    => $user,
        ]);
    }
}
