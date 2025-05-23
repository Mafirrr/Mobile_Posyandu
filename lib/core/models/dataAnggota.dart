import 'package:json_annotation/json_annotation.dart';

part 'dataAnggota.g.dart';

@JsonSerializable()
class DataAnggota {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "anggota_id")
  int anggotaId;
  @JsonKey(name: "nik")
  String nik;
  @JsonKey(name: "nama")
  String nama;
  @JsonKey(name: "no_jkn")
  String noJkn;
  @JsonKey(name: "faskes_tk1")
  String? faskesTk1;
  @JsonKey(name: "faskes_rujukan")
  String? faskesRujukan;
  @JsonKey(name: "tanggal_lahir")
  String tanggalLahir;
  @JsonKey(name: "tempat_lahir")
  String tempatLahir;
  @JsonKey(name: "pekerjaan")
  String pekerjaan;
  @JsonKey(name: "alamat")
  String alamat;
  @JsonKey(name: "no_telepon")
  String? noTelepon;
@JsonKey(name: "golongan_Darah")
  String? golonganDarah;

  DataAnggota({
    required this.id,
    required this.anggotaId,
    required this.nik,
    required this.nama,
    required this.noJkn,
    this.faskesTk1,
    this.faskesRujukan,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.pekerjaan,
    required this.alamat,
    this.noTelepon,
    this.golonganDarah,
  });

  factory DataAnggota.fromJson(Map<String, dynamic> json) =>
      _$DataAnggotaFromJson(json);

  Map<String, dynamic> toJson() => _$DataAnggotaToJson(this);
}
