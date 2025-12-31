import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myberikan/views/dashboard.dart';
import 'package:myberikan/views/dashboard_karyawan.dart';
import 'package:myberikan/views/login_screen.dart';

class RoleRedirect extends StatelessWidget {
  const RoleRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return LoginScreen();
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('karyawan')
          .where('uid', isEqualTo: user.uid)
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
            body: Center(child: Text('Data user tidak ditemukan')),
          );
        }

        final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;

        final role = data['jabatan'];
        final idKaryawan = data['id_karyawan'];

        if (role == 'HR') {
          return DashboardHR(idHR: idKaryawan);
        } else {
          return DashboardKaryawan(idKaryawan: idKaryawan);
        }
      },
    );
  }
}
