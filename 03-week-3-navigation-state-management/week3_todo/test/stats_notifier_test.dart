import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week3_todo/providers/stats_provider.dart'; 

void main() {
  group('StatsNotifier Tests', () {
    
    // Test Skenario 1: Memastikan status awal benar-benar 'loading'.
    test('State awal harus berupa AsyncLoading', () {
      // 1. Membuat ruang lingkup (container) khusus untuk menyimpan state selama test.
      final container = ProviderContainer();
      
      // 2. Membersihkan memori container setelah test ini selesai.
      addTearDown(container.dispose);

      // 3. Membaca status provider tepat di detik ke-0 (sebelum delay 2 detik selesai).
      final initialState = container.read(statsProvider);
      
      // 4. Memverifikasi bahwa status tersebut adalah AsyncLoading.
      expect(initialState, const AsyncValue<List<String>>.loading());
    });

    // Test Skenario 2: Memastikan status akhir bukan loading, melainkan sukses/gagal.
    test('State pada akhirnya harus berupa AsyncData atau AsyncError', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // 1. Kita 'menunggu' (await) masa depan (.future) dari provider ini selesai.
      try {
        // Baris ini akan berhenti selama 2 detik mengikuti delay di dalam fungsi build().
        await container.read(statsProvider.future);
      } catch (_) {
        // 2. Blok catch dibiarkan kosong karena kita membiarkan error terjadi.
        // Ingat, provider kita memiliki peluang gagal 30%, jadi wajar jika masuk ke catch ini.
      }

      // 3. Membaca status terbaru provider setelah proses asinkronnya selesai/gagal.
      final finalState = container.read(statsProvider);

      // 4. Mengecek apakah statusnya memiliki nilai (sukses) ATAU memiliki galat (error).
      final hasFinished = finalState.hasValue || finalState.hasError;
      
      // 5. Memastikan bahwa proses asinkron telah benar-benar selesai.
      expect(
        hasFinished, 
        true, 
        reason: 'Provider harus menyelesaikan loading dan berubah menjadi data atau error.',
      );
      
      // 6. Verifikasi tambahan: memastikan state saat ini sudah BUKAN loading lagi.
      expect(finalState.isLoading, false);
    });
  });
}