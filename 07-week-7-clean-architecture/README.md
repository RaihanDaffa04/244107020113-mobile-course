# Laporan Praktikum Minggu 7 - Clean Architecture
**Nama:** Raihan Daffa Izzuddin
**NIM:** 244107020113

---

## Tujuan Proyek
Proyek ini merupakan pengembangan lanjutan dari laporan minggu sebelumnya. Minggu ini fokus pada penerapan *clean architecture* untuk aplikasi catatan offline. Tujuan utama dari proyek ini adalah membangun aplikasi Flutter yang mampu menyimpan data lokal secara aman, terstruktur, dan dapat diuji tanpa bergantung pada database eksternal atau layer UI.

---

## Stack Teknologi
- **Framework:** Flutter
- **State Management:** Flutter Riverpod
- **Local Database:** SQLite / Sqflite
- **Routing:** GoRouter
- **Testing:** Flutter Test
- **Arsitektur:** Clean Architecture + Repository Pattern + Use Case
- **Persistence:** Local storage untuk cache dan data catatan

---

## Fitur Utama
- **Catatan offline:** data disimpan secara lokal di SQLite agar aplikasi tetap bisa dipakai saat tidak ada koneksi.
- **Arsitektur berlapis:** pemisahan antara `domain`, `data`, dan `presentation` agar logika bisnis tidak tercampur dengan UI.
- **Repository abstraction:** antarmuka repository didefinisikan di layer domain, sedangkan implementasinya di layer data.
- **Use case domain:** operasi seperti `GetNotes` dan `AddNote` diambil dari layer use case agar business logic tetap bersih.
- **Penanganan failure terpusat:** exception dan error lokal dibungkus dalam model `Failure` agar pesan user lebih ramah dan konsisten.
- **Provider Riverpod:** state UI dikontrol melalui provider agar lebih mudah di-test dan lebih modular.
- **Sinkronisasi catatan:** aplikasi mampu menandai note yang belum tersinkron dan melakukan sinkronisasi secara terstruktur.
- **Test domain murni:** pengujian dilakukan tanpa bergantung pada SQLite, Dio, atau Firebase, sesuai prinsip domain-driven testing.

---

## Struktur Arsitektur
Struktur proyek dibagi menjadi beberapa layer:

- **domain/**
  - `entities/` untuk model domain seperti `Note`
  - `repositories/` untuk interface repository
  - `usecases/` untuk use case seperti `GetNotes`, `AddNote`

- **data/**
  - `models/` untuk model data SQL/local
  - `repositories/` untuk implementasi repository

- **presentation/**
  - `pages/` untuk halaman UI
  - `providers/` untuk Riverpod provider

- **core/**
  - `failures.dart` untuk kelas error terpusat
  - `format.dart` untuk helper formatting data


## AI Prompt Challenge

### 1. Prompt AI
**Prompt:**
*"Project Flutter saya: campus_note app, offline-first. Buatkan struktur clean architecture untuk feature notes dengan domain, data, presentation. Gunakan Riverpod, repository interface, use case, dan unit test domain murni. Pastikan `GetNotes` dan `AddNote` tidak mengandalkan SQLite/Dio/Firebase di layer domain. Tolong buat juga fake repository untuk test success dan failure."*

**Output AI:**
AI menghasilkan struktur awal untuk `domain`, `data`, dan `presentation`, serta rancangan repository interface serta fake repository untuk pengujian.

---

## Refleksi

### 1. Mengapa interface repository harus tinggal di domain, bukan di data?
Karena domain adalah inti bisnis aplikasi. Interface repository harus didefinisikan di domain agar use case dan logika bisnis tidak tergantung pada detail implementasi database atau framework. Jika interface diletakkan di data, maka domain menjadi terikat pada teknologi tertentu, yang bertentangan dengan prinsip clean architecture.

### 2. Kapan use case benar-benar dibutuhkan, dan kapan repository langsung cukup?
Use case dibutuhkan ketika ada logika bisnis yang lebih kompleks, seperti validasi, transformasi data, atau aturan domain tertentu. Jika hanya sekadar membaca dan menulis data tanpa logika tambahan, repository langsung mungkin cukup. Namun untuk aplikasi yang lebih besar, use case sangat membantu menjaga logika tetap terorganisir.

### 3. Apa yang rusak jika UI langsung mengakses SQLite atau Dio?
UI akan tercampur dengan detail teknis seperti query database, request HTTP, dan error handling. Akibatnya, kode jadi sulit diuji, sulit dipelihara, dan sulit dikembangkan ke skala yang lebih besar. Prinsip pemisahan concern akan hilang.

### 4. Bagian mana yang saya perbaiki dari hasil AI, dan mengapa?
Saya memperbaiki struktur kontrak repository agar hasil domain dibuat dalam bentuk `({ notes, failure })`, bukan `List<Note>`. Hal ini penting agar pengujian domain tetap murni dan tidak bergantung pada SQLite atau Dio. 

### 5. Apa yang saya pelajari dari minggu ini?
Saya belajar bahwa clean architecture bukan hanya membagi folder, tetapi tentang menjaga dependency arah yang benar. Domain harus tetap menjadi pusat logika bisnis, data hanya implementasi, dan UI hanya tampilan. 
