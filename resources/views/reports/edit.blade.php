@extends('layouts.app')

@section('title', 'Edit Report Defect ' . $report->type)

@section('content')
<div x-data="defectForm()" class="bg-white min-h-[calc(100vh-3.5rem)] flex flex-col">
    <!-- Header -->
    <div class="px-4 py-3 flex items-center border-b border-[#EEEEEE]">
        <a href="{{ route('reports.index') }}" class="text-[#B71C1C] mr-3">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
        </a>
        <h1 class="text-base font-bold text-[#B71C1C]">Edit Report Defect {{ $report->type }}</h1>
    </div>

    <!-- MAIN FORM -->
    <form action="{{ route('reports.update', $report->id) }}" method="POST" id="defectForm" class="flex flex-col flex-grow relative">
        @csrf
        @method('PUT')
        <input type="hidden" name="type" x-model="form.type">
        <input type="hidden" name="jenis_defect" x-model="form.jenis_defect">
        <input type="hidden" name="sub_defect" x-model="form.sub_defect == 'LAIN-LAIN' ? form.custom_sub_defect : form.sub_defect">

        <!-- STEP 1: INPUT -->
        <div x-show="step === 1" class="flex flex-col flex-grow p-4 space-y-5 pb-24">
            
            <!-- Step Indicator -->
            <div class="flex justify-between items-center mb-1">
                <span class="text-xs text-gray-500 font-medium">Langkah 1 dari 2</span>
                <span class="text-sm text-[#B71C1C] font-bold">Informasi Dasar (Edit)</span>
            </div>
            <div class="flex gap-1 mb-2">
                <div class="h-1 bg-[#B71C1C] flex-1 rounded-full"></div>
                <div class="h-1 bg-[#FFD9D9] flex-1 rounded-full"></div>
            </div>

            <!-- JENIS MOBIL -->
            <div>
                <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">JENIS MOBIL</label>
                <select name="jenis_mobil" x-model="form.jenis_mobil" class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]" required>
                    <option value="" disabled selected>Pilih Jenis Mobil...</option>
                    <template x-for="mobil in Object.keys(conveyorMap)" :key="mobil">
                        <option :value="mobil" x-text="mobil"></option>
                    </template>
                </select>
            </div>

            <!-- KONVEYOR -->
            <div x-show="form.jenis_mobil">
                <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">KONVEYOR</label>
                <select name="conveyor" x-model="form.conveyor" class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]" required>
                    <option value="" disabled selected>Pilih Konveyor...</option>
                    <template x-for="conv in currentConveyors" :key="conv">
                        <option :value="conv" x-text="conv"></option>
                    </template>
                </select>
            </div>

            <!-- TANGGAL TEMUAN -->
            <div>
                <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">TANGGAL TEMUAN</label>
                <input type="date" name="tanggal" x-model="form.tanggal" class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]" required>
            </div>

            <!-- LINE -->
            <div>
                <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">LINE</label>
                <input type="text" name="line" x-model="form.line" placeholder="Masukkan Line..." class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]" required>
            </div>

            <!-- JENIS DEFECT -->
            <div>
                <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">JENIS DEFECT</label>
                <select x-model="form.jenis_defect" class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]" required>
                    <option value="" disabled selected>Pilih Jenis Defect</option>
                    <template x-for="defect in Object.keys(currentDefectMap)" :key="defect">
                        <option :value="defect" x-text="defect"></option>
                    </template>
                </select>
            </div>

            <!-- SUB DEFECT -->
            <div x-show="form.jenis_defect">
                <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">JENIS SUB-DEFECT</label>
                <select x-model="form.sub_defect" class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]" required>
                    <option value="" disabled selected>Pilih Sub-Defect</option>
                    <template x-for="sub in currentSubDefects" :key="sub">
                        <option :value="sub" x-text="sub"></option>
                    </template>
                </select>
                
                <template x-if="form.sub_defect === 'LAIN-LAIN'">
                    <input type="text" x-model="form.custom_sub_defect" placeholder="Ketik sub-defect di sini..." class="mt-2 w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]" required>
                </template>
            </div>

            <!-- QUANTITY -->
            <div>
                <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">JUMLAH (QUANTITY)</label>
                <input type="number" name="jumlah" x-model="form.jumlah" min="1" class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]" required>
            </div>

            <!-- DYNAMIC FIELDS BASED ON TYPE -->
            <template x-if="form.type === 'Final Assy'">
                <div class="space-y-5">
                    <div>
                        <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">END (#)</label>
                        <input type="text" name="end_number" x-model="form.end_number" placeholder="Masukkan END (#)..." class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]">
                    </div>
                    <div>
                        <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">SPECIFICATION</label>
                        <input type="text" name="specification" x-model="form.specification" placeholder="Masukkan Spesifikasi..." class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]">
                    </div>
                    <div>
                        <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">ACTUAL</label>
                        <input type="text" name="actual" x-model="form.actual" placeholder="Masukkan Aktual..." class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]">
                    </div>
                    <div>
                        <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">AREA DITEMUKAN</label>
                        <input type="text" name="area_ditemukan" x-model="form.area_ditemukan" placeholder="Masukkan Area Ditemukan..." class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]">
                    </div>
                    <div>
                        <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">JOB STATION</label>
                        <input type="text" name="job_station" x-model="form.job_station" placeholder="Masukkan Job Station..." class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]">
                    </div>
                </div>
            </template>

            <template x-if="form.type === 'Pre Assy'">
                <div class="space-y-5">
                    <div>
                        <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">NO TERMINAL</label>
                        <input type="text" name="no_terminal" x-model="form.no_terminal" placeholder="Masukkan Nomor Terminal..." class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]">
                    </div>
                    <div>
                        <label class="block text-[11px] font-semibold text-gray-500 tracking-wide mb-1">NO MESIN</label>
                        <input type="text" name="no_mesin" x-model="form.no_mesin" placeholder="Masukkan Nomor Mesin..." class="w-full bg-[#FAFAFA] border border-[#DDDDDD] rounded-md px-3 py-3 text-sm focus:ring-[#B71C1C] focus:border-[#B71C1C]">
                    </div>
                </div>
            </template>

            <!-- Error Message -->
            <div x-show="errorMessage" x-text="errorMessage" class="text-sm text-[#B71C1C] mt-2 font-medium bg-[#FFF0F0] p-3 rounded-md"></div>
        </div>

        <!-- STEP 2: CONFIRMATION -->
        <div x-show="step === 2" x-cloak class="flex flex-col flex-grow p-4 pb-24">
            <div class="border border-[#DDDDDD] rounded-lg p-4 bg-white shadow-sm mb-4">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-[15px] font-bold text-[#B71C1C]">Detail Laporan Defect (Edit)</h2>
                    <svg class="w-5 h-5 text-[#B71C1C]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                </div>
                
                <div class="flex justify-between">
                    <div>
                        <p class="text-[11px] text-gray-500 tracking-wide mb-1">TANGGAL</p>
                        <p class="text-[15px] font-bold text-black" x-text="formatDate(form.tanggal)"></p>
                    </div>
                    <div class="text-right">
                        <p class="text-[11px] text-gray-500 tracking-wide mb-1">SHIFT</p>
                        <p class="text-[15px] font-bold text-black">{{ $report->shift }}</p>
                    </div>
                </div>
                
                <hr class="my-4 border-[#DDDDDD]">
                
                <div class="space-y-3">
                    <div>
                        <p class="text-[11px] text-gray-500 tracking-wide mb-1">JENIS MOBIL</p>
                        <p class="text-[15px] font-bold text-black" x-text="form.jenis_mobil || '-'"></p>
                    </div>
                    <div>
                        <p class="text-[11px] text-gray-500 tracking-wide mb-1">KONVEYOR</p>
                        <p class="text-[15px] font-bold text-black" x-text="form.conveyor || '-'"></p>
                    </div>
                    <div>
                        <p class="text-[11px] text-gray-500 tracking-wide mb-1">LINE</p>
                        <p class="text-[15px] font-bold text-black" x-text="form.line || '-'"></p>
                    </div>
                    <div>
                        <p class="text-[11px] text-gray-500 tracking-wide mb-1">JENIS DEFECT</p>
                        <p class="text-[15px] font-bold text-black" x-text="form.jenis_defect || '-'"></p>
                    </div>
                    <div>
                        <p class="text-[11px] text-gray-500 tracking-wide mb-1">JENIS SUB-DEFECT</p>
                        <p class="text-[15px] font-bold text-black" x-text="form.sub_defect === 'LAIN-LAIN' ? form.custom_sub_defect : (form.sub_defect || '-')"></p>
                    </div>
                </div>

                <hr class="my-4 border-[#DDDDDD]">

                <!-- DYNAMIC CONFIRMATION FIELDS -->
                <div class="space-y-3">
                    <template x-if="form.type === 'Final Assy'">
                        <div class="space-y-3">
                            <div><p class="text-[11px] text-gray-500 tracking-wide mb-1">END (#)</p><p class="text-[15px] font-bold text-black" x-text="form.end_number || '-'"></p></div>
                            <div><p class="text-[11px] text-gray-500 tracking-wide mb-1">SPECIFICATION</p><p class="text-[15px] font-bold text-black" x-text="form.specification || '-'"></p></div>
                            <div><p class="text-[11px] text-gray-500 tracking-wide mb-1">ACTUAL</p><p class="text-[15px] font-bold text-black" x-text="form.actual || '-'"></p></div>
                            <div><p class="text-[11px] text-gray-500 tracking-wide mb-1">AREA DITEMUKAN</p><p class="text-[15px] font-bold text-black" x-text="form.area_ditemukan || '-'"></p></div>
                            <div><p class="text-[11px] text-gray-500 tracking-wide mb-1">JOB STATION</p><p class="text-[15px] font-bold text-black" x-text="form.job_station || '-'"></p></div>
                        </div>
                    </template>
                    <template x-if="form.type === 'Pre Assy'">
                        <div class="space-y-3">
                            <div><p class="text-[11px] text-gray-500 tracking-wide mb-1">NO TERMINAL</p><p class="text-[15px] font-bold text-black" x-text="form.no_terminal || '-'"></p></div>
                            <div><p class="text-[11px] text-gray-500 tracking-wide mb-1">NO MESIN</p><p class="text-[15px] font-bold text-black" x-text="form.no_mesin || '-'"></p></div>
                        </div>
                    </template>
                </div>

                <hr class="my-4 border-[#DDDDDD]">

                <div>
                    <p class="text-[11px] text-gray-500 tracking-wide mb-1">JUMLAH / QUANTITY</p>
                    <p class="text-[15px] font-bold text-black" x-text="form.jumlah || '-'"></p>
                </div>
            </div>

            <!-- Warning Info -->
            <div class="bg-[#FFF8F0] p-3 rounded-md flex items-start mb-5">
                <svg class="w-4 h-4 text-orange-500 mr-2 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                <p class="text-xs text-gray-700 leading-relaxed">Pastikan semua data hasil edit sudah benar sebelum menyimpannya.</p>
            </div>
        </div>

        <!-- BOTTOM BUTTONS BAR -->
        <div class="fixed bottom-0 left-0 right-0 max-w-7xl mx-auto px-4 py-3 bg-white border-t border-[#EEEEEE]">
            <!-- Tombol Lanjut (Step 1) -->
            <button x-show="step === 1" type="button" @click="goToConfirm" class="w-full flex justify-center items-center py-3 px-4 rounded-lg shadow-sm text-sm font-bold text-white bg-[#B71C1C] hover:bg-[#8B0000] focus:outline-none transition-colors">
                LANJUT KE KONFIRMASI <svg class="ml-2 w-4 h-4 flex-shrink-0" style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
            </button>

            <!-- Tombol Konfirmasi (Step 2) -->
            <div x-show="step === 2" x-cloak class="space-y-2">
                <button type="submit" class="w-full flex justify-center items-center py-3 px-4 rounded-lg shadow-sm text-sm font-bold text-white bg-[#B71C1C] hover:bg-[#8B0000] focus:outline-none transition-colors">
                    SIMPAN PERUBAHAN <svg class="ml-2 w-4 h-4 flex-shrink-0" style="width: 1.25rem; height: 1.25rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"></path></svg>
                </button>
                <button type="button" @click="step = 1" class="w-full flex justify-center items-center py-3 px-4 rounded-lg border border-[#DDDDDD] text-sm font-bold text-gray-800 bg-white hover:bg-gray-50 focus:outline-none transition-colors">
                    KEMBALI EDIT
                </button>
            </div>
            
            <!-- Dots Indicator -->
            <div class="flex justify-center mt-3 mb-1">
                <div class="w-1.5 h-1.5 rounded-full mx-1 transition-colors" :class="step === 1 ? 'bg-[#B71C1C]' : 'bg-[#FFD9D9]'"></div>
                <div class="w-1.5 h-1.5 rounded-full mx-1 transition-colors" :class="step === 2 ? 'bg-[#B71C1C]' : 'bg-[#FFD9D9]'"></div>
            </div>
        </div>
    </form>
</div>

<script>
    // DATA MASTER
    const conveyorMap = {
      "TOYOTA": [
        "664W-C5", "664W-C5C", "664W-C5A", "664W-C5B", "664W-C5D", "711W TNGA-C5", "711W TNGA-C5A", "737W TNGA-C5A", "737W TNGA-C5",
        "738W-C5C", "858W-C5C", "810W-C5", "941W-C5", "023J-C5", "072Y-C5", "718W-AB5.HEV", "718W-C4.CONV", "718W-C4.TNGA", "891W/892W-C1.GAS LHD",
        "853W-AT2.HEV LHD", "853W-AT6.GAS LHD", "853W-AT16.GAS LHD", "852W-AT19.HEV PHV LHD", "852W-AT2.HEV PHV LHD", "852W-AT19.HEV PHV RHD",
        "852W-AT6.GAS LHD", "909W-AT7.GAS LHD", "909W-AT11.HEV LHD", "909W-AT9.GAS LHD", "910W-AT7.GAS LHD", "910W-AT11.HEV LHD",
        "910W-AT9.GAS LHD", "953W-C6.HEV RHD", "953W-C6.HEV LHD", "953W ENG NO.3-C9", "898W-AB5.HEV", "898W-C4.CONV", "898W-C4.TNGA"
      ],
      "NISSAN": ["P33A-B1.BAT", "P33A-B1.CELL", "J32V-B2.LHD", "J32V-B2.RHD", "J42U-B3.EGI", "J42U-B3.ENGINE", "J42U-B2.DOOR RH", "J42U-B2.DOOR LH", "P33C-B1.BAT", "P33C-B1.CELL"],
      "MAZDA": ["J72A-12B.LHD", "J72A-AB9.RHD", "J72A-16C.LHD", "J72K-16C.LHD", "J30A-AB6.EXTEND LHD", "J30A-AB1.INPANEL LHD", "J30A-AB6.EXTEND RHD", "J30A-AB1.INPANEL RHD", "J69P-AB8.EXTEND LHD", "J69P-AB8.INPANEL LHD", "J69P-AB8.EXTEND RHD", "J69P-AB8.INPANEL RHD", "J69P-AB9.EXTEND LHD", "J69P-AB3.INPANEL LHD"]
    };

    const finalAssyDefects = {
        'INSER CIRCUIT': ['1.A - CROSS CIRCUIT', '1.B - CIRCUIT NOT INSERT', '1.C - WRONG INSERT CIRCUIT', '1.D - WRONG CAVITY', '1.E - MISSING CIRCUIT', '1.F - TPO'],
        'DAMAGE/DEFORM/BROKEN PART': ['2.A - DAMAGE CLIP', '2.B - DAMAGE CONNECTOR', '2.C - DAMAGE GROMMET', '2.D - DAMAGE / SCRATCH INSULATION', '2.E - DAMAGE PROTECTOR', '2.F - DAMAGE SPACER', '2.G - DAMAGE TUBE', '2.H - DAMAGE BOLT / TORQUE', '2.I - DAMAGE R/B', '2.J - DAMAGE FUSE', '2.K - DAMAGE RELAY ', '2.L - DAMAGE N/P', '2.M - DAMAGE COVER', '2.N - DAMAGE SEAL RUBBER', '2.O - DAMAGE BRACKET CONNECTOR', '2.P - DAMAGE WASHER HOSE','2.Q - CUT WIRE', '2.R - DAMAGE USB', '2.S - BENT TERMINAL','2.T - DEFORM TERMINAL','2.U - BROKEN TERMINAL', '2.V - FLARE TERMINAL'],
        'MISSING PART': ['3.A - MISSING CLIP', '3.B - MISSING COVER', '3.C - MISSING GREASE', '3.D - MISSING GROMMET', '3.E - MISSING PROTECTOR', '3.F - MISSING SEAL RUBBER', '3.G - MISSING SPACER', '3.H - MISSING SPOT TAPE', '3.I - MISSING FOAM TAPE', '3.J - MISSING TIE BACK', '3.K - MISSING TUBE', '3.L - MISSING JC / BUSSBAR', '3.M - MISSING PULLER', '3.N - MISSING PLUG', '3.O - MISSING FUSE', '3.P - MISSING RELAY', '3.Q - MISSING N/P', '3.R - MISSING MARKING / STAMP N/P', '3.S - MISSING SOLDER', '3.T - MISSING USB CABLE', '3.U - BRACKET CONNECTOR ', '3.V - WASHER HOSE'],
        'DIMENSON DEFECT': ['4.A - DIMENSION BRANCH', '4.B - DIMENSION TRUNK', '4.C - DIMENSION CLIP', '4.D - DIMENSION PROTECTOR', '4.E - DIMENSION GROMMET', '4.F - DIMENSION TUBE', '4.G - DIM.Y'],
        'HALF LOCK / INCOMPLETE DOCKING': ['5.A - HALF LOCK SPACER / RETAINER', '5.B - MISALIGN', '5.C - HALF LOCK DOCKING J/C', '5.D - HALF LOCK DOCKING LA TERMINAL', '5.E - HALF LOCK COVER R/B', '5.F - HALF LOCK PROTECTOR', '5.G - HALF LOCK INSERT FUSE', '5.H - HALF LOCK INSERT RELAY', '5.I - LOOSE TORQUE'],
        'WRONG PART': ['6.A - CRACK', '6.B - MISALIGN', '6.C - WRONG CIRCUIT', '6.D -  WRONG CLIP', '6.E - WRONG COVER', '6.F - WRONG TAPE', '6.G - WRONG GROMMET', '6.H - WRONG PROTECTOR', '6.I - WRONG SEAL RUBBER', '6.J - WRONG SPACER / HOLDER', '6.K - WRONG FOAM TAPE', '6.L - WRONG TUBE', '6.M - WRONG JC / BUSSBAR', '6.N - WRONG PLUG','6.O - WRONG FUSE','6.P - WRONG RELAY','6.Q - WRONG N/P'],
        'TAPING DEFECT': ['7.A - WRONG TAPING METHOD', '7.B - MISSING TAPING', '7.C - WRONG SPOT TAPE', '7.D - WRONG TIE BACK', '7.E - TAPING BENDERA'],
        'WRONG ORIENTATION PART': ['8.A - ORIENTASI CLIP', '8.B - ORIENTASI BRANCH', '8.C - ORIENTASI GROMMET', '8.D - ORIENTASI COVER CONN.', '8.E - ORIENTASI N/P', '8.F - ORIENTASI TIE BACK' ],
        'CUTTING - CRIMPING PRE ASSY DEFECT': ['9.A -  SALAH BENTUK REAR CRIMPING', '9.B - BUTHYL MELELEH', '9.C - OVER MELT SHRINK TUBE', '9.D - SOLDER N-OK', '9.E - RAYCHAM N-OK', '9.F - BONDER LEPAS', '9.G - OVER CIRCUIT BONDER', '9.H - MISSING CIRCUIT BONDER', '9.I - SALAH CIRCUIT BONDER', '9.J - SALAH KIND WIRE ', '9.K - SALAH SIZE WIRE', '9.L - INSULATION MUNDUR', '9.M - SEAL RUBBER MUNDUR', '9.N - FRAYING CORE', '9.O - CRACK TERMINAL' ],
        'INJECTION GROMMET / SISUI DEFECT': ['10.A - INJECTION GROMMET BERGELEMBUNG', '10.B - INJECTION GROMMET KURANG', '10.C - INJECTION GROMMET TDK MATANG', '10.D - SISUI BOCOR'],
        'LAIN-LAIN': ['11.A - FOREIGN MATERIAL', '11.B - CIRCUIT TERJEPIT', '11.C - AIR CHECKER N-OK', '11.D - BAND CLIP KEPENDEKAN', '11.E - BAND CLIP PANJANG'],
    };

    const preAssyDefects = {
        'CORE': ['A.1 - FRAYING', 'A.2 - CUT CORE', 'A.3 - TIDAK TERATUR', 'A.4 - MAJU','A.5 - MUNDUR', 'A.6 - TIDAK TERCRIMPING', 'A.7 - SCRATCH'],
        'TERMINAL': ['B.1 - TERGORES', 'B.2 - BENT UP','B.3 - BENT DOWN', 'B.4 - MELINTIR', 'B.5 - UJUNG TERPOTONG', 'B.6 - OPEN/FLARE', 'B.7 - DEFORM', 'B.8 - BRIDGE TERLALU PANJANG', 'B.9 - CANTILEVER RUSAK', 'B.10 - LEPAS DARI CIRCUIT'],
        'FRONT CRIMPING': ['C.1 - C/H TERLALU TINGGI', 'C.2 - C/H TERLALU RENDAH','C.3 - C/W TERLALU TINGGI', 'C.4 - C/W TERLALU RENDAH',  'C.5 - FLASH'],
        'REAR  CRIMPING': ['D.1 - C/H - TERLALU TINGGI', 'D.2 - C/H TERLALU RENDAH', 'D.3 - C/W TERLALU TINGGI', 'D.4 - C/W TERLALU RENDAH', 'D.5 - ADA DI DALAM INSULASI', 'D.6 - TIDAK SEIMBANG'],
        'INSULATION': ['E.1 - TERCRIMPING', 'E.2 - TERLALU MUNDUR', 'E.3 - DAMAGE', 'E.4 - TIDAK RATA'],
        'SEAL SUMBER': ['F.1 - TERPOTONG', 'F.2 - TERBALIK', 'F.3 - TERLALU MUNDUR', 'F.4 - TERLALU MAJU', 'F.5 - TERCRIMPING', 'F.6 - MISSING', 'F.7 - SEAL SOBEK'],
        'CRIMPING': ['G.1 - FOREIGN MATERIAL', 'G.2 - ADB.1 TERMMINAL TERCIMPING', 'G.3 - NO CORE', 'G.4 - NO STRIPPING'],
        'LAIN-LAIN': ['H.1 - LANCE RUSAK', 'H.2 - STABILIZER RUSAK', 'H.3 - BELLMOUTH TIDAK STANDART', 'H.4 - KONDISI CORE BAG.A', 'H.5 - RESIN MASUK BAG.A', 'H.6 - RESIN BAREL BAG.B TERBUKA', 'H.7 - CORE TERLIHAT ATAS SISI C', 'H.8 - CORE TERLIHAT SAMPING SISI C', 'H.9 - SISI PUNGGUNG', 'H.10 - ABNORMAL RESIN', 'H.11 - PANJANG WELDING N-OK', 'H.12 - CIRCUIT TIDAK TERBONDER', 'H.13 - BONDER RETAK', 'H.14 - STRIPPING KEPANJANGAN'],
    };

    document.addEventListener('alpine:init', () => {
        Alpine.data('defectForm', () => {
            const rawReport = @json($report);
            const currentMap = rawReport.type === 'Final Assy' ? finalAssyDefects : preAssyDefects;
            let initialSubDefect = rawReport.sub_defect || '';
            let customSubDefect = '';
            
            // Check if the current sub_defect is in the predefined list
            if (initialSubDefect && currentMap[rawReport.jenis_defect]) {
                if (!currentMap[rawReport.jenis_defect].includes(initialSubDefect)) {
                    customSubDefect = initialSubDefect;
                    initialSubDefect = 'LAIN-LAIN';
                }
            }
            
            return {
                step: 1,
                errorMessage: '',
                
                conveyorMap: conveyorMap,
                
                form: {
                    type: rawReport.type || 'Final Assy',
                    jenis_mobil: rawReport.jenis_mobil || '',
                    conveyor: rawReport.conveyor || '',
                    tanggal: rawReport.tanggal || new Date().toISOString().split('T')[0],
                    line: rawReport.line || '',
                    jenis_defect: rawReport.jenis_defect || '',
                    sub_defect: initialSubDefect,
                    custom_sub_defect: customSubDefect,
                    jumlah: rawReport.jumlah || '',
                    
                    // Final Assy fields
                    end_number: rawReport.end_number || '',
                    specification: rawReport.specification || '',
                    actual: rawReport.actual || '',
                    area_ditemukan: rawReport.area_ditemukan || '',
                    job_station: rawReport.job_station || '',
                    
                    // Pre Assy fields
                    no_terminal: rawReport.no_terminal || '',
                    no_mesin: rawReport.no_mesin || ''
                },

                get currentConveyors() {
                    return this.form.jenis_mobil ? this.conveyorMap[this.form.jenis_mobil] : [];
                },

                get currentDefectMap() {
                    return this.form.type === 'Final Assy' ? finalAssyDefects : preAssyDefects;
                },

                get currentSubDefects() {
                    if (!this.form.jenis_defect) return [];
                    const list = [...this.currentDefectMap[this.form.jenis_defect]];
                    list.push('LAIN-LAIN');
                    return list;
                },

                formatDate(dateStr) {
                    if (!dateStr) return '';
                    const parts = dateStr.split('-');
                    if (parts.length !== 3) return dateStr;
                    const date = new Date(dateStr);
                    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
                    return `${date.getDate()} ${months[date.getMonth()]} ${date.getFullYear()}`;
                },

                goToConfirm() {
                    this.errorMessage = '';
                    
                    if (!this.form.jenis_mobil || !this.form.conveyor || !this.form.jenis_defect || !this.form.sub_defect || !this.form.jumlah || !this.form.line) {
                        this.errorMessage = 'Mohon lengkapi semua data wajib (Jenis Mobil, Konveyor, Line, Defect, Jumlah).';
                        return;
                    }
                    
                    if (this.form.sub_defect === 'LAIN-LAIN' && !this.form.custom_sub_defect.trim()) {
                        this.errorMessage = 'Mohon isi detail sub-defect LAIN-LAIN.';
                        return;
                    }
                    
                    this.step = 2;
                    window.scrollTo(0,0);
                }
            }
        });
    });
</script>

<style>
    [x-cloak] { display: none !important; }
</style>
@endsection
