import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceKaryawan {
  final CollectionReference karyawan = FirebaseFirestore.instance.collection(
    'karyawan',
  );
  Future<void> addKaryawan(String name, String jabatan, int jatah_cuti) {
    return karyawan.add({
      'name': name,
      'jabatan': jabatan,
      'jatah_cuti': jatah_cuti,
    });
  }

  Stream<QuerySnapshot> getKaryawan() {
    return karyawan.snapshots();
  }

  Future<void> updateKaryawan(
    String id,
    String name,
    String jabatan,
    int jatah_cuti,
  ) {
    return karyawan.doc(id).update({
      'name': name,
      'jabatan': jabatan,
      'jatah_cuti': jatah_cuti,
    });
  }

  Future<void> deleteKaryawan(String id) {
    return karyawan.doc(id).delete();
  }
}
