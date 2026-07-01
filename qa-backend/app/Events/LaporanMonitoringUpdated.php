<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use App\Models\DefectReport;

class LaporanMonitoringUpdated implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public array $laporan;
    public string $action;

    /**
     * Create a new event instance.
     *
     * @param DefectReport $report  Data laporan yang baru disimpan/diupdate
     * @param string       $action  Tipe aksi: 'created', 'updated', atau 'deleted'
     */
    public function __construct(DefectReport $report, string $action = 'created')
    {
        // Kirim data laporan sebagai array agar mudah dikonsumsi client
        $this->laporan = $report->toArray();
        $this->action = $action;
    }

    /**
     * Channel broadcast — menggunakan public channel agar website 
     * dashboard terpisah bisa subscribe tanpa authentication.
     */
    public function broadcastOn(): array
    {
        return [
            new Channel('monitoring-channel'),
        ];
    }

    /**
     * Nama event yang konsisten untuk dipakai di sisi client.
     * Di client, listen dengan nama: 'laporan.updated'
     */
    public function broadcastAs(): string
    {
        return 'laporan.updated';
    }

    /**
     * Data yang di-broadcast ke client.
     */
    public function broadcastWith(): array
    {
        return [
            'action' => $this->action,
            'laporan' => $this->laporan,
        ];
    }
}
