import 'package:json_annotation/json_annotation.dart';

part 'PemeriksaanAwal.g.dart';

@JsonSerializable()
class PemeriksaanAwal {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "tinggi_badan")
  int tinggiBadan;
  @JsonKey(name: "golongan_darah")
  String golonganDarah;
  @JsonKey(name: "status_imunisasi_td")
  String statusImunisasiTd;
  @JsonKey(name: "hemoglobin")
  int hemoglobin;
  @JsonKey(name: "riwayat_kesehatan_ibu_sekarang")
  List<String> riwayatKesehatanIbuSekarang;
  @JsonKey(name: "riwayat_perilaku")
  List<String> riwayatPerilaku;
  @JsonKey(name: "riwayat_penyakit_keluarga")
  List<String> riwayatPenyakitKeluarga;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "deleted_at")
  dynamic deletedAt;

  PemeriksaanAwal({
    required this.id,
    required this.tinggiBadan,
    required this.golonganDarah,
    required this.statusImunisasiTd,
    required this.hemoglobin,
    required this.riwayatKesehatanIbuSekarang,
    required this.riwayatPerilaku,
    required this.riwayatPenyakitKeluarga,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory PemeriksaanAwal.fromJson(Map<String, dynamic> json) =>
      _$PemeriksaanAwalFromJson(json);

  Map<String, dynamic> toJson() => _$PemeriksaanAwalToJson(this);
}
