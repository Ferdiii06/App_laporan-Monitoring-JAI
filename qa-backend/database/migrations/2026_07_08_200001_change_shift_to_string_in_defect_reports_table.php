<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('defect_reports', function (Blueprint $table) {
            $table->string('shift', 5)->change();
        });
    }

    public function down(): void
    {
        Schema::table('defect_reports', function (Blueprint $table) {
            $table->integer('shift')->change();
        });
    }
};
