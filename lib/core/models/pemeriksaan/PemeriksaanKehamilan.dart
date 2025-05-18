import 'package:json_annotation/json_annotation.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/PemeriksaanRutin.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimester3.dart';
import 'package:posyandu_mob/core/models/pemeriksaan/Trimestr1.dart';

part 'PemeriksaanKehamilan.g.dart';

@JsonSerializable()
class PemeriksaanKehamilan {
  @JsonKey(name: "trimester1")
  List<Trimestr1> trimester1;

  @JsonKey(name: "trimester2")
  List<PemeriksaanRutin> trimester2;

  @JsonKey(name: "trimester3")
  List<Trimester3> trimester3;

  PemeriksaanKehamilan({
    required this.trimester1,
    required this.trimester2,
    required this.trimester3,
  });

  factory PemeriksaanKehamilan.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanKehamilanFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanKehamilanToJson(this);
}
