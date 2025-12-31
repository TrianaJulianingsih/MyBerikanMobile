import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myberikan/controllers/auth_absensi.dart';

class PresenceScreen extends StatefulWidget {
  const PresenceScreen({super.key});

  @override
  State<PresenceScreen> createState() => _PresenceScreenState();
}

class _PresenceScreenState extends State<PresenceScreen> {
  final FirestoreServiceAbsensi service = FirestoreServiceAbsensi();
  Position? position;
  late DateTime now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _getLocation();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1485C7),
              Color.fromARGB(255, 194, 228, 247),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            /// BACKGROUND MOTIF
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    "assets/images/motif.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            /// CONTENT
            SafeArea(
              child: position == null
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                      stream: service.getTodayAbsensi(uid),
                      builder: (context, snapshot) {
                        final sudahAbsen =
                            snapshot.hasData && snapshot.data!.docs.isNotEmpty;
                        final canCheckIn = now.hour < 23 && !sudahAbsen;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children:[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Absensi",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// MAP
                            Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                              ),
                              child: ClipRRect(
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: LatLng(
                                      position!.latitude,
                                      position!.longitude,
                                    ),
                                    initialZoom: 17,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      userAgentPackageName: 'com.myberikan.app',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: LatLng(
                                            position!.latitude,
                                            position!.longitude,
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: const Icon(
                                            Icons.location_pin,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _infoTile(
                              "Tanggal",
                              DateFormat('dd MMM yyyy', 'id_ID').format(now),
                            ),
                            _infoTile(
                              "Jam",
                              DateFormat('HH:mm:ss').format(now),
                            ),
                            _infoTile(
                              "Latitude",
                              position!.latitude.toStringAsFixed(6),
                            ),
                            _infoTile(
                              "Longitude",
                              position!.longitude.toStringAsFixed(6),
                            ),
                            _infoTile(
                              "Status",
                              sudahAbsen ? "Hadir" : "Belum Absen",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  backgroundColor: const Color(0xFF1485C7),
                                ),
                                onPressed: canCheckIn
                                    ? () async {
                                        try {
                                          await service.checkIn(
                                            lat: position!.latitude,
                                            lng: position!.longitude,
                                          );

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Check-in berhasil",
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                            ),
                                          );
                                        }
                                      }
                                    : null,
                                child: Text(
                                  sudahAbsen
                                      ? "Sudah Absen"
                                      : now.hour >= 23
                                      ? "Check-in Ditutup"
                                      : "Check-in",
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return ListTile(title: Text(title), subtitle: Text(value));
  }
}
