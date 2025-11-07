class NotifikasiModel {
  final String judul;
  final String deskripsi;
  final DateTime tanggal;
  final bool sudahDibaca;

  NotifikasiModel({
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    this.sudahDibaca = false,
  });
}
