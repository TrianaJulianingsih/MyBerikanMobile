import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServiceUser {
  final CollectionReference karyawan = FirebaseFirestore.instance.collection(
    'karyawan',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = cred.user!.uid;

    final query = await _db
        .collection('karyawan')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    await query.docs.first.reference.update({'status': 'aktif'});
    return query.docs.first;
  }

  Future<DocumentSnapshot> getUserById(String idKaryawan) async {
    return await karyawan.doc(idKaryawan).get();
  }

  Future<void> logout(String docId) async {
    await _db.collection('karyawan').doc(docId).update({
      'status': 'tidak_aktif',
    });
    await _auth.signOut();
  }
}
