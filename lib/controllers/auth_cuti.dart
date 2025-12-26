import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceCuti {
  final CollectionReference cuti = FirebaseFirestore.instance.collection(
    'cuti',
  );

  Future<void> ajukanCuti({
    required String idKaryawan,
    required String nama,
    required String jabatan,
    required String tglAwal,
    required String tglAkhir,
    required String alasan,
    required String buktiBase64,
  }) async {
    await cuti.add({
      'id_karyawan': idKaryawan,
      'nama': nama,
      'jabatan': jabatan,
      'tgl_awal': tglAwal,
      'tgl_akhir': tglAkhir,
      'alasan': alasan,
      'bukti_base64': buktiBase64,
      'status': 'Dalam Proses',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // === RIWAYAT CUTI PER USER ===
  Stream<QuerySnapshot> getRiwayatCutiByKaryawan(String idKaryawan) {
    return cuti
        .where('id_karyawan', isEqualTo: idKaryawan)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // === ADMIN GET SEMUA CUTI ===
  Stream<QuerySnapshot> getAllCuti() {
    return cuti.orderBy('created_at', descending: true).snapshots();
  }

  // === ADMIN UPDATE STATUS ===
  Future<void> updateStatus({
    required String docId,
    required String statusBaru,
  }) async {
    await cuti.doc(docId).update({'status': statusBaru});
  }

  // OPTIONAL DELETE
  Future<void> deleteCuti(String id) async {
    await cuti.doc(id).delete();
  }
}
