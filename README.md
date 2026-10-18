# Ruang Usaha

UMKM Smart Assistant dengan desain Material 3, warna hijau hutan dan lime,
serta tata letak adaptif untuk ponsel dan layar lebar. Mendukung Android dan web.

## Menjalankan

```sh
flutter pub get
flutter run
```

Untuk membuka aplikasi di Chrome:

```sh
flutter run -d chrome --web-hostname 127.0.0.1 --web-port 51234
```

Data versi web disimpan di browser untuk alamat dan port tersebut.

Aplikasi langsung membuka ruang demo Kafe Ayem. Untuk memulai data sendiri,
buka **Usaha → Mulai usaha sendiri**, isi identitas, lalu konfirmasikan penghapusan
data contoh. Versi ini menggunakan ruang kerja lokal tanpa akun server.

## Fitur

- Dashboard: omzet, laba, biaya, grafik 7 hari, target bulanan, dan peringatan stok.
- Katalog: pencarian, kategori, filter stok, pengurutan, tambah/edit/hapus,
  harga modal, margin, dan pengisian stok.
- Kasir: keranjang beberapa produk, validasi stok sebelum seluruh transaksi disimpan,
  pencatatan Tunai/QRIS/Transfer, dan bukti penjualan yang dapat disalin.
- Pengeluaran dengan kategori dan tanggal; riwayat dapat dicari dan difilter.
- Analisis per hari, 7 hari, atau bulan berjalan; produk terlaris, komposisi pembayaran,
  rincian laba, dan laporan yang dapat disalin sebagai ringkasan atau CSV.
- Studio promosi berbasis template offline dengan variasi draf dan salin ke clipboard.
- Profil usaha, pusat perhatian yang mengikuti stok aktual, dan panduan penggunaan.

## Data dan batas penggunaan

Data disimpan sebagai snapshot JSON melalui `SharedPreferencesAsync` di perangkat.
Penulisan diantrekan agar snapshot lama tidak menimpa perubahan baru. Kegagalan
menyimpan ditampilkan di aplikasi; kegagalan membaca menghentikan pembukaan ruang
kerja agar data sebelumnya tidak tertimpa.

Penyimpanan ini ditujukan untuk prototipe/pencatatan lokal ringan, belum menjadi
database transaksi produksi. Tidak ada sinkronisasi cloud, pemrosesan pembayaran,
login online, atau layanan AI eksternal. CSV adalah salinan laporan, bukan cadangan
yang dapat dipulihkan otomatis. Pemakaian produksi memerlukan database transaksi,
backup/restore, serta autentikasi dan sinkronisasi sesuai kebutuhan.

Laba = **omzet − modal produk terjual − pengeluaran**. Pengisian stok hanya menambah
persediaan. Hindari mencatat biaya modal yang sama sebagai pengeluaran lagi.

## Struktur

- `lib/main.dart`: tema, aplikasi, dan navigasi adaptif.
- `lib/data/store.dart`: model, perhitungan periode, transaksi, dan penyimpanan.
- `lib/ui/`: komponen visual dan halaman aplikasi.
- `test/`: pengujian persediaan, keuangan, penyimpanan, dan alur antarmuka.

## Verifikasi

```sh
flutter analyze
flutter test
flutter build apk --debug
```
