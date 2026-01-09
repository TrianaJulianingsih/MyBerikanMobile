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
    required int durasiCuti,
  }) async {
    await cuti.add({
      'id_karyawan': idKaryawan,
      'username': nama,
      'jabatan': jabatan,
      'tgl_awal': tglAwal,
      'tgl_akhir': tglAkhir,
      'alasan': alasan,
      'bukti_base64': buktiBase64,
      'durasi_cuti': durasiCuti,
      'status': 'Dalam Proses',
      'created_at': FieldValue.serverTimestamp(),
    });

    final karyawanRef = FirebaseFirestore.instance
        .collection('karyawan')
        .doc(idKaryawan);

    // final doc = await karyawanRef.get();
    // if (!doc.exists) return;

    // final data = doc.data() as Map<String, dynamic>;
    // // int jatahCuti = data['jatah_cuti'] ?? 0;

    // // karyawanRef.update({'jatah_cuti': jatahCuti - durasiCuti});
  }

  Stream<QuerySnapshot> getRiwayatCutiByKaryawan(String idKaryawan) {
    return cuti
        .where('id_karyawan', isEqualTo: idKaryawan)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllCuti() {
    return cuti.orderBy('created_at', descending: true).snapshots();
  }

  Future<void> updateStatus({
    required String docId,
    required String statusBaru,
  }) async {
    await cuti.doc(docId).update({'status': statusBaru});
  }

  Future<void> deleteCuti(String id) async {
    await cuti.doc(id).delete();
  }
}
