// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RencanaKonsultasi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RencanaKonsultasi _$RencanaKonsultasiFromJson(Map<String, dynamic> json) =>
    RencanaKonsultasi(
      id: (json['id'] as num).toInt(),
      rencanaKonsultasiLanjut: stringToList(json['rencana_konsultasi_lanjut']),
      rencanaProsesMelahirkan: json['rencana_proses_melahirkan'] as String?,
      pilihanKontrasepsi: json['pilihan_kontrasepsi'] as String?,
      kebutuhanKonseling: json['kebutuhan_konseling'] as String?,
    );

Map<String, dynamic> _$RencanaKonsultasiToJson(RencanaKonsultasi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rencana_konsultasi_lanjut':
          listToString(instance.rencanaKonsultasiLanjut),
      'rencana_proses_melahirkan': instance.rencanaProsesMelahirkan,
      'pilihan_kontrasepsi': instance.pilihanKontrasepsi,
      'kebutuhan_konseling': instance.kebutuhanKonseling,
    };
