# Laporan Praktikum Minggu 5 - Local Storage & Offline First
**Nama:** Raihan Daffa Izzuddin  
**NIM:** 244107020113

---

## Tujuan Proyek
Proyek ini adalah implementasi aplikasi mobile berbasis Flutter untuk membuat catatan offline yang dapat disimpan secara lokal di perangkat, dikelola dengan struktur data yang aman, dan tetap dapat dibaca kembali tanpa koneksi internet. Fokus utama pada konsep local-first storage, integrasi SQLite, serta pengelolaan state Riverpod agar aplikasi tetap responsif dan mudah dipelihara.

---

## Stack Teknologi
- **Framework:** Flutter
- **State Management:** Flutter Riverpod
- **Local Database:** SQLite via `sqflite`
- **Storage Lokal:** `SharedPreferences`
- **Routing:** GoRouter
- **Testing:** Flutter Test
- **Simulasi Sinkronisasi:** Dirty flag + sync queue

---

## Fitur Utama
- **Catatan Offline:** Menyimpan data catatan di database lokal agar tetap tersedia meskipun perangkat offline.
- **Model Aman dari Null:** Pemetaan data dari database ke model Dart yang aman terhadap field yang tidak lengkap atau kosong.
- **Penanganan State Riverpod:** State aplikasi seperti daftar catatan, status loading, serta kondisi error dikelola secara reaktif.
- **Dirty Flag untuk Sinkronisasi:** Setiap catatan yang berubah ditandai sebagai `dirty`, lalu dapat disinkronkan nanti saat koneksi tersedia.
- **Cache-First untuk Post / Data Tambahan:** Menggunakan pendekatan cache-first agar aplikasi tetap dapat menampilkan data saat offline dan memperbarui data dari jaringan saat kondisi memungkinkan.
- **Navigasi Halaman Detail:** Pengguna dapat membuka halaman detail catatan untuk melihat isi, memperbarui judul dan isi, serta melihat status sinkronisasi.
- **Pengujian Unit:** Dilengkapi dengan unit test untuk model `Note`, serialisasi `toMap` / `fromMap`, serta provider dengan repository palsu.

---

## AI Prompt Challenge

### 1. Prompt AI
**Prompt:**
 "Buatkan aplikasi Flutter Offline Notes dengan CRUD catatan dan preferensi tema. Bandingkan SharedPreferences, Hive, sqflite (SQLite), dan Drift untuk dua kebutuhan ini. Requirements:  
 - Kriteria: kompleksitas query, kebutuhan relasi, reaktivitas (stream), type-safety, ukuran boilerplate, dan kemudahan testing.  
 - Beri rekomendasi final: mana untuk preferences, mana untuk catatan, beserta alasannya dalam 1 tabel.  
 - Tunjukkan skema tabel/kotak untuk 1000+ catatan. Jelaskan trade-off setiap pilihan."

**Output AI:**
AI menghasilkan rekomendasi teknis yang membandingkan keempat solusi penyimpanan lokal dan mengarahkan pilihan terbaik untuk kebutuhan proyek: `SharedPreferences` untuk preferensi tema, `sqflite` untuk menyimpan catatan.

**Keputusan & Alasan Teknis:**
Saya menyesuaikan hasil AI agar sesuai : catatan bersifat structured dan jumlah data bisa tumbuh, sehingga SQLite lebih cocok dibandingkan `SharedPreferences` atau Hive untuk kebutuhan CRUD komplek. Model `Note` dibuat dengan field `id`, `title`, `body`, `updated_at`, dan `dirty` agar proses sinkronisasi dapat dilakukan dengan mudah.

---

## Refleksi

### 1. Mengapa daftar catatan tidak boleh disimpan di `SharedPreferences`? Apa yang rusak jika aturan ini dilanggar?
Karena `SharedPreferences` dirancang untuk data kecil dan sederhana seperti pengaturan aplikasi, bukan kumpulan data catatan yang bisa bertambah besar. Jika daftar catatan disimpan di sana, performa akan menurun, parsing data menjadi semakin berat, dan manajemen data seperti update, delete, serta pencarian akan sulit dijalankan dengan aman.

### 2. Kapan cache-first cukup, dan kapan harus menggunakan strategi lain (misalnya network-first untuk data harga real-time)?
Cache-first cocok ketika data utama bisa diakses secara lokal dan perubahan yang lebih baru bisa disinkronkan nanti. Strategi network-first lebih tepat jika data sangat dinamis, seperti harga saham, jadwal penerbangan, atau status pesanan yang harus selalu up-to-date dalam hitungan detik.

### 3. Bagaimana dirty flag berubah menjadi antrean sync tanpa memblokir UI?
Dirty flag dipasang setiap kali catatan diubah. Saat pengguna membuka halaman atau saat aplikasi idle, logika sinkronisasi dapat membaca catatan yang memiliki `dirty = 1`, mengirimkannya ke backend, lalu menandai kembali statusnya menjadi bersih setelah berhasil. Proses ini dilakukan secara async agar UI tetap responsif.

### 4. Bagian mana dari rekomendasi AI yang Anda tolak, dan mengapa?
Saya menolak sebagian yang terlalu umum dan tidak spesifik untuk kebutuhan catatan offline. Dalam aplikasi ini, pendekatan yang paling tepat adalah data catatan terstruktur di SQLite dengan `dirty flag`.
