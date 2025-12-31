import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class FirestoreServiceAbsensi {
  final CollectionReference absensi = FirebaseFirestore.instance.collection(
    'absensi',
  );

  // =========================
  // KONFIGURASI AREA TEL-U
  // =========================
  static const double _teluLat = -6.9730;
  static const double _teluLng = 107.6305;
  static const double _maxRadiusMeter = 200;

  // =========================
  // UTIL: tanggal hari ini (00:00)
  // =========================
  DateTime _todayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // =========================
  // UTIL: reverse geocoding
  // =========================
  Future<String> _getLokasiFromCoordinate(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return 'Lokasi tidak diketahui';

      final place = placemarks.first;

      final name = place.name ?? '';
      final subLocality = place.subLocality ?? '';
      final locality = place.locality ?? '';

      return [
        name,
        subLocality,
        locality,
      ].where((e) => e.isNotEmpty).join(', ');
    } catch (_) {
      return 'Lokasi tidak tersedia';
    }
  }

  // =========================
  // UTIL: validasi radius Tel-U
  // =========================
  void _validateRadiusTelU(double userLat, double userLng) {
    final distance = Geolocator.distanceBetween(
      userLat,
      userLng,
      _teluLat,
      _teluLng,
    );

    if (distance > _maxRadiusMeter) {
      throw 'Anda harus berada di area Telkom University untuk melakukan absensi';
    }
  }

  // =========================
  // GET: absensi hari ini
  // =========================
  Stream<QuerySnapshot> getTodayAbsensi(String id) {
    return absensi
        .where('id_karyawan', isEqualTo: id)
        .where('tanggal', isEqualTo: Timestamp.fromDate(_todayDate()))
        .snapshots();
  }

  // =========================
  // GET: absensi bulanan
  // =========================
  Stream<QuerySnapshot> getAbsensiBulanan(String id) {
    return absensi.where('id_karyawan', isEqualTo: id).snapshots();
  }

  // =========================
  // ACTION: CHECK-IN ABSENSI
  // =========================
  Future<void> checkIn({required double lat, required double lng}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw 'User belum login';
    }

    final uid = user.uid;
    final now = DateTime.now();

    // ⏰ batas jam check-in
    if (now.hour >= 20) {
      throw 'Check-in hanya sampai jam 20:00';
    }

    final todayTimestamp = Timestamp.fromDate(_todayDate());

    // 🔁 validasi 1x absen per hari
    final cek = await absensi
        .where('id_karyawan', isEqualTo: uid)
        .where('tanggal', isEqualTo: todayTimestamp)
        .get();

    if (cek.docs.isNotEmpty) {
      throw 'Anda sudah melakukan absensi hari ini';
    }

    // 📍 validasi lokasi Telkom University (radius)
    _validateRadiusTelU(lat, lng);

    // 🧭 ambil nama lokasi
    final lokasi = await _getLokasiFromCoordinate(lat, lng);

    // 💾 simpan ke Firestore
    await absensi.add({
      'id_karyawan': uid,
      'tanggal': todayTimestamp,
      'jam': DateFormat('HH:mm').format(now),
      'latitude': lat,
      'longitude': lng,
      'lokasi': lokasi,
      'status': 'Hadir',
      'created_at': Timestamp.now(),
    });
  }

  // =========================
  // GET: riwayat user login
  // =========================
  Stream<QuerySnapshot> getRiwayatKehadiranByKaryawan() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return absensi.where('id_karyawan', isEqualTo: uid).snapshots();
  }

  // =========================
  // GET: semua absensi (admin)
  // =========================
  Stream<QuerySnapshot> getAllAbsensi() {
    return absensi.orderBy('tanggal', descending: true).snapshots();
  }
}
