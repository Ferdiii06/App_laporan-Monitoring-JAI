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
            'pin' => '444444',
            'shift' => '1A',
            'name' => 'Muhammad Rizki',
            'password' => bcrypt('123456'),
        ]);

        User::create([
            'nama' => 'Ahmad',
            'pin' => '333333',
            'shift' => '2A',
            'name' => 'Ahmad Fauzi',
            'password' => bcrypt('654321'),
        ]);

        User::create([
            'nama' => 'Aqila',
            'pin' => '111111',
            'shift' => '1B',
            'name' => 'Aqila Salamatudin',
            'password' => bcrypt('123456'),
        ]);

        User::create([
            'nama' => 'Ferry',
            'pin' => '222222',
            'shift' => '2B',
            'name' => 'Ferry Ferdiansyah',
            'password' => bcrypt('123456'),
        ]);
    }
}
