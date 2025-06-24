import 'package:json_annotation/json_annotation.dart';

part 'Nifas.g.dart';

@JsonSerializable()
class Nifas {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "pemeriksaan_id")
  int? pemeriksaanId;
  @JsonKey(name: "bagian_kf")
  String? bagianKf;
  @JsonKey(name: "periksa_payudara")
  String? periksaPayudara;
  @JsonKey(name: "periksa_pendarahan")
  String? periksaPendarahan;
  @JsonKey(name: "periksa_jalan_lahir")
  String? periksaJalanLahir;
  @JsonKey(name: "vitamin_a")
  String? vitaminA;
  @JsonKey(name: "kb_pasca_melahirkan")
  String? kbPascaMelahirkan;
  @JsonKey(name: "skrining_kesehatan_jiwa")
  String? skriningKesehatanJiwa;
  @JsonKey(name: "konseling")
  String? konseling;
  @JsonKey(name: "tata_laksana_kasus")
  String? tataLaksanaKasus;
  @JsonKey(name: "kesimpulan_ibu")
  String? kesimpulanIbu;
  @JsonKey(name: "kesimpulan_bayi")
  String? kesimpulanBayi;
  @JsonKey(name: "masalah_nifas")
  String? masalahNifas;
  @JsonKey(name: "kesimpulan")
  String? kesimpulan;
  @JsonKey(name: "created_at")
  String? createdAt;

  Nifas({
    this.id,
    this.pemeriksaanId,
    this.bagianKf,
    this.periksaPayudara,
    this.periksaPendarahan,
    this.periksaJalanLahir,
    this.vitaminA,
    this.kbPascaMelahirkan,
    this.skriningKesehatanJiwa,
    this.konseling,
    this.tataLaksanaKasus,
    this.kesimpulanIbu,
    this.kesimpulanBayi,
    this.masalahNifas,
    this.kesimpulan,
    this.createdAt,
  });

  factory Nifas.fromJson(Map<String, dynamic> json) => _$NifasFromJson(json);

  Map<String, dynamic> toJson() => _$NifasToJson(this);
}
