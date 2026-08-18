@extends('layouts.app')

@section('title', 'Dashboard - Report Defect App')

@section('content')
<div class="px-4 sm:px-0 bg-white sm:bg-transparent min-h-[calc(100vh-3.5rem)] sm:min-h-0">
    <div class="pt-4 sm:pt-0 sm:flex sm:justify-between sm:items-center">
        <!-- Badge Shift -->
        <div class="inline-block px-3 py-1 bg-red-50 border border-red-200 rounded-md shadow-sm" style="background-color: #FFF0F0; border-color: #FFCCCC;">
            <span class="text-[12px] sm:text-[13px] font-semibold text-red-700" style="color: #B71C1C;">
                Shift {{ session('current_shift', Auth::user()->shift ?? '1A') }} aktif
            </span>
        </div>

        <!-- Tombol Input Report -->
        <div class="mt-4 sm:mt-0 flex flex-row gap-2">
            <a href="{{ route('reports.create.final') }}" class="flex-1 sm:flex-none sm:w-48 bg-red-700 hover:bg-red-800 transition-colors rounded-md p-2.5 sm:px-4 sm:py-3 flex justify-between items-center shadow-md" style="background-color: #B71C1C;">
                <span class="text-white text-[12px] sm:text-sm font-bold leading-tight text-left">Input Report<br>Final Assy</span>
                <svg class="w-4 h-4 text-white flex-shrink-0 ml-1.5" style="width: 1.1rem; height: 1.1rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M9 5l7 7-7 7"></path></svg>
            </a>
            <a href="{{ route('reports.create.pre') }}" class="flex-1 sm:flex-none sm:w-48 bg-red-700 hover:bg-red-800 transition-colors rounded-md p-2.5 sm:px-4 sm:py-3 flex justify-between items-center shadow-md" style="background-color: #B71C1C;">
                <span class="text-white text-[12px] sm:text-sm font-bold leading-tight text-left">Input Report<br>Pre Assy</span>
                <svg class="w-4 h-4 text-white flex-shrink-0 ml-1.5" style="width: 1.1rem; height: 1.1rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M9 5l7 7-7 7"></path></svg>
            </a>
        </div>
    </div>

    <!-- Riwayat Report -->
    <div class="mt-6 sm:mt-8">
        <div class="flex items-center justify-between mb-4">
            <h3 class="text-[16px] sm:text-xl font-bold sm:font-semibold text-gray-800">Riwayat Report</h3>
        </div>

        @if($reports->isEmpty())
            <div class="flex flex-col items-center justify-center py-12 sm:py-20 bg-white sm:rounded-xl sm:shadow-sm sm:border sm:border-gray-100">
                <svg class="w-14 h-14 sm:w-16 sm:h-16 text-gray-300 mb-4 flex-shrink-0" style="width: 3.5rem; height: 3.5rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path></svg>
                <p class="text-gray-500 text-sm sm:text-base">Belum ada riwayat report hari ini.</p>
                <a href="{{ route('reports.index') }}" class="mt-5 text-red-700 hover:bg-red-100 transition-colors text-sm font-semibold flex items-center px-5 py-2.5 bg-red-50 rounded-full" style="color: #B71C1C; background-color: #FFF0F0;">
                    <svg class="w-4 h-4 mr-2 flex-shrink-0" style="width: 1rem; height: 1rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path></svg>
                    Muat ulang data
                </a>
            </div>
        @else
            <!-- RESPONSIVE GRID LAYOUT -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 sm:gap-5">
                @foreach($reports as $report)
                    <div class="bg-white border border-[#F4D0D0] sm:border-gray-200 sm:hover:border-[#F4D0D0] sm:hover:shadow-md transition-all rounded-xl overflow-hidden shadow-sm flex flex-col">
                        <!-- Header & Type -->
                        <div class="px-4 pt-3 pb-3">
                            <div class="flex justify-between items-center mb-1">
                                <span class="text-[11px] text-[#A0A0A0] font-bold tracking-widest uppercase">{{ \Carbon\Carbon::parse($report->tanggal)->translatedFormat('d F Y') }}</span>
                                <div class="flex items-center space-x-3">
                                    <a href="{{ route('reports.edit', $report->id) }}" class="text-gray-400 hover:text-gray-700 transition-colors">
                                        <svg class="w-[18px] h-[18px] flex-shrink-0" style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.5l13.732-13.732z"></path></svg>
                                    </a>
                                    <form action="{{ route('reports.destroy', $report->id) }}" method="POST" class="inline-block m-0" onsubmit="return confirm('Apakah yakin ingin menghapus data ini?\nTindakan ini tidak dapat dibatalkan.');">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="text-[#B71C1C] hover:text-red-800 transition-colors">
                                            <svg class="w-[18px] h-[18px] flex-shrink-0" style="width: 1.125rem; height: 1.125rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                        </button>
                                    </form>
                                </div>
                            </div>
                            <div class="mt-1">
                                <span class="text-[15px] sm:text-base font-medium sm:font-semibold text-gray-800">{{ $report->type }}</span>
                            </div>
                        </div>
                        
                        <div class="border-t border-[#F4EBEB] sm:border-gray-100 mx-4 my-1"></div>

                        <!-- Data Fields -->
                        <div class="px-4 pb-4 mt-2 flex-grow">
                            <div class="flex justify-between items-end mb-1">
                                <span class="text-[11px] text-gray-500">Defect</span>
                                <span class="text-[11px] text-gray-500">Jumlah</span>
                            </div>
                            <div class="flex justify-between items-start mb-4">
                                <span class="text-[14px] sm:text-[15px] font-bold text-gray-900 leading-tight pr-2">{{ $report->jenis_defect }}</span>
                                <span class="text-[14px] sm:text-[15px] font-bold text-gray-900 whitespace-nowrap">{{ $report->jumlah }} Unit</span>
                            </div>

                            <div class="mb-1">
                                <span class="text-[11px] text-gray-500">Jenis Mobil</span>
                            </div>
                            <div class="mb-4">
                                <span class="text-[14px] sm:text-[15px] font-bold text-gray-900 uppercase">{{ $report->jenis_mobil }}</span>
                            </div>

                            <div class="mb-1">
                                <span class="text-[11px] text-gray-500">Conveyor</span>
                            </div>
                            <div class="mb-4">
                                <span class="text-[14px] sm:text-[15px] font-bold text-gray-900 uppercase">{{ $report->conveyor }}</span>
                            </div>

                            <div class="mb-1">
                                <span class="text-[11px] text-gray-500">Sub-Defect</span>
                            </div>
                            <div>
                                <span class="text-[14px] sm:text-[15px] font-bold text-gray-900">{{ $report->sub_defect }}</span>
                            </div>
                            
                            @if($report->end_number)
                            <div class="mt-4">
                                <span class="text-[11px] text-gray-500">END (#)</span>
                                <div class="text-[14px] font-bold text-gray-900">{{ $report->end_number }}</div>
                            </div>
                            @endif
                            @if($report->specification)
                            <div class="mt-4">
                                <span class="text-[11px] text-gray-500">Specification</span>
                                <div class="text-[14px] font-bold text-gray-900">{{ $report->specification }}</div>
                            </div>
                            @endif
                            @if($report->actual)
                            <div class="mt-4">
                                <span class="text-[11px] text-gray-500">Actual</span>
                                <div class="text-[14px] font-bold text-gray-900">{{ $report->actual }}</div>
                            </div>
                            @endif
                            @if($report->area_ditemukan)
                            <div class="mt-4">
                                <span class="text-[11px] text-gray-500">Area Ditemukan</span>
                                <div class="text-[14px] font-bold text-gray-900">{{ $report->area_ditemukan }}</div>
                            </div>
                            @endif
                            @if($report->job_station)
                            <div class="mt-4">
                                <span class="text-[11px] text-gray-500">Job Station</span>
                                <div class="text-[14px] font-bold text-gray-900">{{ $report->job_station }}</div>
                            </div>
                            @endif
                            @if($report->no_terminal)
                            <div class="mt-4">
                                <span class="text-[11px] text-gray-500">No Terminal</span>
                                <div class="text-[14px] font-bold text-gray-900">{{ $report->no_terminal }}</div>
                            </div>
                            @endif
                            @if($report->no_mesin)
                            <div class="mt-4">
                                <span class="text-[11px] text-gray-500">No Mesin</span>
                                <div class="text-[14px] font-bold text-gray-900">{{ $report->no_mesin }}</div>
                            </div>
                            @endif
                        </div>
                    </div>
                @endforeach
            </div>

            @if($reports->hasPages())
            <div class="mt-6 sm:mt-8">
                {{ $reports->links() }}
            </div>
            @endif
        @endif
    </div>
</div>

<script type="module">
    if (window.Echo) {
        window.Echo.channel('monitoring-channel')
            .listen('.laporan.updated', (e) => {
                console.log('Update diterima:', e);
                window.location.reload();
            });
    }
</script>
@endsection
