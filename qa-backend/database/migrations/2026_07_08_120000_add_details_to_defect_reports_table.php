<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('defect_reports', function (Blueprint $table) {
            $table->string('end_number')->nullable()->after('type');
            $table->string('specification')->nullable()->after('end_number');
            $table->string('actual')->nullable()->after('specification');
            $table->string('area_ditemukan')->nullable()->after('actual');
            $table->string('job_station')->nullable()->after('area_ditemukan');
            $table->string('no_terminal')->nullable()->after('job_station');
            $table->string('no_mesin')->nullable()->after('no_terminal');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('defect_reports', function (Blueprint $table) {
            $table->dropColumn([
                'end_number',
                'specification',
                'actual',
                'area_ditemukan',
                'job_station',
                'no_terminal',
                'no_mesin',
            ]);
        });
    }
};
