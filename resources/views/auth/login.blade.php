@extends('layouts.app')

@section('title', 'Login - Report Defect App')

@section('content')
<div class="min-h-screen flex items-center justify-center bg-white py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
        <div class="flex justify-center items-center">
            <img src="{{ asset('images/yazaki-logo.jpg') }}" alt="Yazaki Logo" class="h-32 sm:h-40 object-contain">
        </div>

        @if(session('error'))
            <div class="bg-[#B71C1C] text-white p-4 rounded-md text-sm text-center shadow-md">
                {{ session('error') }}
            </div>
        @endif

        <form class="mt-8 space-y-6" action="{{ route('login.submit') }}" method="POST">
            @csrf
            <div class="space-y-5">
                <div>
                    <label for="nama" class="block text-[13px] font-medium text-[#CC0000]">
                        Nama Lengkap
                    </label>
                    <div class="mt-1">
                        <input id="nama" name="nama" type="text" required class="appearance-none block w-full px-3 py-2 border border-[#CCCCCC] rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-[#B71C1C] focus:border-[#B71C1C] sm:text-sm" placeholder="Masukan Nama Lengkap">
                    </div>
                </div>

                <div>
                    <label class="block text-[13px] font-medium text-[#CC0000]">
                        Pilih Shift
                    </label>
                    <div class="mt-2 grid grid-cols-4 gap-2">
                        <label class="flex items-center justify-center h-[6vh] min-h-[40px] border border-[#CCCCCC] rounded-md shadow-sm text-[13px] font-semibold text-gray-800 bg-white cursor-pointer has-[:checked]:border-[#B71C1C] has-[:checked]:bg-[#B71C1C] has-[:checked]:text-white transition-colors duration-200">
                            <input type="radio" name="shift" value="1A" required class="sr-only">
                            <span>1A</span>
                        </label>
                        <label class="flex items-center justify-center h-[6vh] min-h-[40px] border border-[#CCCCCC] rounded-md shadow-sm text-[13px] font-semibold text-gray-800 bg-white cursor-pointer has-[:checked]:border-[#B71C1C] has-[:checked]:bg-[#B71C1C] has-[:checked]:text-white transition-colors duration-200">
                            <input type="radio" name="shift" value="1B" required class="sr-only">
                            <span>1B</span>
                        </label>
                        <label class="flex items-center justify-center h-[6vh] min-h-[40px] border border-[#CCCCCC] rounded-md shadow-sm text-[13px] font-semibold text-gray-800 bg-white cursor-pointer has-[:checked]:border-[#B71C1C] has-[:checked]:bg-[#B71C1C] has-[:checked]:text-white transition-colors duration-200">
                            <input type="radio" name="shift" value="2A" required class="sr-only">
                            <span>2A</span>
                        </label>
                        <label class="flex items-center justify-center h-[6vh] min-h-[40px] border border-[#CCCCCC] rounded-md shadow-sm text-[13px] font-semibold text-gray-800 bg-white cursor-pointer has-[:checked]:border-[#B71C1C] has-[:checked]:bg-[#B71C1C] has-[:checked]:text-white transition-colors duration-200">
                            <input type="radio" name="shift" value="2B" required class="sr-only">
                            <span>2B</span>
                        </label>
                    </div>
                </div>

                <div>
                    <label for="pin" class="block text-[13px] font-medium text-[#CC0000]">
                        PIN (6 Digit)
                    </label>
                    <div class="mt-1">
                        <input id="pin" name="pin" type="password" required maxlength="6" class="appearance-none block w-full px-3 py-2 border border-[#CCCCCC] rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-[#B71C1C] focus:border-[#B71C1C] text-lg tracking-[0.3em]" placeholder="••••••">
                    </div>
                </div>
            </div>

            <div class="pt-4">
                <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-semibold text-white bg-[#B71C1C] hover:bg-[#8B0000] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#B71C1C] transition-colors duration-200">
                    Masuk ke Sistem
                </button>
            </div>
        </form>
    </div>
</div>
@endsection
