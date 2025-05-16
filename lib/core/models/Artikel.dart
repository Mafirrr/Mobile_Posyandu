import 'package:json_annotation/json_annotation.dart';

part 'Artikel.g.dart';

@JsonSerializable()
class Artikel {
  final int id;
  final String judul;
  final String slug;
  final String isi;
  final String gambar;

  @JsonKey(name: 'kategori_edukasi')
  final String kategoriEdukasi;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  Artikel({
    required this.id,
    required this.judul,
    required this.slug,
    required this.isi,
    required this.gambar,
    required this.kategoriEdukasi,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) => _$ArtikelFromJson(json);
  Map<String, dynamic> toJson() => _$ArtikelToJson(this);
}
