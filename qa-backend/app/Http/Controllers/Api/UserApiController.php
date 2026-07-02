<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;

class UserApiController extends Controller
{
    public function index()
    {
        return response()->json([
            'status' => true,
            'data' => User::select('id', 'nama', 'shift', 'last_login_at')->get(),
        ]);
    }
}
