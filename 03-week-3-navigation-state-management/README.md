# Laporan Praktikum Minggu 3
**Nama:** Raihan Daffa Izzuddin
**NIM:** 244107020113

---

## Tujuan Proyek
Proyek ini adalah implementasi dari Mini Project untuk membangun aplikasi ToDo menggunakan Flutter.

## Fitur Utama
- **Manajemen State Terpusat:** Menggunakan Riverpod (`AsyncNotifierProvider` dan `Provider` turunan) untuk mengelola daftar ToDo dan filter data.
- **Navigasi Terstruktur:** Menggunakan `GoRouter` dengan `ShellRoute` untuk menerapkan `NavigationBar` tanpa memuat ulang seluruh halaman (mendukung rute `/` dan `/stats`).
- **Penanganan State Asinkron:** Menggunakan `AsyncValue.when()` di halaman statistik untuk menangani kondisi *loading* (spinner), *error* (pesan dan tombol *retry*), serta *success* (data *list*) secara elegan.
- **Refactoring Komponen:** Ekstraksi UI ke dalam *widget* terpisah (`TodoTile`) untuk menjaga fungsi `build` tetap ringkas dan modular.

---

## AI Prompt Challenge

### 1. Prompt Pembuatan State Management & UI Asinkron
**Prompt:** *"Buatkan halaman Flutter bernama StatsPage menggunakan flutter_riverpod. Requirements: ConsumerWidget dengan satu AsyncNotifierProvider yang mensimulasikan pengambilan data statistik (delay 2 detik, kadang gagal 30%). UI harus menangani loading, error, dan success. Berikan unit test untuk notifier-nya."*

**Output AI:**
AI menghasilkan kode yang menggunakan `AsyncNotifierProvider` untuk logika `StatsNotifier` dan `StatsPage` dengan struktur `.when()` untuk merender status `loading`, `error`, dan `data`. AI juga menyertakan unit test menggunakan `ProviderContainer` untuk memverifikasi transisi state asinkron.

**Keputusan & Alasan Teknis:**
Saya mengadopsi kode tersebut namun memutuskan untuk memisahkan file `stats_provider.dart` dan `stats_page.dart` agar sesuai dengan prinsip pemisahan. Perbaikan *import path* kemudian dilakukan pada file test agar pengujian dapat berjalan dengan sukses. Kriteria *AI Verification Checklist* juga berhasil diverifikasi.

---

## Refleksi

### 1. Kapan `setState` masih cukup, dan kapan state harus naik ke Riverpod?
`setState` masih cukup digunakan untuk state lokal UI yang bersifat sementara dan tidak berdampak pada bagian aplikasi lain, seperti animasi, *toggle dropdown*, atau input *form* sederhana. State harus dinaikkan ke Riverpod ketika data tersebut perlu diakses atau dimodifikasi oleh berbagai halaman yang berbeda, melibatkan proses asinkron/komunikasi API, atau saat logika bisnisnya mulai terlalu kompleks dan mengotori fungsi `build` pada antarmuka pengguna.

### 2. Apa perbedaan `context.go` dan `context.push`, dan kapan masing-masing tepat digunakan?
`context.go` mengubah URL/lokasi aplikasi secara absolut dengan mengganti susunan *router tree* secara utuh. Ini tepat digunakan untuk navigasi tingkat atas, seperti berpindah antar tab di `NavigationBar`. Sementara itu, `context.push` menumpuk halaman baru di atas halaman saat ini di dalam *navigation stack*. Ini cocok digunakan saat masuk ke halaman detail (seperti melihat detail dari satu tugas), sehingga pengguna bisa menggunakan tombol bawaan "Kembali" untuk kembali ke layar sebelumnya.

### 3. Bagaimana `AsyncValue` mencegah bug dibanding tiga boolean terpisah?
Jika menggunakan tiga boolean terpisah (`isLoading`, `hasError`, `hasData`), rentan terjadi kondisi yang tidak masuk akal akibat kelalaian pengembang (misalnya, nilai `isLoading` adalah `true` sekaligus `hasData` bernilai `true`). `AsyncValue` melalui fungsi `.when()` secara bawaan memaksa aplikasi untuk hanya berada pada satu kondisi dan memastikan kita tidak pernah melewatkan penanganan status apa pun di UI.

### 4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?
Saya memperbaiki struktur file dengan memecah kode gabungan dari AI menjadi dua file berbeda: `stats_provider.dart` dan `stats_page.dart`. Perbaikan *import path* kemudian disesuaikan di file pengujian (`stats_notifier_test.dart`) agar variabel global provider dapat dikenali .
