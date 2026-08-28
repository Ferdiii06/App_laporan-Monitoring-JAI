<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>@yield('title', 'Report Defect App')</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-[#F8F9FA] text-gray-900 font-sans antialiased min-h-screen flex flex-col">
    
    @if(Auth::check())
    <!-- Navbar (App Bar) -->
    <nav class="bg-white border-b border-[#EEEEEE] sticky top-0 z-50 shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="w-full flex justify-between items-center h-14 sm:h-16">
                <div class="text-[16px] sm:text-lg font-bold text-[#B71C1C]">
                    {{ Auth::user()->nama }}
                </div>
                <form method="POST" action="{{ route('logout') }}" class="m-0 p-0">
                    @csrf
                    <button type="submit" class="text-gray-600 hover:text-[#B71C1C] focus:outline-none flex items-center justify-center p-2 transition-colors">
                        <svg class="w-6 h-6 flex-shrink-0" style="width: 1.5rem; height: 1.5rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                        </svg>
                        <span class="hidden sm:inline-block ml-2 text-sm font-medium">Keluar</span>
                    </button>
                </form>
            </div>
        </div>
    </nav>
    @endif

    <!-- Main Content -->
    <main class="flex-grow w-full max-w-7xl mx-auto px-0 sm:px-6 lg:px-8 pb-8 sm:py-6">
        @if(session('success'))
            <div class="mx-4 sm:mx-0 mt-4 sm:mt-0 mb-4 sm:mb-6 bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg text-sm shadow-sm" role="alert">
                {{ session('success') }}
            </div>
        @endif

        @if(session('error'))
            <div class="mx-4 sm:mx-0 mt-4 sm:mt-0 mb-4 sm:mb-6 bg-[#B71C1C] text-white px-4 py-3 rounded-lg text-sm shadow-sm" role="alert">
                {{ session('error') }}
            </div>
        @endif

        @yield('content')
    </main>

    <!-- Pusher Setup dihilangkan karena sudah menggunakan Laravel Echo & Reverb via Vite -->

    @if(Auth::check())
    <!-- Heartbeat Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const userName = @json(Auth::user()->nama);
            
            // Fungsi untuk mengirim heartbeat
            function sendHeartbeat() {
                fetch('{{ url("api/heartbeat") }}', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({ nama: userName })
                })
                .then(response => response.json())
                .then(data => {
                    // console.log('Heartbeat status:', data);
                })
                .catch(error => {
                    console.error('Heartbeat gagal:', error);
                });
            }

            // Kirim heartbeat pertama kali saat halaman dimuat
            sendHeartbeat();

            // Set interval setiap 1 menit (60000 ms)
            setInterval(sendHeartbeat, 60000);
        });
    </script>
    @endif
</body>
</html>
