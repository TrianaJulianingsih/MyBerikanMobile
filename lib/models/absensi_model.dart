class AbsensiModel {
  final DateTime tanggal;
  final String status; // "Hadir", "Sakit", atau "Alpha"

  AbsensiModel({
    required this.tanggal,
    required this.status,
  });
}
