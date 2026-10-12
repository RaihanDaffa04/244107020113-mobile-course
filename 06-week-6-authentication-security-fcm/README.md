# Laporan Praktikum Minggu 6 - Authentication, Security, dan FCM

**Nama:** Raihan Daffa Izzuddin  
**NIM:** 244107020113

---

## Tujuan Proyek

Membangun Campus Notify, aplikasi Flutter yang menggabungkan login dengan route guard, penyimpanan token secara aman, dan Firebase Cloud Messaging (FCM) untuk menerima notifikasi pengumuman kampus serta membuka halaman tujuan.

## Stack Teknologi

- **Framework:** Flutter dan Dart
- **State management:** Flutter Riverpod
- **Routing:** GoRouter
- **HTTP client:** Dio
- **Penyimpanan token autentikasi:** `flutter_secure_storage`
- **Push notification:** Firebase Core dan Firebase Messaging
- **Notifikasi lokal:** `flutter_local_notifications`
- **Testing:** Flutter Test

## Fitur Utama

- Route guard mengarahkan pengguna yang belum login ke `/login` dan mempertahankan route tujuan setelah autentikasi.
- Token access dan refresh disimpan melalui secure storage.
- Dio menambahkan access token pada request dan mencoba memperbarui access token ketika menerima HTTP 401.
- Aplikasi meminta permission, membaca token FCM, memantau `onTokenRefresh`, dan mendaftarkan token melalui `POST /devices` dengan platform perangkat.
- Home menampilkan hanya 12 karakter awal token FCM. Token penuh tidak ditampilkan atau dicetak ke log.
- Aplikasi dapat subscribe dan unsubscribe dari topic `pengumuman-kampus`.
- Foreground message ditampilkan melalui local notification; tap notification dan pesan dari background/terminated diproses untuk membuka route dari payload.
- Parser route FCM dan pemetaan error Dio berada di fungsi/utilitas terpisah agar dapat diuji.


## AI Prompt Challenge

### 1. Prompt AI

**Prompt:**

 Buatkan PushService untuk aplikasi Flutter Campus Notify menggunakan `firebase_messaging`, `flutter_local_notifications`, `flutter_secure_storage`, GoRouter, Riverpod, dan Dio. Fitur yang diperlukan: meminta permission notifikasi; mengambil token FCM dan mengirim token awal serta token baru dari `onTokenRefresh` ke `POST /devices`; menampilkan local notification saat foreground; membuka route dari `onMessageOpenedApp` dan `getInitialMessage`; menyediakan subscribe/unsubscribe topic `pengumuman-kampus`; serta mendaftarkan background handler top-level dengan `@pragma('vm:entry-point')`. Handler background tidak boleh menggunakan `BuildContext` atau Riverpod. Tampilkan token hanya dalam bentuk terpotong dan jangan cetak token penuh ke log. Pisahkan parsing route payload dan pemetaan error Dio agar dapat diuji.

### 2. Output AI

AI memberikan kerangka service FCM untuk permission, token lifecycle, local notification foreground, deep link, topic, dan background handler. Kerangka tersebut menjadi titik awal, tetapi perlu disesuaikan sebelum digunakan: API plugin harus cocok dengan versi dependency di project, route harus terhubung ke GoRouter, dan endpoint backend harus memakai URL yang benar.

## Refleksi

### Mengapa refresh token tidak disimpan di SharedPreferences? Apa risikonya bila bocor?
Refresh token dapat dipakai untuk memperoleh access token baru dan biasanya berumur lebih panjang daripada access token. SharedPreferences bukan penyimpanan rahasia; token yang bocor dapat memungkinkan pihak lain mempertahankan akses tanpa mengetahui password. Karena itu, token disimpan melalui secure storage yang memakai fasilitas keamanan platform. Secure storage tetap bukan pengganti TLS, pembatasan akses server, atau rotasi token.

### Apa yang rusak bila `onTokenRefresh` diabaikan?
FCM token dapat berubah, misalnya setelah instalasi ulang atau rotasi token. Jika token baru tidak dikirim ke backend, server masih menyimpan token lama dan notifikasi yang ditargetkan ke perangkat dapat gagal atau dikirim ke token yang sudah tidak berlaku.

### Kapan memakai topic dan kapan memakai token perangkat?
Topic dipakai untuk broadcast ke kelompok, misalnya pengumuman jadwal untuk semua mahasiswa yang berlangganan `pengumuman-kampus`. Token perangkat dipakai untuk pesan personal, misalnya pemberitahuan status administrasi kepada satu pengguna. Data personal tidak seharusnya dikirim melalui topic umum.

### Bagian mana dari draft AI diperbaiki dan mengapa?
Draft disesuaikan dengan API versi dependency yang benar-benar dipakai, termasuk bentuk named parameters pada `flutter_local_notifications`. Route payload dipusatkan agar dipakai bersama oleh GoRouter dan FCM, parsing payload dipisahkan sebagai fungsi murni, dan token tidak dicetak penuh ke log. Handler background dibuat top-level karena dipanggil di isolate terpisah dan tidak menggunakan `BuildContext` atau Riverpod. 