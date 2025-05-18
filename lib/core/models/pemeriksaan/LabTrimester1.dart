import 'package:json_annotation/json_annotation.dart';

part 'LabTrimester1.g.dart';

@JsonSerializable()
class LabTrimester1 {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "hemoglobin")
  int hemoglobin;
  @JsonKey(name: "golongan_darah_dan_rhesus")
  String golonganDarahDanRhesus;
  @JsonKey(name: "gula_darah")
  int gulaDarah;
  @JsonKey(name: "hemoglobin_rtl")
  dynamic hemoglobinRtl;
  @JsonKey(name: "rhesus_rtl")
  dynamic rhesusRtl;
  @JsonKey(name: "gula_darah_rtl")
  String gulaDarahRtl;
  @JsonKey(name: "hiv")
  String hiv;
  @JsonKey(name: "sifilis")
  String sifilis;
  @JsonKey(name: "hepatitis_b")
  String hepatitisB;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "deleted_at")
  dynamic deletedAt;

  LabTrimester1({
    required this.id,
    required this.hemoglobin,
    required this.golonganDarahDanRhesus,
    required this.gulaDarah,
    required this.hemoglobinRtl,
    required this.rhesusRtl,
    required this.gulaDarahRtl,
    required this.hiv,
    required this.sifilis,
    required this.hepatitisB,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory LabTrimester1.fromJson(Map<String, dynamic> json) =>
      _$LabTrimester1FromJson(json);

  Map<String, dynamic> toJson() => _$LabTrimester1ToJson(this);
}
