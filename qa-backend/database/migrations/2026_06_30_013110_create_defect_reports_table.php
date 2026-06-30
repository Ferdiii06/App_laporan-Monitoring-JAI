<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('defect_reports', function (Blueprint $table) {
            $table->id();
            $table->string('nama_user');
            $table->integer('shift');
            $table->string('line');
            $table->string('jenis_defect');
            $table->string('sub_defect');
            $table->integer('jumlah');
            $table->string('tanggal');
            $table->string('type'); // 'Pre Assy' atau 'Final Assy'
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('defect_reports');
    }
};
