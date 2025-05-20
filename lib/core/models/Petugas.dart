import 'package:json_annotation/json_annotation.dart';

part 'Petugas.g.dart';

@JsonSerializable()
class Petugas {
  int? id;
  @JsonKey(name: 'nip')
  String? nip;
  @JsonKey(name: 'nama')
  String? nama;
  @JsonKey(name: 'no_telepon')
  String? noTelepon;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'role')
  String? role;

  Petugas({
    this.id,
    this.nip,
    this.nama,
    this.noTelepon,
    this.email,
    this.role,
  });

  factory Petugas.fromJson(Map<String, dynamic> json) =>
      _$PetugasFromJson(json);

  Map<String, dynamic> toJson() => _$PetugasToJson(this);
}
