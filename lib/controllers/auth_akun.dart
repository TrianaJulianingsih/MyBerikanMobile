import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceUser {
  final CollectionReference karyawan = FirebaseFirestore.instance.collection(
    'karyawan',
  );

  Future<String> registerUser({
    required String idKaryawan,
    required String username,
    required String password,
    required String fotoBase64,
  }) async {
    final docRef = karyawan.doc(idKaryawan);
    final doc = await docRef.get();

    if (!doc.exists) {
      return 'ID karyawan tidak ditemukan';
    }

    final data = doc.data() as Map<String, dynamic>;
    final existingUsername = data['username'];

    if (existingUsername != null && existingUsername.toString().isNotEmpty) {
      return 'ID karyawan sudah terdaftar';
    }

    await docRef.update({
      'username': username,
      'password': password,
      'foto': fotoBase64,
      'status': 'tidak_aktif',
    });

    return 'success';
  }

  Future<DocumentSnapshot?> loginUser({
    required String username,
    required String password,
  }) async {
    final query = await karyawan
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final userDoc = query.docs.first;

    await userDoc.reference.update({'status': 'aktif'});

    return userDoc;
  }

  Future<DocumentSnapshot> getUserById(String idKaryawan) async {
    return await karyawan.doc(idKaryawan).get();
  }

  Future<void> logout(String idKaryawan) async {
    await karyawan.doc(idKaryawan).update({'status': 'tidak_aktif'});
  }
}
