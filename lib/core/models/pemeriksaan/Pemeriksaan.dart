import 'package:json_annotation/json_annotation.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanKehamilan.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimestr1.dart';

part 'Pemeriksaan.g.dart';

@JsonSerializable()
class Pemeriksaan {
  @JsonKey(name: "pemeriksaan")
  List<PemeriksaanKehamilan> pemeriksaan;

  @JsonKey(name: "trimester1")
  List<Trimestr1> trimester1;

  @JsonKey(name: "trimester2")
  List<PemeriksaanRutin> trimester2;

  @JsonKey(name: "trimester3")
  List<Trimester3> trimester3;

  Pemeriksaan({
    required this.pemeriksaan,
    required this.trimester1,
    required this.trimester2,
    required this.trimester3,
  });

  factory Pemeriksaan.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanToJson(this);
}
