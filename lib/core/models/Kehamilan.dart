import 'package:json_annotation/json_annotation.dart';

part 'Kehamilan.g.dart';

@JsonSerializable()
class Kehamilan {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "anggota_id")
  int anggotaId;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "label")
  String label;
  @JsonKey(name: "tahun")
  String? tahun;
  @JsonKey(name: "berat_badan_bayi")
  String? berat_badan_bayi;
  @JsonKey(name: "proses_melahirkan")
  String? proses_melahirkan;
  @JsonKey(name: "penolong")
  String? penolong;
  @JsonKey(name: "masalah")
  String? masalah;

  Kehamilan({
    required this.id,
    required this.anggotaId,
    required this.status,
    required this.label,
    this.berat_badan_bayi,
    this.masalah,
    this.penolong,
    this.proses_melahirkan,
    this.tahun,
  });

  factory Kehamilan.fromJson(Map<String, dynamic> json) =>
      _$KehamilanFromJson(json);

  Map<String, dynamic> toJson() => _$KehamilanToJson(this);
}
