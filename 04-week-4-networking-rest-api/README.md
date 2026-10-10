# Laporan Praktikum Minggu 4 - Networking & REST API
**Nama:** Raihan Daffa Izzuddin
**NIM:** 244107020113

---

## Tujuan Proyek
Proyek ini adalah implementasi aplikasi mobile berbasis Flutter untuk mengambil, mengelola, dan menampilkan data dari REST API publik dengan menerapkan arsitektur repository, manajemen state Riverpod, penanganan error jaringan terpusat, serta pengujian unit test.

---

## Stack Teknologi
- **Framework:** Flutter
- **State Management:** Flutter Riverpod
- **Networking / HTTP Client:** Dio
- **Routing:** GoRouter
- **Testing:** Flutter Test
- **Sumber Data (API):** JSONPlaceholder 

---

## Fitur Utama
- **Integrasi REST API:** Menggunakan **Dio** dengan konfigurasi dasar URL, *timeout*, dan *interceptor* logging untuk melakukan komunikasi HTTP yang aman dan terstruktur.
- **Manajemen State Menggunakan Riverpod:** Mengelola state data pos, pemuatan halaman, dan penanganan error secara reaktif dan terpisah dari lapisan UI.
- **Model Aman dari Null (`fromJson`):** Pemetaan data JSON ke model Dart yang tangguh terhadap field yang hilang atau tidak lengkap.
- **Penanganan State:** Mendukung berbagai kondisi tampilan aplikasi mulai dari *loading* (indikator putar), *error* (pesan ramah pengguna beserta tombol *retry*), *empty* (data kosong), hingga *success* (daftar data).
- **Navigasi GoRouter :** Menggunakan `GoRouter` untuk navigasi halaman detail post (`/post/:id`) serta pemisahan komponen antarmuka ke dalam *widget* (`PostTile`).
- **Pengujian Unit & Provider (Testing):** Dilengkapi dengan unit test untuk pemetaan model, pemetaan error jaringan, serta pengujian provider menggunakan *repository* palsu (`FakePostRepository`).

---

## AI Prompt Challenge

### 1. Prompt AI
**Prompt:** *"Buatkan implementasi provider dan unit test untuk aplikasi Flutter menggunakan flutter_riverpod dan Dio. Requirements: Sediakan FakePostRepository untuk menguji kondisi sukses dan error (DioException), serta unit test untuk memvalidasi pemetaan model fromJson dan friendlyErrorMessage."*

**Output AI:**
AI menghasilkan kerangka kode `FakePostRepository`, fungsi pengujian `ProviderContainer` dengan *overrides*, serta pengujian penanganan error jaringan dan *parsing* model `Post`.

**Keputusan & Alasan Teknis:**
Saya menyesuaikan struktur direktori kode hasil AI agar sesuai dengan pola arsitektur proyek (pemisahan folder *models*, *providers*, *repositories*, dan *widgets*).

---

## Refleksi

### 1. Mengapa UI dilarang memanggil Dio langsung? Apa yang rusak jika aturan ini dilanggar?
UI dilarang memanggil `Dio` secara langsung untuk menjaga prinsip *Separation of Concerns* (pemisahan tanggung jawab). Jika aturan ini dilanggar, lapisan antarmuka pengguna akan tercampur dengan logika bisnis dan detail jaringan. Akibatnya, kode menjadi sulit diuji, sulit dirawat, dan ketika terjadi perubahan pada endpoint API atau pustaka HTTP, kita harus merombak banyak komponen UI satu persatu.

### 2. Kapan pagination client-side cukup, dan kapan harus mengandalkan pagination server (`_page` / `_limit`)?
Pagination *client-side* cukup digunakan jika jumlah total data keseluruhan dari server sangat sedikit dan ukuran payload-nya kecil, sehingga aman dimuat sekaligus ke memori perangkat. Sebaliknya, kita wajib mengandalkan pagination server ketika jumlah data sangat besar (mencapai ratusan atau ribuan data) untuk menghemat penggunaan memori, mempercepat waktu muat awal, dan mengurangi penggunaan bandwidth kuota pengguna.

### 3. Bagaimana exception repository berubah menjadi `AsyncError` tanpa try/catch di setiap widget?
Hal tersebut dapat terjadi karena Riverpod  secara otomatis membungkus eksekusi fungsi asinkron ke dalam blok pengaman internal. Ketika fungsi di *repository* melempar exception (seperti `DioException`), Riverpod menangkap error tersebut secara otomatis di balik layar dan mengubah status state provider menjadi `AsyncError`.

### 4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?
Saya memperbaiki bagian struktur penamaan file test dan penyesuaian parameter pada `ProviderContainer`. Hal ini dilakukan karena struktur direktori pada proyek ini memerlukan jalur impor yang spesifik agar helper fungsi pembaca state (`readPostsOnce`) dan class tiruan `FakePostRepository` dapat dikenali `flutter_test`.