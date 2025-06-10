// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Jadwal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jadwal _$JadwalFromJson(Map<String, dynamic> json) => Jadwal(
      id: (json['id'] as num).toInt(),
      anggota_id: (json['anggota_id'] as num?)?.toInt(),
      judul: json['judul'] as String,
      tanggal: json['tanggal'] as String,
      keterangan: json['keterangan'] as String?,
      lokasi: (json['lokasi'] as num).toInt(),
      jam_mulai: json['jam_mulai'] as String,
      jam_selesai: json['jam_selesai'] as String,
      posyandu: json['posyandu'] == null
          ? null
          : Posyandu.fromJson(json['posyandu'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JadwalToJson(Jadwal instance) => <String, dynamic>{
      'id': instance.id,
      'anggota_id': instance.anggota_id,
      'judul': instance.judul,
      'tanggal': instance.tanggal,
      'keterangan': instance.keterangan,
      'lokasi': instance.lokasi,
      'jam_mulai': instance.jam_mulai,
      'jam_selesai': instance.jam_selesai,
      'posyandu': instance.posyandu,
    };
