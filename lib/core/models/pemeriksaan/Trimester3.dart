import 'package:json_annotation/json_annotation.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/RencanaKonsultasi.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/SkriningKesehatan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester3.dart';

part 'Trimester3.g.dart';

@JsonSerializable()
class Trimester3 {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "created_at")
  String? created_at;
  @JsonKey(name: "pemeriksaan_id")
  int? pemeriksaanId;
  @JsonKey(name: "pemeriksaan_rutin")
  PemeriksaanRutin pemeriksaanRutin;
  @JsonKey(name: "skrining_kesehatan")
  SkriningKesehatan skriningKesehatan;
  @JsonKey(name: "pemeriksaan_fisik")
  PemeriksaanFisik pemeriksaanFisik;
  @JsonKey(name: "rencana_konsultasi")
  RencanaKonsultasi rencanaKonsultasi;
  @JsonKey(name: "lab_trimester3")
  LabTrimester3 labTrimester3;
  @JsonKey(name: "usg_trimester3")
  UsgTrimester3 usgTrimester3;

  Trimester3({
    this.id,
    this.created_at,
    this.pemeriksaanId,
    required this.pemeriksaanRutin,
    required this.skriningKesehatan,
    required this.pemeriksaanFisik,
    required this.rencanaKonsultasi,
    required this.labTrimester3,
    required this.usgTrimester3,
  });

  factory Trimester3.fromJson(Map<String, dynamic> json) =>
      _$Trimester3FromJson(json);

  Map<String, dynamic> toJson() => _$Trimester3ToJson(this);
}
