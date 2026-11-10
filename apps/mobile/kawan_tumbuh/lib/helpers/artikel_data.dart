import '../models/artikel_model.dart';
import '../core/constants/app_assets.dart';

/// Data dummy artikel — ganti dengan API call nanti.
final List<ArtikelModel> dummyArtikel = [
  ArtikelModel(
    id: '1',
    judul: '5 Cara Sederhana Melatih Membaca Di Rumah',
    kategori: ArtikelKategori.disleksia,
    tanggal: DateTime(2026, 11, 12),
    imagePath: AppAssets.artikelDyslexia,
    isi:
        'Membaca adalah keterampilan dasar yang sangat penting bagi perkembangan anak. '
        'Bagi anak dengan disleksia, proses belajar membaca bisa menjadi tantangan tersendiri. '
        'Namun dengan pendekatan yang tepat dan konsisten, orang tua dapat membantu anak '
        'mengembangkan kemampuan membaca di rumah.\n\n'
        '1. Gunakan kartu huruf berwarna-warni\n'
        'Kartu huruf membantu anak mengenali bentuk huruf secara visual dan taktil.\n\n'
        '2. Baca bersama setiap hari\n'
        'Luangkan 15–20 menit setiap hari untuk membaca buku bergambar bersama.\n\n'
        '3. Gunakan aplikasi membaca interaktif\n'
        'Teknologi dapat membantu pembelajaran yang menyenangkan.\n\n'
        '4. Berikan pujian dan apresiasi\n'
        'Setiap kemajuan kecil perlu dirayakan untuk menjaga motivasi anak.\n\n'
        '5. Konsultasi dengan terapis\n'
        'Jika kesulitan berlanjut, segera konsultasikan dengan terapis bicara atau pendidikan khusus.',
  ),
  ArtikelModel(
    id: '2',
    judul: 'Latihan Motorik Halus Untuk Anak Disgrafia',
    kategori: ArtikelKategori.disgrafia,
    tanggal: DateTime(2026, 11, 12),
    imagePath: AppAssets.artikelDysgraphia,
    isi:
        'Disgrafia adalah kesulitan belajar yang mempengaruhi kemampuan menulis. '
        'Latihan motorik halus secara rutin dapat membantu anak mengatasi tantangan ini.\n\n'
        'Aktivitas yang dapat dilakukan:\n\n'
        '• Mewarnai dalam batas garis\n'
        '• Memotong kertas dengan gunting\n'
        '• Merangkai manik-manik\n'
        '• Bermain lilin atau tanah liat\n'
        '• Latihan menelusuri pola titik-titik\n\n'
        'Lakukan latihan ini secara konsisten 10–15 menit setiap hari.',
  ),
  ArtikelModel(
    id: '3',
    judul: 'Mengenalkan Konsep Angka Dengan Cara Menyenangkan',
    kategori: ArtikelKategori.diskalkulia,
    tanggal: DateTime(2026, 11, 12),
    imagePath: AppAssets.artikelDyscalculia,
    isi:
        'Diskalkulia membuat anak kesulitan memahami konsep angka dan matematika. '
        'Namun belajar bisa tetap menyenangkan dengan pendekatan yang kreatif.\n\n'
        'Tips mengenalkan angka:\n\n'
        '• Gunakan benda nyata seperti buah, kelereng, atau mainan\n'
        '• Nyanyikan lagu berhitung bersama\n'
        '• Gunakan permainan papan sederhana\n'
        '• Buat aktivitas memasak bersama dengan takaran\n'
        '• Hitung benda-benda di sekitar rumah\n\n'
        'Kunci utamanya adalah kesabaran dan konsistensi.',
  ),
  ArtikelModel(
    id: '4',
    judul: 'Pentingnya Dukungan Orang Tua Dalam Terapi Anak',
    kategori: ArtikelKategori.polaAsuh,
    tanggal: DateTime(2026, 11, 12),
    imagePath: AppAssets.artikelPolaAsuh,
    isi:
        'Dukungan orang tua adalah faktor terpenting dalam keberhasilan terapi anak. '
        'Penelitian menunjukkan bahwa anak-anak yang mendapat dukungan penuh dari orang tua '
        'menunjukkan kemajuan yang lebih signifikan dalam terapi.\n\n'
        'Bagaimana orang tua bisa mendukung:\n\n'
        '• Hadir dan aktif dalam sesi terapi\n'
        '• Terapkan saran terapis di rumah\n'
        '• Jaga komunikasi positif dengan anak\n'
        '• Bergabung dalam komunitas orang tua\n'
        '• Jaga kesehatan mental diri sendiri\n\n'
        'Ingat, Anda tidak sendirian dalam perjalanan ini.',
  ),
];
