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
            'data' => User::select('id', 'nama', 'shift', 'last_login_at', 'last_active_at')->get(),
        ]);
    }

    public function store(Request $request)
{
    $validated = $request->validate([
        'nama' => 'required|string|max:255',
        'pin' => 'required|digits:6',
        'shift' => 'required|integer|in:1,2',
    ]);

    $user = User::create([
        'name' => $validated['nama'],
        'nama' => $validated['nama'],
        'pin' => $validated['pin'],
        'shift' => $validated['shift'],
        'password' => Hash::make($validated['pin']),
    ]);

    return response()->json([
        'status' => true,
        'message' => 'User berhasil dibuat.',
        'data' => $user,
    ]);
}
}
