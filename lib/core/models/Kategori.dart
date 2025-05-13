import 'package:json_annotation/json_annotation.dart';

part 'Kategori.g.dart';

@JsonSerializable()
class Kategori {
  final int id;
  final String nama;
  final String deskripsi;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  Kategori({
    required this.id,
    required this.nama,
    required this.deskripsi,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) => _$KategoriFromJson(json);
  Map<String, dynamic> toJson() => _$KategoriToJson(this);
}
