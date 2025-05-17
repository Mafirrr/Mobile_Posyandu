// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Artikel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artikel _$ArtikelFromJson(Map<String, dynamic> json) => Artikel(
      id: (json['id'] as num).toInt(),
      judul: json['judul'] as String,
      slug: json['slug'] as String,
      isi: json['isi'] as String,
      gambar: json['gambar'] as String,
      kategoriEdukasi: json['kategori_edukasi'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$ArtikelToJson(Artikel instance) => <String, dynamic>{
      'id': instance.id,
      'judul': instance.judul,
      'slug': instance.slug,
      'isi': instance.isi,
      'gambar': instance.gambar,
      'kategori_edukasi': instance.kategoriEdukasi,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
