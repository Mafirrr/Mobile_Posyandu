import 'package:posyandu_mob/core/models/Anggota.dart';

class UserWithRole {
  final Anggota anggota;
  final String role;
  final String token;

  UserWithRole(
      {required this.anggota, required this.role, required this.token});
}
