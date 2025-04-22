class Artikel {
  final String judul;
  final String isi;
  final String gambar;
  final DateTime createdAt;

  Artikel({
    required this.judul,
    required this.isi,
    required this.gambar,
    required this.createdAt,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      judul: json['judul'],
      isi: json['isi'],
      gambar: json['gambar'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
