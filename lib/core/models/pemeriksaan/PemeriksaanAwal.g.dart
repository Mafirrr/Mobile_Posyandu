// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PemeriksaanAwal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PemeriksaanAwal _$PemeriksaanAwalFromJson(Map<String, dynamic> json) =>
    PemeriksaanAwal(
      id: (json['id'] as num?)?.toInt(),
      tinggiBadan: (json['tinggi_badan'] as num?)?.toInt(),
      golonganDarah: json['golongan_darah'] as String?,
      statusImunisasiTd: json['status_imunisasi_td'] as String?,
      hemoglobin: (json['hemoglobin'] as num?)?.toDouble(),
      riwayatKesehatanIbuSekarang:
          stringToList(json['riwayat_kesehatan_ibu_sekarang']),
      riwayatPerilaku: stringToList(json['riwayat_perilaku']),
      riwayatPenyakitKeluarga: stringToList(json['riwayat_penyakit_keluarga']),
    );

Map<String, dynamic> _$PemeriksaanAwalToJson(PemeriksaanAwal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tinggi_badan': instance.tinggiBadan,
      'golongan_darah': instance.golonganDarah,
      'status_imunisasi_td': instance.statusImunisasiTd,
      'hemoglobin': instance.hemoglobin,
      'riwayat_kesehatan_ibu_sekarang':
          listToString(instance.riwayatKesehatanIbuSekarang),
      'riwayat_perilaku': listToString(instance.riwayatPerilaku),
      'riwayat_penyakit_keluarga':
          listToString(instance.riwayatPenyakitKeluarga),
    };
