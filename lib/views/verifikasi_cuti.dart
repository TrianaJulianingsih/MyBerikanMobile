import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myberikan/controllers/auth_cuti.dart';
import 'detail_cuti_screen.dart';

List<String> monthNames = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

class VerifikasiCutiScreen extends StatefulWidget {
  const VerifikasiCutiScreen({super.key});

  @override
  State<VerifikasiCutiScreen> createState() => _VerifikasiCutiScreenState();
}

class _VerifikasiCutiScreenState extends State<VerifikasiCutiScreen> {
  final FirestoreServiceCuti _cutiService = FirestoreServiceCuti();

  String selectedTab = 'Verifikasi';
  String selectedMonth = monthNames[DateTime.now().month - 1];

  DateTime? parseTanggal(dynamic value) {
    if (value is Timestamp) return value.toDate();

    if (value is String && value.contains('/')) {
      try {
        final p = value.split('/');
        return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabRow(),
          Divider(color: Colors.grey.shade300, height: 1),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: StreamBuilder<QuerySnapshot>(
                stream: _cutiService.getAllCuti(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _emptyText();
                  }

                  final docs = snapshot.data!.docs.where((doc) {
                    final status = doc['status'];
                    final date = parseTanggal(doc['tgl_awal']);
                    if (date == null) return false;

                    final namaBulan = monthNames[date.month - 1];

                    if (selectedTab == 'Verifikasi') {
                      return status == 'Dalam Proses';
                    } else {
                      return (status == 'Disetujui' || status == 'Ditolak') &&
                          namaBulan == selectedMonth;
                    }
                  }).toList();

                  if (docs.isEmpty) return _emptyText();

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _userCard(docs[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 88,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1485C7), Color.fromARGB(255, 126, 203, 248)],
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/motif.png'),
          fit: BoxFit.cover,
          opacity: 0.93,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Verifikasi Cuti',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: "Poppins_Bold",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _tabButton('Verifikasi'),
          SizedBox(width: 20),
          _tabButton('Riwayat'),
          Spacer(),
          if (selectedTab == 'Riwayat')
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedMonth,
                    items: monthNames
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => selectedMonth = v);
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tabButton(String label) {
    final active = selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = label),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: active ? FontWeight.w800 : FontWeight.w500,
          color: active ? Colors.black : Colors.grey,
          fontSize: 18,
          fontFamily: "Poppins_reguler",
        ),
      ),
    );
  }

  Widget _userCard(QueryDocumentSnapshot data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailCutiScreen(cutiData: data)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['username'],
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Poppins_Bold",
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    data['id_karyawan'],
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            if (selectedTab == 'Riwayat')
              Text(
                data['status'],
                style: TextStyle(
                  color: data['status'] == 'Disetujui'
                      ? Colors.green
                      : Colors.red,
                  fontFamily: "Poppins_Bold",
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _emptyText() {
    return Center(
      child: Text(
        selectedTab == 'Verifikasi'
            ? 'Tidak ada cuti pending'
            : 'Tidak ada riwayat untuk bulan $selectedMonth',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontFamily: "Poppins_reguler",
        ),
      ),
    );
  }
}
