import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Mendeklarasikan Provider global untuk StatsNotifier.
// Kita menggunakan AsyncNotifierProvider karena fungsi kita mengembalikan tipe Future (asinkron).
// Tipe datanya adalah List<String> yang akan menampung teks statistik.
final statsProvider = AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);

// 2. Membuat kelas Notifier yang mengatur siklus hidup data.
class StatsNotifier extends AsyncNotifier<List<String>> {
  
  // 3. Fungsi build() adalah fungsi utama yang dijalankan pertama kali.
  // Fungsi ini otomatis mengatur state menjadi 'loading' saat mulai berjalan.
  @override
  Future<List<String>> build() async {
    // 4. Menyimulasikan jeda jaringan (loading) selama 2 detik.
    await Future.delayed(const Duration(seconds: 2));

    // 5. Membuat probabilitas kegagalan sebesar 30% menggunakan nilai acak (Random).
    // nextDouble() menghasilkan angka desimal dari 0.0 hingga 1.0.
    final isError = Random().nextDouble() < 0.3;
    
    // 6. Jika angka acak di bawah 0.3 (masuk ke dalam 30%), kita paksa lemparkan galat (error).
    // Ini otomatis mengubah status Riverpod menjadi 'error'.
    if (isError) {
      throw Exception('Gagal mengambil data statistik dari server.');
    }

    // 7. Jika melewati blok if di atas (70% peluang sukses), kembalikan daftar data.
    // Ini otomatis mengubah status Riverpod menjadi 'data' (sukses).
    return [
      'Total Pengunjung: 15.420',
      'Pendapatan: Rp 12.500.000',
      'Tingkat Konversi: 4.2%',
    ];
  }
}