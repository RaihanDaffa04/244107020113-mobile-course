# Laporan Praktikum Minggu 1
**Nama:** Raihan Daffa Izzuddin
**NIM:** 244107020113

---

## Refleksi

### 1. Kapan native lebih tepat dipilih daripada cross-platform?
  Pengembangan native lebih disarankan ketika aplikasi menuntut performa komputasi atau rendering grafis yang tinggi.

### 2. Bagaimana perubahan state berhubungan dengan widget tree dan UI deklaratif?
  Dalam UI deklaratif seperti Flutter, antarmuka adalah hasil pemetaan langsung dari sebuah *state*. Ketika nilai *state* berubah, *framework* akan memberi sinyal kepada *widget tree* untuk melakukan proses *rebuild* komponen yang terdampak. Pengembang tidak perlu memperbarui elemen layar secara manual satu per satu; cukup perbarui *state*-nya, dan Flutter secara efisien akan menggambar ulang *widget tree* agar UI sinkron dengan data terbaru.

### 3. Mengapa commit kecil dengan pesan jelas bermanfaat bagi pekerjaan tim dan portfolio?
  Dalam kolaborasi tim, *commit* berskala kecil memudahkan proses *code review*, meminimalisir konflik saat penggabungan kode, dan mempermudah pencarian serta pembatalan jika ditemukan *bug* pada fitur tertentu. 