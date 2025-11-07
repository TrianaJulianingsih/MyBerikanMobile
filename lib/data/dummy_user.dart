import 'package:myberikan/models/absensi_model.dart';
import 'package:myberikan/models/cuti_model.dart';
import 'package:myberikan/models/user_model.dart';

final List<UserModel> dummyUsers = [
  UserModel(
    id: 'NK0139431',
    username: 'pratama',
    password: '12345',
    nama: 'Pratama Pangestu',
    jabatan: 'HR',
    kontrak: 'Tetap',
    jatahCuti: 12,
    absensi: [
      AbsensiModel(tanggal: DateTime(2025, 10, 1), status: 'Hadir'),
      AbsensiModel(tanggal: DateTime(2025, 10, 2), status: 'Sakit'),
      AbsensiModel(tanggal: DateTime(2025, 10, 3), status: 'Hadir'),
    ],
    cuti: [
      CutiModel(
        tanggalMulai: DateTime(2025, 10, 10),
        tanggalAkhir: DateTime(2025, 10, 12),
        alasan: 'Acara keluarga di luar kota',
        bukti: 'assets/images/bukti_cuti_intan.png',
        status: 'Disetujui',
      ),
    ],
  ),
  UserModel(
    id: 'NK0234545',
    username: 'wildan',
    password: '12345',
    nama: 'Wildan Hidayat',
    jabatan: 'Backend Developer',
    kontrak: 'Kontrak',
    jatahCuti: 10,
    absensi: [
      AbsensiModel(tanggal: DateTime(2025, 10, 1), status: 'Hadir'),
      AbsensiModel(tanggal: DateTime(2025, 10, 2), status: 'Alpha'),
      AbsensiModel(tanggal: DateTime(2025, 10, 3), status: 'Hadir'),
    ],
    cuti: [
      CutiModel(
        tanggalMulai: DateTime(2025, 10, 20),
        tanggalAkhir: DateTime(2025, 10, 21),
        alasan: 'Menghadiri pernikahan keluarga',
        bukti: 'assets/images/bukti_cuti_wildan.jpg',
        status: 'Dipending',
      ),
    ],
  ),
  UserModel(
    id: 'NK0355436',
    username: 'nur',
    password: '12345',
    nama: 'Nur Aini',
    jabatan: 'Project Manager',
    kontrak: 'Tetap',
    jatahCuti: 15,
    absensi: [
      AbsensiModel(tanggal: DateTime(2025, 10, 1), status: 'Hadir'),
      AbsensiModel(tanggal: DateTime(2025, 10, 2), status: 'Hadir'),
      AbsensiModel(tanggal: DateTime(2025, 10, 3), status: 'Hadir'),
    ],
    cuti: [
      CutiModel(
        tanggalMulai: DateTime(2025, 9, 25),
        tanggalAkhir: DateTime(2025, 9, 27),
        alasan: 'Liburan bersama keluarga',
        bukti: 'assets/images/bukti_cuti_nur.png',
        status: 'Ditolak',
      ),
    ],
  ),
];
