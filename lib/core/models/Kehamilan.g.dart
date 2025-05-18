// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Kehamilan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kehamilan _$KehamilanFromJson(Map<String, dynamic> json) => Kehamilan(
      id: (json['id'] as num).toInt(),
      anggotaId: (json['anggota_id'] as num).toInt(),
      status: json['status'] as String,
      label: json['label'] as String,
      berat_badan_bayi: json['berat_badan_bayi'] as String?,
      masalah: json['masalah'] as String?,
      penolong: json['penolong'] as String?,
      proses_melahirkan: json['proses_melahirkan'] as String?,
      tahun: json['tahun'] as String?,
    );

Map<String, dynamic> _$KehamilanToJson(Kehamilan instance) => <String, dynamic>{
      'id': instance.id,
      'anggota_id': instance.anggotaId,
      'status': instance.status,
      'label': instance.label,
      'tahun': instance.tahun,
      'berat_badan_bayi': instance.berat_badan_bayi,
      'proses_melahirkan': instance.proses_melahirkan,
      'penolong': instance.penolong,
      'masalah': instance.masalah,
    };
