import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceUser {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'akun',
  );
  Future<void> addUser(String idKaryawan, String username, String password, String imageUrl) {
    return users.add({
      'id_karyawan': idKaryawan,
      'username': username,
      'password': password,
      'imageUrl': imageUrl,
    });
  }

  Stream<QuerySnapshot> getUser() {
    return users.snapshots();
  }

  Future<void> updateUser(
    String idUser,
    String idKaryawan,
    String username,
    String password,
  ) {
    return users.doc(idUser).update({
      'id_karyawan': idKaryawan,
      'username': username,
      'password': password,
    });
  }

  Future<void> deleteUser(String id) {
    return users.doc(id).delete();
  }
}
