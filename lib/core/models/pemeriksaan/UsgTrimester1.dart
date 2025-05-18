import 'package:json_annotation/json_annotation.dart';

part 'UsgTrimester1.g.dart';

@JsonSerializable()
class UsgTrimester1 {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "hpht")
  dynamic hpht;
  @JsonKey(name: "keteraturan_haid")
  String? keteraturanHaid;
  @JsonKey(name: "umur_kehamilan_berdasar_hpht")
  int? umurKehamilanBerdasarHpht;
  @JsonKey(name: "umur_kehamilan_berdasarkan_usg")
  int? umurKehamilanBerdasarkanUsg;
  @JsonKey(name: "hpl_berdasarkan_hpht")
  String? hplBerdasarkanHpht;
  @JsonKey(name: "hpl_berdasarkan_usg")
  String? hplBerdasarkanUsg;
  @JsonKey(name: "jumlah_bayi")
  String? jumlahBayi;
  @JsonKey(name: "jumlah_gs")
  String? jumlahGs;
  @JsonKey(name: "diametes_gs")
  int? diametesGs;
  @JsonKey(name: "gs_hari")
  int? gsHari;
  @JsonKey(name: "gs_minggu")
  int? gsMinggu;
  @JsonKey(name: "crl")
  int? crl;
  @JsonKey(name: "crl_hari")
  int? crlHari;
  @JsonKey(name: "crl_minggu")
  int? crlMinggu;
  @JsonKey(name: "letak_produk_kehamilan")
  String? letakProdukKehamilan;
  @JsonKey(name: "pulsasi_jantung")
  String? pulsasiJantung;
  @JsonKey(name: "kecurigaan_temuan_abnormal")
  String? kecurigaanTemuanAbnormal;
  @JsonKey(name: "keterangan")
  String? keterangan;

  UsgTrimester1({
    required this.id,
    this.hpht,
    this.keteraturanHaid,
    this.umurKehamilanBerdasarHpht,
    this.umurKehamilanBerdasarkanUsg,
    this.hplBerdasarkanHpht,
    this.hplBerdasarkanUsg,
    this.jumlahBayi,
    this.jumlahGs,
    this.diametesGs,
    this.gsHari,
    this.gsMinggu,
    this.crl,
    this.crlHari,
    this.crlMinggu,
    this.letakProdukKehamilan,
    this.pulsasiJantung,
    this.kecurigaanTemuanAbnormal,
    this.keterangan,
  });

  factory UsgTrimester1.fromJson(Map<String, dynamic> json) =>
      _$UsgTrimester1FromJson(json);

  Map<String, dynamic> toJson() => _$UsgTrimester1ToJson(this);
}
