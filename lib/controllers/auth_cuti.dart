import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceCuti {
  final CollectionReference cuti = FirebaseFirestore.instance.collection(
    'cuti',
  );

  Future<void> ajukanCuti({
    required String idKaryawan,
    required String nama,
    required String jabatan,
    required String tglMulai,
    required String tglAkhir,
    required String alasan,
    required String buktiBase64,
  }) async {
    await cuti.add({
      'id_karyawan': idKaryawan,
      'nama': nama,
      'jabatan': jabatan,
      'tgl_mulai': tglMulai,
      'tgl_akhir': tglAkhir,
      'alasan': alasan,
      'bukti': buktiBase64,
      'status': 'Dalam Proses',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getRiwayatCutiByKaryawan(String idKaryawan) {
    return cuti
        .where('id_karyawan', isEqualTo: idKaryawan)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteCuti(String id) async {
    await cuti.doc(id).delete();
  }
}
