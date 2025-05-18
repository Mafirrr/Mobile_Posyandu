import 'package:json_annotation/json_annotation.dart';

part 'LabTrimester1.g.dart';

@JsonSerializable()
class LabTrimester1 {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "hemoglobin")
  int? hemoglobin;
  @JsonKey(name: "golongan_darah_dan_rhesus")
  String? golonganDarahDanRhesus;
  @JsonKey(name: "gula_darah")
  int? gulaDarah;
  @JsonKey(name: "hemoglobin_rtl")
  dynamic hemoglobinRtl;
  @JsonKey(name: "rhesus_rtl")
  dynamic rhesusRtl;
  @JsonKey(name: "gula_darah_rtl")
  String? gulaDarahRtl;
  @JsonKey(name: "hiv")
  String? hiv;
  @JsonKey(name: "sifilis")
  String? sifilis;
  @JsonKey(name: "hepatitis_b")
  String? hepatitisB;

  LabTrimester1({
    this.id,
    this.hemoglobin,
    this.golonganDarahDanRhesus,
    this.gulaDarah,
    this.hemoglobinRtl,
    this.rhesusRtl,
    this.gulaDarahRtl,
    this.hiv,
    this.sifilis,
    this.hepatitisB,
  });

  factory LabTrimester1.fromJson(Map<String, dynamic> json) =>
      _$LabTrimester1FromJson(json);

  Map<String, dynamic> toJson() => _$LabTrimester1ToJson(this);
}
