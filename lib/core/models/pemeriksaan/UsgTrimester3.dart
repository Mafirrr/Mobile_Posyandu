import 'package:json_annotation/json_annotation.dart';

part 'UsgTrimester3.g.dart';

@JsonSerializable()
class UsgTrimester3 {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "usg_trimester3")
  String? usgTrimester3;
  @JsonKey(name: "umur_kehamilan_usg_trimester_1")
  int? umurKehamilanUsgTrimester1;
  @JsonKey(name: "umur_kehamilan_usg_trimester_3")
  int? umurKehamilanUsgTrimester3;
  @JsonKey(name: "selisih_uk_usg_1_hpht_dengan_trimester_3")
  String? selisihUkUsg1HphtDenganTrimester3;
  @JsonKey(name: "jumlah_bayi")
  String? jumlahBayi;
  @JsonKey(name: "letak_bayi")
  String? letakBayi;
  @JsonKey(name: "presentasi_bayi")
  String? presentasiBayi;
  @JsonKey(name: "keadaan_bayi")
  String? keadaanBayi;
  @JsonKey(name: "djj_status")
  String? djjStatus;
  @JsonKey(name: "lokasi_plasenta")
  String? lokasiPlasenta;
  @JsonKey(name: "jumlah_cairan_ketuban")
  String? jumlahCairanKetuban;
  @JsonKey(name: "BPD")
  double? bpd;
  @JsonKey(name: "HC")
  double? hc;
  @JsonKey(name: "AC")
  double? ac;
  @JsonKey(name: "FL")
  double? fl;
  @JsonKey(name: "EFW")
  double? efw;
  @JsonKey(name: "HC_Sesuai_Minggu")
  int? hcSesuaiMinggu;
  @JsonKey(name: "BPD_Sesuai_Minggu")
  int? bpdSesuaiMinggu;
  @JsonKey(name: "AC_Sesuai_Minggu")
  int? acSesuaiMinggu;
  @JsonKey(name: "FL_Sesuai_Minggu")
  int? flSesuaiMinggu;
  @JsonKey(name: "EFW_Sesuai_Minggu")
  int? efwSesuaiMinggu;
  @JsonKey(name: "kecurigaan_temuan_abnormal")
  String? kecurigaanTemuanAbnormal;
  @JsonKey(name: "keterangan")
  String? keterangan;
  @JsonKey(name: "djj")
  dynamic djj;
  @JsonKey(name: "sdp")
  dynamic sdp;

  UsgTrimester3({
    this.id,
    this.usgTrimester3,
    this.umurKehamilanUsgTrimester1,
    this.umurKehamilanUsgTrimester3,
    this.selisihUkUsg1HphtDenganTrimester3,
    this.jumlahBayi,
    this.letakBayi,
    this.presentasiBayi,
    this.keadaanBayi,
    this.djjStatus,
    this.lokasiPlasenta,
    this.jumlahCairanKetuban,
    this.bpd,
    this.hc,
    this.ac,
    this.fl,
    this.efw,
    this.hcSesuaiMinggu,
    this.bpdSesuaiMinggu,
    this.acSesuaiMinggu,
    this.flSesuaiMinggu,
    this.efwSesuaiMinggu,
    this.kecurigaanTemuanAbnormal,
    this.keterangan,
    this.djj,
    this.sdp,
  });

  factory UsgTrimester3.fromJson(Map<String, dynamic> json) =>
      _$UsgTrimester3FromJson(json);

  Map<String, dynamic> toJson() => _$UsgTrimester3ToJson(this);
}
