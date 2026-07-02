<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'nama' => 'Muhammad',
            'pin' => '123456',
            'shift' => 1,
            'name' => 'Muhammad Rizki',
        ]);

        User::create([
            'nama' => 'Ahmad',
            'pin' => '654321',
            'shift' => 2,
            'name' => 'Ahmad Fauzi',
        ]);

        User::create([
            'nama' => 'Aqila'
            , 'pin' => '123456',
            'shift' => 1,
            'name' => 'Aqila Salamatudin',

        ]);

        User::create([
            'nama' => 'Ferry'
            , 'pin' => '123456',
            'shift' => 2,
            'name' => 'Ferry Ferdiansyah',
        ]);
    }
}
