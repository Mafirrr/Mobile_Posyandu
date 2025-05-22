import 'package:posyandu_mob/core/models/Petugas.dart';

class PetugasWithRole {
  Petugas petugas;
  String role;
  String token;

  PetugasWithRole(
      {required this.petugas, required this.role, required this.token});
}
