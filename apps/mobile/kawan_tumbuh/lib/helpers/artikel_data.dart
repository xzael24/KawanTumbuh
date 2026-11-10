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
    detailImagePath: AppAssets.artikelDetailDisleksia,
    intro:
        'Melatih Anak Membaca Di Rumah Tidak Harus Kaku Atau Membosankan. '
        'Berikut Adalah Beberapa Cara Efektif, Praktis, Dan Menyenangkan Yang Dapat '
        'Diterapkan Sehari Buat Untuk Membangun Kelancaran Serta Minat Baca Anak:',
    poinPoin: [
      'Membangun Kesadaran Huruf & Bunyi',
      'Kegiatan Membaca Bersama (Shared Reading)',
      'Menciptakan Lingkungan Kaya Teks',
      'Permainan Kata Yang Menyenangkan',
    ],
    isi:
        'Membaca adalah keterampilan dasar yang sangat penting bagi perkembangan anak. '
        'Bagi anak dengan disleksia, proses belajar membaca bisa menjadi tantangan tersendiri. '
        'Namun dengan pendekatan yang tepat dan konsisten, orang tua dapat membantu anak '
        'mengembangkan kemampuan membaca di rumah.\n\n'
        '1. Membangun Kesadaran Huruf & Bunyi\n'
        'Kartu huruf membantu anak mengenali bentuk huruf secara visual dan taktil.\n\n'
        '2. Kegiatan Membaca Bersama (Shared Reading)\n'
        'Luangkan 15–20 menit setiap hari untuk membaca buku bergambar bersama.\n\n'
        '3. Menciptakan Lingkungan Kaya Teks\n'
        'Tempel label nama benda-benda di rumah agar anak terbiasa melihat tulisan.\n\n'
        '4. Permainan Kata Yang Menyenangkan\n'
        'Gunakan permainan tebak kata, puzzle huruf, atau aplikasi membaca interaktif.',
  ),
  ArtikelModel(
    id: '2',
    judul: 'Latihan Motorik Halus Untuk Anak Disgrafia',
    kategori: ArtikelKategori.disgrafia,
    tanggal: DateTime(2026, 11, 12),
    imagePath: AppAssets.artikelDysgraphia,
    detailImagePath: AppAssets.artikelDetailDisleksia,
    intro:
        'Disgrafia adalah kesulitan belajar yang mempengaruhi kemampuan menulis. '
        'Latihan motorik halus secara rutin dapat membantu anak mengatasi tantangan ini '
        'dan meningkatkan kemampuan menulis mereka secara bertahap:',
    poinPoin: [
      'Mewarnai dalam batas garis',
      'Memotong kertas dengan gunting',
      'Merangkai manik-manik',
      'Bermain lilin atau tanah liat',
    ],
    isi:
        'Disgrafia adalah kesulitan belajar yang mempengaruhi kemampuan menulis. '
        'Latihan motorik halus secara rutin dapat membantu anak mengatasi tantangan ini.\n\n'
        'Lakukan latihan ini secara konsisten 10–15 menit setiap hari untuk hasil terbaik.',
  ),
  ArtikelModel(
    id: '3',
    judul: 'Mengenalkan Konsep Angka Dengan Cara Menyenangkan',
    kategori: ArtikelKategori.diskalkulia,
    tanggal: DateTime(2026, 11, 12),
    imagePath: AppAssets.artikelDyscalculia,
    detailImagePath: AppAssets.artikelDetailDisleksia,
    intro:
        'Diskalkulia membuat anak kesulitan memahami konsep angka dan matematika. '
        'Namun belajar bisa tetap menyenangkan dengan pendekatan yang kreatif dan '
        'menggunakan benda-benda di sekitar anak:',
    poinPoin: [
      'Gunakan benda nyata seperti buah atau kelereng',
      'Nyanyikan lagu berhitung bersama',
      'Gunakan permainan papan sederhana',
      'Hitung benda-benda di sekitar rumah',
    ],
    isi:
        'Diskalkulia membuat anak kesulitan memahami konsep angka dan matematika. '
        'Kunci utamanya adalah kesabaran dan konsistensi dalam menerapkan metode belajar.',
  ),
  ArtikelModel(
    id: '4',
    judul: 'Pentingnya Dukungan Orang Tua Dalam Terapi Anak',
    kategori: ArtikelKategori.polaAsuh,
    tanggal: DateTime(2026, 11, 12),
    imagePath: AppAssets.artikelPolaAsuh,
    detailImagePath: AppAssets.artikelDetailDisleksia,
    intro:
        'Dukungan orang tua adalah faktor terpenting dalam keberhasilan terapi anak. '
        'Penelitian menunjukkan bahwa anak-anak yang mendapat dukungan penuh dari orang tua '
        'menunjukkan kemajuan yang lebih signifikan. Berikut cara mendukung anak:',
    poinPoin: [
      'Hadir dan aktif dalam sesi terapi',
      'Terapkan saran terapis di rumah',
      'Jaga komunikasi positif dengan anak',
      'Bergabung dalam komunitas orang tua',
    ],
    isi:
        'Dukungan orang tua adalah faktor terpenting dalam keberhasilan terapi anak. '
        'Ingat, Anda tidak sendirian dalam perjalanan ini.',
  ),
];
