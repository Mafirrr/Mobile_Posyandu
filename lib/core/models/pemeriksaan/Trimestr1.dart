import 'package:json_annotation/json_annotation.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/LabTrimester1.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanAwal.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanFisik.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKhusus.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/SkriningKesehatan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/UsgTrimester1.dart';

part 'Trimestr1.g.dart';

@JsonSerializable()
class Trimestr1 {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "pemeriksaan_id")
  int pemeriksaanId;
  @JsonKey(name: "created_at")
  String created_at;
  @JsonKey(name: "pemeriksaan_rutin")
  PemeriksaanRutin pemeriksaanRutin;
  @JsonKey(name: "skrining_kesehatan")
  SkriningKesehatan skriningKesehatan;
  @JsonKey(name: "pemeriksaan_fisik")
  PemeriksaanFisik pemeriksaanFisik;
  @JsonKey(name: "pemeriksaan_awal")
  PemeriksaanAwal pemeriksaanAwal;
  @JsonKey(name: "pemeriksaan_khusus")
  PemeriksaanKhusus pemeriksaanKhusus;
  @JsonKey(name: "lab_trimester1")
  LabTrimester1 labTrimester1;
  @JsonKey(name: "usg_trimester1")
  UsgTrimester1 usgTrimester1;

  Trimestr1({
    required this.id,
    required this.created_at,
    required this.pemeriksaanId,
    required this.pemeriksaanRutin,
    required this.skriningKesehatan,
    required this.pemeriksaanFisik,
    required this.pemeriksaanAwal,
    required this.pemeriksaanKhusus,
    required this.labTrimester1,
    required this.usgTrimester1,
  });

  factory Trimestr1.fromJson(Map<String, dynamic> json) =>
      _$Trimestr1FromJson(json);

  Map<String, dynamic> toJson() => _$Trimestr1ToJson(this);
}
