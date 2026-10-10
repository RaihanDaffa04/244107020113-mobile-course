import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Ganti path ini jika lokasi file provider Anda berbeda
import '../providers/stats_provider.dart'; 

// 1. Menggunakan ConsumerWidget agar halaman ini bisa membaca state dari Riverpod.
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  // 2. Fungsi build wajib menerima parameter WidgetRef (ref) sebagai penghubung ke provider.
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Memantau (watch) perubahan status pada statsProvider.
    // Variabel statsAsync akan memiliki tipe AsyncValue (memiliki 3 cabang status).
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Statistik')),
      
      // 4. Menggunakan .when() untuk memaksa kita mendesain UI untuk ketiga kondisi asinkron.
      body: statsAsync.when(
        
        // Kondisi A: Saat fungsi build() di provider sedang menunggu jeda 2 detik.
        loading: () => const Center(
          child: CircularProgressIndicator(), // Tampilkan animasi putaran loading.
        ),
        
        // Kondisi B: Saat fungsi build() terkena probabilitas 30% dan melempar Exception.
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Terjadi Kesalahan:\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              FilledButton(
                // 5. Tombol 'Coba Lagi' memanggil ref.invalidate.
                // Invalidate akan membunuh memori state saat ini dan memerintahkan
                // provider untuk menjalankan ulang fungsi build() dari awal (kembali loading).
                onPressed: () => ref.invalidate(statsProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        
        // Kondisi C: Saat fungsi build() sukses (70%) dan mengembalikan List<String>.
        data: (stats) => ListView.builder(
          itemCount: stats.length, // Jumlah baris sesuai jumlah item di dalam list.
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.analytics),
                title: Text(stats[index]), // Menampilkan isi teks pada index tersebut.
              ),
            );
          },
        ),
      ),
    );
  }
}