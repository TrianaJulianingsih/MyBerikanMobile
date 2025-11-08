import 'package:myberikan/models/notifikasi_model.dart';

final List<NotifikasiModel> dummyNotifikasi = [
  NotifikasiModel(
    judul: "Pengajuan Cuti Baru",
    deskripsi: "Ada pengajuan cuti dari Andi yang menunggu verifikasi.",
    tanggal: DateTime.now().subtract(Duration(hours: 2)),
    sudahDibaca: false,
  ),
  NotifikasiModel(
    judul: "Laporan Bulanan Tersedia",
    deskripsi: "Laporan bulanan karyawan sudah siap untuk ditinjau.",
    tanggal: DateTime.now().subtract(Duration(days: 1, hours: 3)),
    sudahDibaca: true,
  ),
  NotifikasiModel(
    judul: "Verifikasi Cuti Disetujui",
    deskripsi: "Pengajuan cuti kamu telah disetujui oleh HR.",
    tanggal: DateTime.now().subtract(Duration(days: 2, hours: 5)),
    sudahDibaca: true,
  ),
  NotifikasiModel(
    judul: "Pengingat Absensi",
    deskripsi: "Jangan lupa melakukan absensi pagi sebelum jam 08.00.",
    tanggal: DateTime.now().subtract(Duration(hours: 5)),
    sudahDibaca: false,
  ),
];
