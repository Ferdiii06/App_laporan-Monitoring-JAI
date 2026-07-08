<?php
require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;

try {
    $users = User::all();
    echo "USERS IN DB:\n";
    foreach ($users as $u) {
        echo "ID: {$u->id}, Name: {$u->nama}, Last Login: {$u->last_login_at}, Last Active: {$u->last_active_at}\n";
    }
} catch (\Exception $e) {
    echo "DB Error: " . $e->getMessage() . "\n";
}
