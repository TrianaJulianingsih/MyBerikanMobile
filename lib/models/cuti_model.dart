class CutiModel {
  final DateTime tanggalMulai;
  final DateTime tanggalAkhir;
  final String alasan;
  final String bukti; // path gambar bukti (img)
  String status; // "Disetujui", "Ditolak", "Dipending"

  CutiModel({
    required this.tanggalMulai,
    required this.tanggalAkhir,
    required this.alasan,
    required this.bukti,
    required this.status,
  });
}
