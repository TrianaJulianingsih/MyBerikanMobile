import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceLaporan {
  final CollectionReference laporan = FirebaseFirestore.instance.collection(
    'laporan',
  );
  Future<void> addLaporan(String idLaporan, String idKaryawan, String idCuti, String jenisLaporan, String tglMulai, String tglAkhir, String periode) {
    return laporan.add({
      'id_laporan': idKaryawan,
      'id_karyawan': idKaryawan,
      'id_cuti': idCuti,
      'jenis_laporan':  jenisLaporan,
      'tgl_mulai':  tglMulai,
      'tgl_akhir': tglAkhir,
      'periode': periode,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getLaporan() {
    return laporan.snapshots();
  }

  Future<void> updateLaporan(
    String idlaporan,
    String idKaryawan,
    String idCuti,
    String jenisLaporan,
    String tglMulai,
    String tglAkhir,
    String periode,
  ) {
    return laporan.doc(idlaporan).update({
      'id_laporan': idKaryawan,
      'id_karyawan': idKaryawan,
      'id_cuti': idCuti,
      'jenis_laporan':  jenisLaporan,
      'tgl_mulai':  tglMulai,
      'tgl_akhir': tglAkhir,
      'periode': periode,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteLaporan(String id) {
    return laporan.doc(id).delete();
  }
}
