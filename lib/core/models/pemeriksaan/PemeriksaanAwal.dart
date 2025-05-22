import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'PemeriksaanAwal.g.dart';

@JsonSerializable()
class PemeriksaanAwal {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "tinggi_badan")
  int? tinggiBadan;

  @JsonKey(name: "golongan_darah")
  String? golonganDarah;

  @JsonKey(name: "status_imunisasi_td")
  String? statusImunisasiTd;

  @JsonKey(name: "hemoglobin")
  double? hemoglobin;

  @JsonKey(
    name: "riwayat_kesehatan_ibu_sekarang",
    fromJson: stringToList,
    toJson: listToString,
  )
  List<String>? riwayatKesehatanIbuSekarang;

  @JsonKey(
    name: "riwayat_perilaku",
    fromJson: stringToList,
    toJson: listToString,
  )
  List<String>? riwayatPerilaku;

  @JsonKey(
    name: "riwayat_penyakit_keluarga",
    fromJson: stringToList,
    toJson: listToString,
  )
  List<String>? riwayatPenyakitKeluarga;

  PemeriksaanAwal({
    this.id,
    this.tinggiBadan,
    this.golonganDarah,
    this.statusImunisasiTd,
    this.hemoglobin,
    this.riwayatKesehatanIbuSekarang,
    this.riwayatPerilaku,
    this.riwayatPenyakitKeluarga,
  });

  factory PemeriksaanAwal.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanAwalFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanAwalToJson(this);
}

List<String> stringToList(dynamic input) {
  if (input == null) return [];
  if (input is List) return input.cast<String>();
  if (input is String) return List<String>.from(jsonDecode(input));
  return [];
}

String listToString(List<String>? input) {
  return jsonEncode(input ?? []);
}
