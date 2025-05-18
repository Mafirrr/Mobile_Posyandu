// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PemeriksaanRutin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PemeriksaanRutin _$PemeriksaanRutinFromJson(Map<String, dynamic> json) =>
    PemeriksaanRutin(
      id: (json['id'] as num).toInt(),
      pemeriksaanId: (json['pemeriksaan_id'] as num).toInt(),
      beratBadan: (json['berat_badan'] as num).toInt(),
      tinggiRahim: json['tinggi_rahim'] as String,
      tekananDarahSistol: (json['tekanan_darah_sistol'] as num).toInt(),
      tekananDarahDiastol: (json['tekanan_darah_diastol'] as num).toInt(),
      letakDanDenyutNadiBayi: json['letak_dan_denyut_nadi_bayi'] as String,
      lingkarLenganAtas: (json['lingkar_lengan_atas'] as num).toInt(),
      proteinUrin: json['protein_urin'],
      tabletTambahDarah: json['tablet_tambah_darah'] as String,
      konseling: json['konseling'] as String,
      skriningDokter: json['skrining_dokter'] as String,
      tesLabGulaDarah: json['tes_lab_gula_darah'],
    );

Map<String, dynamic> _$PemeriksaanRutinToJson(PemeriksaanRutin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pemeriksaan_id': instance.pemeriksaanId,
      'berat_badan': instance.beratBadan,
      'tinggi_rahim': instance.tinggiRahim,
      'tekanan_darah_sistol': instance.tekananDarahSistol,
      'tekanan_darah_diastol': instance.tekananDarahDiastol,
      'letak_dan_denyut_nadi_bayi': instance.letakDanDenyutNadiBayi,
      'lingkar_lengan_atas': instance.lingkarLenganAtas,
      'protein_urin': instance.proteinUrin,
      'tablet_tambah_darah': instance.tabletTambahDarah,
      'konseling': instance.konseling,
      'skrining_dokter': instance.skriningDokter,
      'tes_lab_gula_darah': instance.tesLabGulaDarah,
    };
