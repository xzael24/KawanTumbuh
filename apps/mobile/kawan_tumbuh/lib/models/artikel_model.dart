/// Kategori artikel yang tersedia.
enum ArtikelKategori { semua, polaAsuh, disgrafia, disleksia, diskalkulia }

extension ArtikelKategoriExt on ArtikelKategori {
  String get label {
    switch (this) {
      case ArtikelKategori.semua:
        return 'Semua';
      case ArtikelKategori.polaAsuh:
        return 'Pola Asuh';
      case ArtikelKategori.disgrafia:
        return 'Disgrafia';
      case ArtikelKategori.disleksia:
        return 'Disleksia';
      case ArtikelKategori.diskalkulia:
        return 'Diskalkulia';
    }
  }
}

/// Model data satu artikel.
class ArtikelModel {
  const ArtikelModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tanggal,
    required this.imagePath,
    required this.isi,
  });

  final String id;
  final String judul;
  final ArtikelKategori kategori;
  final DateTime tanggal;
  final String imagePath;
  final String isi;
}
