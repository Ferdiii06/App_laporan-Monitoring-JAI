<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('defect_reports', function (Blueprint $table) {
            $table->string('jenis_mobil')->nullable()->after('line');
            $table->string('conveyor')->nullable()->after('jenis_mobil');
        });
    }

    public function down(): void
    {
        Schema::table('defect_reports', function (Blueprint $table) {
            $table->dropColumn(['jenis_mobil', 'conveyor']);
        });
    }
};
