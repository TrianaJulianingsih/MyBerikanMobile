import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceAbsensi {
  final CollectionReference absensi = FirebaseFirestore.instance.collection(
    'absensi',
  );
  Future<void> addAbsensi(String idKaryawan, String tglKehadiran, String statusKehadiran, String deskripsi) {
    return absensi.add({
      'idKaryawan': idKaryawan,
      'tgl_kehadiran': tglKehadiran,
      'status_kehadiran': statusKehadiran,
      'deskripsi': deskripsi,
    });
  }

  Stream<QuerySnapshot> getAbsensi() {
    return absensi.snapshots();
  }

  Future<void> updateAbsensi(
    String idAbsensi,
    // String idKaryawan,
    String tglKehadiran,
    String statusKehadiran,
    String deskripsi,
  ) {
    return absensi.doc(idAbsensi).update({
      'tgl_kehadiran': FieldValue.serverTimestamp(),
      'status_kehadiran': statusKehadiran,
      'deskripsi': deskripsi,
    });
  }

  Future<void> deleteAbsensi(String id) {
    return absensi.doc(id).delete();
  }
}
