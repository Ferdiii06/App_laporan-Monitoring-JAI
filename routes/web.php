<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ReportController;

Route::get('/', function () {
    return redirect()->route('login');
});

Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'loginWeb'])->name('login.submit');
Route::post('/logout', [AuthController::class, 'logoutWeb'])->name('logout');

Route::middleware('auth')->group(function () {
    // Dashboard
    Route::get('/dashboard', [ReportController::class, 'indexWeb'])->name('reports.index');
    
    // Create Forms
    Route::get('/reports/create/final-assy', [ReportController::class, 'createFinalAssy'])->name('reports.create.final');
    Route::get('/reports/create/pre-assy', [ReportController::class, 'createPreAssy'])->name('reports.create.pre');
    
    // Store, Edit, Update, Destroy
    Route::post('/reports', [ReportController::class, 'storeWeb'])->name('reports.store');
    Route::get('/reports/{id}/edit', [ReportController::class, 'edit'])->name('reports.edit');
    Route::put('/reports/{id}', [ReportController::class, 'updateWeb'])->name('reports.update');
    Route::delete('/reports/{id}', [ReportController::class, 'destroyWeb'])->name('reports.destroy');
});
