import 'package:json_annotation/json_annotation.dart';

part 'PemeriksaanRutin.g.dart';

@JsonSerializable()
class PemeriksaanRutin {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "pemeriksaan_id")
  int pemeriksaanId;
  @JsonKey(name: "berat_badan")
  int beratBadan;
  @JsonKey(name: "tinggi_rahim")
  String tinggiRahim;
  @JsonKey(name: "tekanan_darah_sistol")
  int tekananDarahSistol;
  @JsonKey(name: "tekanan_darah_diastol")
  int tekananDarahDiastol;
  @JsonKey(name: "letak_dan_denyut_nadi_bayi")
  String letakDanDenyutNadiBayi;
  @JsonKey(name: "lingkar_lengan_atas")
  int lingkarLenganAtas;
  @JsonKey(name: "protein_urin")
  dynamic proteinUrin;
  @JsonKey(name: "tablet_tambah_darah")
  String tabletTambahDarah;
  @JsonKey(name: "konseling")
  String konseling;
  @JsonKey(name: "skrining_dokter")
  String skriningDokter;
  @JsonKey(name: "tes_lab_gula_darah")
  dynamic tesLabGulaDarah;

  PemeriksaanRutin({
    required this.id,
    required this.pemeriksaanId,
    required this.beratBadan,
    required this.tinggiRahim,
    required this.tekananDarahSistol,
    required this.tekananDarahDiastol,
    required this.letakDanDenyutNadiBayi,
    required this.lingkarLenganAtas,
    required this.proteinUrin,
    required this.tabletTambahDarah,
    required this.konseling,
    required this.skriningDokter,
    required this.tesLabGulaDarah,
  });

  factory PemeriksaanRutin.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanRutinFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanRutinToJson(this);
}
