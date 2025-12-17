import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceCuti {
  final CollectionReference cuti = FirebaseFirestore.instance.collection(
    'cuti',
  );
  Future<void> addAbsensi(String idKaryawan, String tglMulai, String tglAkhir, String deskripsi, String bukti, String status) {
    return cuti.add({
      'id_karyawan': idKaryawan,
      'tgl_mulai':  tglMulai,
      'tgl_akhir':  tglAkhir,
      'deskripsi': deskripsi,
      'bukti': bukti,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getCuti() {
    return cuti.snapshots();
  }

  Future<void> updateCuti(
    String idCuti,
    // String idKaryawan,
    String tglMulai,
    String tglAkhir,
    String deskripsi,
    String bukti,
    String status,
  ) {
    return cuti.doc(idCuti).update({
      'tgl_mulai':  tglMulai,
      'tgl_akhir':  tglAkhir,
      'deskripsi': deskripsi,
      'bukti': bukti,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCuti(String id) {
    return cuti.doc(id).delete();
  }
}
