import 'package:json_annotation/json_annotation.dart';

part 'UsgTrimester3.g.dart';

@JsonSerializable()
class UsgTrimester3 {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "usg_trimester3")
  String? usgTrimester3;
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
    required this.id,
    required this.usgTrimester3,
    required this.umurKehamilanUsgTrimester3,
    required this.selisihUkUsg1HphtDenganTrimester3,
    required this.jumlahBayi,
    required this.letakBayi,
    required this.presentasiBayi,
    required this.keadaanBayi,
    required this.djjStatus,
    required this.lokasiPlasenta,
    required this.jumlahCairanKetuban,
    required this.bpd,
    required this.hc,
    required this.ac,
    required this.fl,
    required this.efw,
    required this.hcSesuaiMinggu,
    required this.bpdSesuaiMinggu,
    required this.acSesuaiMinggu,
    required this.flSesuaiMinggu,
    required this.efwSesuaiMinggu,
    required this.kecurigaanTemuanAbnormal,
    required this.keterangan,
    required this.djj,
    required this.sdp,
  });

  factory UsgTrimester3.fromJson(Map<String, dynamic> json) =>
      _$UsgTrimester3FromJson(json);

  Map<String, dynamic> toJson() => _$UsgTrimester3ToJson(this);
}
