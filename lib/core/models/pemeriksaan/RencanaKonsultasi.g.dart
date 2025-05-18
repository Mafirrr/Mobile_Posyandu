// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RencanaKonsultasi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RencanaKonsultasi _$RencanaKonsultasiFromJson(Map<String, dynamic> json) =>
    RencanaKonsultasi(
      id: (json['id'] as num).toInt(),
      rencanaKonsultasiLanjut:
          (json['rencana_konsultasi_lanjut'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      rencanaProsesMelahirkan: json['rencana_proses_melahirkan'] as String,
      pilihanKontrasepsi: json['pilihan_kontrasepsi'] as String,
      kebutuhanKonseling: json['kebutuhan_konseling'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
    );

Map<String, dynamic> _$RencanaKonsultasiToJson(RencanaKonsultasi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rencana_konsultasi_lanjut': instance.rencanaKonsultasiLanjut,
      'rencana_proses_melahirkan': instance.rencanaProsesMelahirkan,
      'pilihan_kontrasepsi': instance.pilihanKontrasepsi,
      'kebutuhan_konseling': instance.kebutuhanKonseling,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt,
    };
