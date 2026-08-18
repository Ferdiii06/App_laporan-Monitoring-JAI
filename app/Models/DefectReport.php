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
        'jenis_mobil',
        'conveyor',
        'jenis_defect',
        'sub_defect',
        'jumlah',
        'tanggal',
        'type',
        'end_number',
        'specification',
        'actual',
        'area_ditemukan',
        'job_station',
        'no_terminal',
        'no_mesin',
    ];
}
