<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DefectReport extends Model
{
    use HasFactory;

    protected $fillable = [
        'nama_user',
        'shift',
        'line',
        'jenis_mobil',    // ← TAMBAHKAN
        'conveyor',       // ← TAMBAHKAN
        'jenis_defect',
        'sub_defect',
        'jumlah',
        'tanggal',
        'type'
    ];
}
