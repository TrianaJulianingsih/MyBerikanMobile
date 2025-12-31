import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirestoreServiceAbsensi {
  final CollectionReference absensi = FirebaseFirestore.instance.collection(
    'absensi',
  );

  DateTime _todayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Stream<QuerySnapshot> getTodayAbsensi(String id) {
    return absensi
        .where('id_karyawan', isEqualTo: id)
        .where('tanggal', isEqualTo: Timestamp.fromDate(_todayDate()))
        .snapshots();
  }

  Stream<QuerySnapshot> getAbsensiBulanan(String id) {
    return absensi.where('id_karyawan', isEqualTo: id).snapshots();
  }

  Future<void> checkIn({required double lat, required double lng}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'User belum login';

    final uid = user.uid;
    final now = DateTime.now();

    if (now.hour >= 20) {
      throw 'Check-in hanya sampai jam 20:00';
    }
    final todayTimestamp = Timestamp.fromDate(_todayDate());
    final cek = await absensi
        .where('id_karyawan', isEqualTo: uid)
        .where('tanggal', isEqualTo: todayTimestamp)
        .get();

    if (cek.docs.isNotEmpty) {
      throw 'Sudah absen hari ini';
    }

    await absensi.add({
      'id_karyawan': uid,
      'tanggal': todayTimestamp,
      'jam': DateFormat('HH:mm').format(now),
      'latitude': lat,
      'longitude': lng,
      'status': 'Hadir',
      'created_at': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getRiwayatKehadiranByKaryawan() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return absensi.where('id_karyawan', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot> getAllAbsensi() {
    return absensi.orderBy('tanggal', descending: true).snapshots();
  }
}
