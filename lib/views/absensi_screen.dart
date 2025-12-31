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
      if (mounted) setState(() => now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
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
      body: position == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: service.getTodayAbsensi(uid),
              builder: (context, snapshot) {
                final sudahAbsen =
                    snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                final data = sudahAbsen
                    ? snapshot.data!.docs.first.data() as Map<String, dynamic>
                    : {};

                final lokasi = data['lokasi'] ?? 'Lokasi tidak tersedia';

                return Stack(
                  children: [
                    /// MAP FULLSCREEN
                    FlutterMap(
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

                    /// HEADER BACKGROUND
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF1485C7),
                              Color.fromARGB(200, 20, 133, 199),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.asset(
                            "assets/images/motif.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    /// HEADER CONTENT
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 8),
                            const Text(
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
                    ),

                    /// BOTTOM SHEET
                    DraggableScrollableSheet(
                      initialChildSize: 0.18,
                      minChildSize: 0.14,
                      maxChildSize: 0.40,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(blurRadius: 10, color: Colors.black26),
                            ],
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                12,
                                20,
                                24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// HANDLE
                                  Center(
                                    child: Container(
                                      width: 40,
                                      height: 4,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),

                                  /// LOKASI + STATUS
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Lokasi",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(lokasi),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: sudahAbsen
                                              ? Colors.green
                                              : Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          sudahAbsen ? "Hadir" : "Belum",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Divider(height: 24),

                                  /// TANGGAL
                                  const Text(
                                    "Tanggal",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'dd MMM yyyy',
                                      'id_ID',
                                    ).format(now),
                                  ),

                                  const SizedBox(height: 12),

                                  /// JAM + KOORDINAT
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jam: ${DateFormat('HH:mm:ss').format(now)}",
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Latitude: ${position!.latitude.toStringAsFixed(6)}",
                                        ),
                                        Text(
                                          "Longitude: ${position!.longitude.toStringAsFixed(6)}",
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  /// BUTTON (TRY–CATCH SUDAH ADA)
                                  ElevatedButton(
                                    onPressed: sudahAbsen
                                        ? null
                                        : () async {
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
                                          },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                      backgroundColor: const Color(0xFF1485C7),
                                      disabledBackgroundColor: Colors.grey[300],
                                    ),
                                    child: Text(
                                      sudahAbsen ? "Sudah Absen" : "Check-in",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }
}
