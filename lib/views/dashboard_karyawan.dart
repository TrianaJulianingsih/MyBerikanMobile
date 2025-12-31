import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myberikan/controllers/auth_absensi.dart';
import 'package:myberikan/controllers/auth_akun.dart';
import 'package:myberikan/controllers/auth_cuti.dart';
import 'package:myberikan/extension/navigation.dart';
import 'package:myberikan/views/absensi_screen.dart';
import 'package:myberikan/views/ajukan_cuti.dart';
import 'package:myberikan/views/detail_cuti_screen.dart';
import 'package:myberikan/views/laporan.dart';
import 'package:myberikan/views/login_screen.dart';
import 'package:myberikan/views/notifikasi_screen.dart';
import 'package:myberikan/views/riwayat_kehadiran.dart';
import 'package:myberikan/views/verifikasi_cuti.dart';

class DashboardKaryawan extends StatefulWidget {
  final String idKaryawan;

  const DashboardKaryawan({super.key, required this.idKaryawan});

  static String id = "/dashboard";

  @override
  State<DashboardKaryawan> createState() => _DashboardKaryawanState();
}

class _DashboardKaryawanState extends State<DashboardKaryawan> {
  final FirestoreServiceUser firestoreService = FirestoreServiceUser();
  final FirestoreServiceCuti _serviceCuti = FirestoreServiceCuti();
  final FirestoreServiceAbsensi _serviceAbsensi = FirestoreServiceAbsensi();

  DocumentSnapshot? userDoc;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final doc = await firestoreService.getUserById(widget.idKaryawan);
    setState(() {
      userDoc = doc;
      isLoading = false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final data = userDoc!.data() as Map<String, dynamic>;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1485C7),
        elevation: 8,
        icon: const Icon(Icons.fingerprint, color: Colors.white),
        label: const Text(
          "Absensi",
          style: TextStyle(fontFamily: "Poppins_SemiBold", color: Colors.white),
        ),
        onPressed: () {
          context.push(const PresenceScreen());
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1485C7),
              Color.fromARGB(255, 194, 228, 247),
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              height: 330,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  "assets/images/motif.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // IconButton(
                            //   onPressed: () {
                            //     context.push(NotifikasiScreen());
                            //   },
                            //   icon: Icon(
                            //     Icons.notifications,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            IconButton(
                              onPressed: () => _logout(context),
                              icon: Icon(Icons.logout, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Selamat Datang!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        height: 188,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(104, 0, 0, 0),
                              offset: Offset(0, 7),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: data['foto'] != null
                                    ? MemoryImage(base64Decode(data['foto']))
                                    : AssetImage("assets/images/profile 1.png")
                                          as ImageProvider,
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['username'] ?? '-',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins_Medium",
                                    ),
                                  ),
                                  Text(
                                    data['jabatan'] ?? '-',
                                    style: TextStyle(
                                      fontFamily: "Poppins_Medium",
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "ID: ${widget.idKaryawan}",
                                    style: TextStyle(
                                      fontFamily: "Poppins_Regular",
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: _serviceAbsensi
                                .getRiwayatKehadiranByKaryawan(),
                            builder: (context, snapshot) {
                              int hadir = 0;
                              int totalHariKerja = 22;

                              if (snapshot.hasData) {
                                hadir = snapshot.data!.docs.length;
                              }

                              final absen = totalHariKerja - hadir;

                              return GestureDetector(
                                onTap: () {
                                  context.push(RiwayatKehadiranPage());
                                },
                                child: _buildPieCard(
                                  title: "Absensi",
                                  sections: [
                                    PieChartSectionData(
                                      value: hadir.toDouble(),
                                      color: const Color(0xFF1485C7),
                                      showTitle: false,
                                      radius: 25,
                                    ),
                                    PieChartSectionData(
                                      value: absen.toDouble(),
                                      color: Colors.grey.shade300,
                                      showTitle: false,
                                      radius: 25,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          StreamBuilder<QuerySnapshot>(
                            stream: _serviceCuti.getRiwayatCutiByKaryawan(
                              widget.idKaryawan,
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return _buildPieCard(
                                  title: 'Cuti',
                                  sections: [
                                    PieChartSectionData(
                                      value: 0,
                                      color: Colors.blue,
                                      radius: 25,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      value: 0,
                                      color: Colors.grey.shade300,
                                      radius: 25,
                                      showTitle: false,
                                    ),
                                  ],
                                );
                              }

                              final docs = snapshot.data!.docs;
                              int totalCuti = 12;
                              final num total = docs
                                  .where((d) => d['status'] == 'Disetujui')
                                  .fold(
                                    0,
                                    (sum, d) => sum + (d['durasi_cuti'] ?? 0),
                                  );

                              int cutiDiambil = total.toInt();

                              int sisaCuti = totalCuti - cutiDiambil;

                              return GestureDetector(
                                onTap: () async {
                                  final snapshot = await FirebaseFirestore
                                      .instance
                                      .collection('cuti')
                                      .where(
                                        'id_karyawan',
                                        isEqualTo: widget.idKaryawan,
                                      )
                                      .orderBy('created_at', descending: true)
                                      .limit(1)
                                      .get();

                                  if (snapshot.docs.isNotEmpty) {
                                    final latestCuti = snapshot.docs.first;
                                    context.push(
                                      RiwayatCutiPage(
                                        idKaryawan: widget.idKaryawan,
                                      ),
                                    );
                                  } else {
                                    // Kalau tidak ada cuti
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Belum ada data cuti'),
                                      ),
                                    );
                                  }
                                },
                                child: _buildPieCard(
                                  title: 'Cuti',
                                  sections: [
                                    PieChartSectionData(
                                      value: cutiDiambil.toDouble(),
                                      color: Colors.blue,
                                      radius: 25,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      value: sisaCuti.toDouble(),
                                      color: Colors.grey.shade300,
                                      radius: 25,
                                      showTitle: false,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          context.push(
                            RiwayatCutiPage(idKaryawan: widget.idKaryawan),
                          );
                        },
                        child: Container(
                          height: 77,
                          width: 380,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 0.5,
                              color: Color.fromARGB(255, 222, 221, 221),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 2,
                                color: Color.fromARGB(255, 222, 221, 221),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Mengajukan cuti",
                                    style: TextStyle(
                                      fontFamily: "Poppins_SemiBold",
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/icons/calendar-add.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Riwayat Pengajuan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins_Medium",
                        ),
                      ),
                      SizedBox(height: 10),
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/motif 2.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: _serviceCuti.getRiwayatCutiByKaryawan(
                              widget.idKaryawan,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text("Belum ada pengajuan cuti"),
                                );
                              }

                              final docs = snapshot.data!.docs;

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      docs[index].data()
                                          as Map<String, dynamic>;

                                  final alasan = data['alasan'] ?? '-';
                                  final status = data['status'] ?? '-';
                                  final tglAwal = data['tgl_awal'] ?? '-';
                                  final tglAkhir = data['tgl_akhir'] ?? '-';

                                  return Card(
                                    color: Color.fromARGB(
                                      255,
                                      168,
                                      241,
                                      255,
                                    ).withOpacity(0.5),
                                    child: ListTile(
                                      title: Text(
                                        alasan,
                                        style: TextStyle(
                                          fontFamily: "Poppins_Medium",
                                          fontSize: 13,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "$tglAwal - $tglAkhir",
                                        style: TextStyle(
                                          fontFamily: "Poppins_Regular",
                                          fontSize: 13,
                                        ),
                                      ),
                                      trailing: Text(
                                        status,
                                        style: TextStyle(
                                          color: status == "Disetujui"
                                              ? Colors.green
                                              : status == "Ditolak"
                                              ? Colors.red
                                              : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Poppins_SemiBold",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieCard({
    required String title,
    required List<PieChartSectionData> sections,
  }) {
    final double progressValue = sections.isNotEmpty ? sections.first.value : 0;

    return Container(
      height: 189,
      width: 166,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 0.2),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 90,
              width: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: sections,
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                  ),
                  Text(
                    '${progressValue.toInt()}%',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins_SemiBold",
                      color: Color(0xFF656464),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins_Medium",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(String title, String assetIcon) {
    return Container(
      height: 77,
      width: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 0.5,
          color: Color.fromARGB(255, 222, 221, 221),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 2,
            color: Color.fromARGB(255, 222, 221, 221),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              title,
              style: TextStyle(fontFamily: "Poppins_SemiBold"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(assetIcon),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
