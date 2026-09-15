# Laporan Praktikum Minggu 2
**Nama:** Raihan Daffa Izzuddin
**NIM:** 244107020113

---

## AI Prompt Challenge

### 1. Prompt Desain
Prompt: *"Bandingkan dua tata letak dashboard akademik untuk Flutter: versi GridView dan versi LayoutBuilder + Column. Jelaskan trade-off responsif dan aksesibilitasnya."*

Output AI:
*   Versi GridView: Sangat efisien untuk menampilkan item berukuran seragam. Otomatis menyediakan fitur *scroll* dan kodenya lebih bersih. Trade-off: Kurang fleksibel jika kartu informasi membutuhkan ukuran atau rasio yang sangat berbeda satu sama lain. Secara aksesibilitas, screen reader membacanya secara berurutan dengan sangat baik.
*   Versi LayoutBuilder + Column (berisi Row): Memungkinkan kontrol piksel yang sangat presisi dan pembagian rasio lebar yang kompleks (misal 70:30).*Trade-off: Kodenya lebih berulang, wajib dibungkus manual dengan SingleChildScrollView agar tidak overflow, dan jika tidak hati-hati, screen reader bisa melompat-lompat saat membaca elemen bertingkat.

Keputusan & Alasan Teknis:
Saya memilih menggunakan keduanya, yaitu menggunakan LayoutBuilder + GridView.count. Alasannya: halaman Academic Overview ini memiliki struktur kartu yang sama, jadi GridView adalah pilihan paling bagus. LayoutBuilder bertugas mengganti jumlah kolom (1 kolom untuk layar sempit, 2 kolom untuk layar lebar) berdasarkan maxWidth >= 700.

---

### 2. Prompt Penguatan Konsep
**Prompt:** *"Jelaskan kapan penggunaan Expanded justru menyebabkan overflow/error di dalam Row, beri contoh kode yang gagal dan perbaikannya."*

**Output AI:**
Penggunaan Expanded di dalam Row berfungsi untuk mengambil sisa ruang yang tersedia. Tapiakan menyebabkan error layout jika Row tersebut dibungkus oleh parent yang memperbolehkan ukurannya melebar tanpa batas secara horizontal.

## Refleksi

### 1. Apa perbedaan cara berpikir imperative dan declarative saat membangun UI?
Pendekatan imperative mengharuskan kita memberi instruksi manual step by step untuk mengubah elemen UI. Sebdangkan, pendekatan declarative hanya mendeskripsikan tampilan UI berdasarkan kondisi state saat ini, sehingga sistem akan otomatis menggambar ulang layar ketika state tersebut berubah.

### 2. Kapan Expanded membantu dan kapan penggunaannya justru menghasilkan layout error?
Widget ini sangat membantu untuk mengisi sisa ruang kosong jika diletakkan di dalam widget Flex seperti Row atau Column. Namun, Expanded justru akan menghasilkan error jika ditempatkan di dalam parent.

### 3. Bagaimana breakpoint dan theme memengaruhi pengalaman pengguna?
Breakpoint membuat aplikasi responsif karena tata letaknya beradaptasi dengan ukuran perangkat, seperti membagi ruang menjadi 2 kolom di layar lebar. Sementara itu, theme memastikan konsistensi visual, khususnya dengan menyediakan perubahan ke mode gelap dan ukuran teks yang menyesuaikan dengan pengaturan perangkat pengguna.

  
### 4. Apa yang Anda verifikasi dari rekomendasi AI setelah tugas inti selesai?
Setelah tugas intinya selesai, Saya memverifikasi penggabungan LayoutBuilder dan GridView bisa tetap responsif dan aman untuk layar HP.