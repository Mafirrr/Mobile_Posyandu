// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Kategori.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kategori _$KategoriFromJson(Map<String, dynamic> json) => Kategori(
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String,
      deskripsi: json['deskripsi'] as String,
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

Map<String, dynamic> _$KategoriToJson(Kategori instance) => <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'deskripsi': instance.deskripsi,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
