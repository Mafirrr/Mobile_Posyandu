// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UsgTrimester1.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsgTrimester1 _$UsgTrimester1FromJson(Map<String, dynamic> json) =>
    UsgTrimester1(
      id: (json['id'] as num?)?.toInt(),
      hpht: json['hpht'],
      keteraturanHaid: json['keteraturan_haid'] as String?,
      umurKehamilanBerdasarHpht:
          (json['umur_kehamilan_berdasar_hpht'] as num?)?.toInt(),
      umurKehamilanBerdasarkanUsg:
          (json['umur_kehamilan_berdasarkan_usg'] as num?)?.toInt(),
      hplBerdasarkanHpht: json['hpl_berdasarkan_hpht'] as String?,
      hplBerdasarkanUsg: json['hpl_berdasarkan_usg'] as String?,
      jumlahBayi: json['jumlah_bayi'] as String?,
      jumlahGs: json['jumlah_gs'] as String?,
      diametesGs: (json['diametes_gs'] as num?)?.toDouble(),
      gsHari: (json['gs_hari'] as num?)?.toInt(),
      gsMinggu: (json['gs_minggu'] as num?)?.toInt(),
      crl: json['crl'],
      crlHari: (json['crl_hari'] as num?)?.toInt(),
      crlMinggu: (json['crl_minggu'] as num?)?.toInt(),
      letakProdukKehamilan: json['letak_produk_kehamilan'] as String?,
      pulsasiJantung: json['pulsasi_jantung'] as String?,
      kecurigaanTemuanAbnormal: json['kecurigaan_temuan_abnormal'] as String?,
      keterangan: json['keterangan'] as String?,
    );

Map<String, dynamic> _$UsgTrimester1ToJson(UsgTrimester1 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hpht': instance.hpht,
      'keteraturan_haid': instance.keteraturanHaid,
      'umur_kehamilan_berdasar_hpht': instance.umurKehamilanBerdasarHpht,
      'umur_kehamilan_berdasarkan_usg': instance.umurKehamilanBerdasarkanUsg,
      'hpl_berdasarkan_hpht': instance.hplBerdasarkanHpht,
      'hpl_berdasarkan_usg': instance.hplBerdasarkanUsg,
      'jumlah_bayi': instance.jumlahBayi,
      'jumlah_gs': instance.jumlahGs,
      'diametes_gs': instance.diametesGs,
      'gs_hari': instance.gsHari,
      'gs_minggu': instance.gsMinggu,
      'crl': instance.crl,
      'crl_hari': instance.crlHari,
      'crl_minggu': instance.crlMinggu,
      'letak_produk_kehamilan': instance.letakProdukKehamilan,
      'pulsasi_jantung': instance.pulsasiJantung,
      'kecurigaan_temuan_abnormal': instance.kecurigaanTemuanAbnormal,
      'keterangan': instance.keterangan,
    };
