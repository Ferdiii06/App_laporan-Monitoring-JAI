<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'nama' => 'Muhammad Rizki',
            'pin' => '123456',
            'shift' => 1,
            'name' => 'Muhammad Rizki',
            'email' => 'rizki@yazaki.com',
            'password' => bcrypt('password'),
        ]);

        User::create([
            'nama' => 'Ahmad Fauzi',
            'pin' => '654321',
            'shift' => 2,
            'name' => 'Ahmad Fauzi',
            'email' => 'fauzi@yazaki.com',
            'password' => bcrypt('password'),
        ]);

        User::create([
            'nama' => 'Aqila Salamatudin'
            , 'pin' => '123456',
            'shift' => 1,
            'name' => 'Aqila Salamatudin',
            'email' => 'aqila@yazaki.com',
            'password' => bcrypt('password'),
        ]);

        User::create([
            'nama' => 'Ferry Ferdiansyah'
            , 'pin' => '123456',
            'shift' => 2,
            'name' => 'Ferry Ferdiansyah',
            'email' => 'ferry@yazaki.com',
            'password' => bcrypt('password'),
        ]);
    }
}
