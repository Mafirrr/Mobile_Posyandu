// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PemeriksaanKehamilan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PemeriksaanKehamilan _$PemeriksaanKehamilanFromJson(
        Map<String, dynamic> json) =>
    PemeriksaanKehamilan(
      id: (json['id'] as num).toInt(),
      kehamilanId: (json['kehamilan_id'] as num).toInt(),
      petugasId: (json['petugas_id'] as num).toInt(),
      tanggalPemeriksaan: DateTime.parse(json['tanggal_pemeriksaan'] as String),
      tempatPemeriksaan: json['tempat_pemeriksaan'] as String,
      jenisPemeriksaan: json['jenis_pemeriksaan'] as String,
    );

Map<String, dynamic> _$PemeriksaanKehamilanToJson(
        PemeriksaanKehamilan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kehamilan_id': instance.kehamilanId,
      'petugas_id': instance.petugasId,
      'tanggal_pemeriksaan': instance.tanggalPemeriksaan.toIso8601String(),
      'tempat_pemeriksaan': instance.tempatPemeriksaan,
      'jenis_pemeriksaan': instance.jenisPemeriksaan,
    };
