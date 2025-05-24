// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GrafikBB.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grafik _$GrafikFromJson(Map<String, dynamic> json) => Grafik(
      anggotaId: (json['anggota_id'] as num).toInt(),
      imt: (json['IMT'] as num).toDouble(),
      mingguUsg: (json['minggu_usg'] as num).toInt(),
      beratAwal: (json['Berat_badan_awal'] as num).toDouble(),
      tanggalPemeriksaan: DateTime.parse(json['tanggal_pemeriksaan'] as String),
      data: (json['data'] as List<dynamic>)
          .map((e) => DataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GrafikToJson(Grafik instance) => <String, dynamic>{
      'anggota_id': instance.anggotaId,
      'IMT': instance.imt,
      'minggu_usg': instance.mingguUsg,
      'Berat_badan_awal': instance.beratAwal,
      'tanggal_pemeriksaan': instance.tanggalPemeriksaan.toIso8601String(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

DataPoint _$DataPointFromJson(Map<String, dynamic> json) => DataPoint(
      minggu: (json['minggu'] as num).toInt(),
      berat: (json['berat_badan'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DataPointToJson(DataPoint instance) => <String, dynamic>{
      'minggu': instance.minggu,
      'berat_badan': instance.berat,
    };
