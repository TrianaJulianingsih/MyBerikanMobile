import 'absensi_model.dart';
import 'cuti_model.dart';

class UserModel {
  final String id;
  final String username;
  final String password;
  final String nama;
  final String jabatan;
  final String kontrak; // contoh: "Tetap", "Kontrak"
  final int jatahCuti;

  final List<AbsensiModel> absensi; // daftar kehadiran user
  final List<CutiModel> cuti;       // daftar cuti user

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.nama,
    required this.jabatan,
    required this.kontrak,
    required this.jatahCuti,
    required this.absensi,
    required this.cuti,
  });
}
