// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'Anggota.g.dart';

@JsonSerializable()
class Anggota {
  int id;
  String nik;
  String nama;
  String? no_jkn;
  String? faskes_tk1;
  String? faskes_rujukan;
  String tanggal_lahir;
  String tempat_lahir;
  String pekerjaan;
  String alamat;
  String? no_telepon;
  String? golongan_darah;

  Anggota({
    required this.id,
    required this.nik,
    required this.nama,
    required this.no_jkn,
    required this.faskes_tk1,
    required this.faskes_rujukan,
    required this.tanggal_lahir,
    required this.tempat_lahir,
    required this.pekerjaan,
    required this.alamat,
    this.no_telepon,
    this.golongan_darah,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) =>
      _$AnggotaFromJson(json);

  Map<String, dynamic> toJson() => _$AnggotaToJson(this);
}
