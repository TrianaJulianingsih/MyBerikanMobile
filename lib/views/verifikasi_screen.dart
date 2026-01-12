// import 'package:flutter/material.dart';

// class VerifikasiScreen extends StatefulWidget {
//   const VerifikasiScreen({super.key});

//   @override
//   State<VerifikasiScreen> createState() => _VerifikasiScreenState();
// }

// class _VerifikasiScreenState extends State<VerifikasiScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF1485C7),
//               Color.fromARGB(255, 194, 228, 247),
//               Colors.white,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               height: 330,
//               child: Opacity(
//                 opacity: 0.6,
//                 child: Image.asset(
//                   "assets/images/motif.png",
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SafeArea(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Icon(Icons.notifications, color: Colors.white),
//                       ),
//                       Text(
//                         "Verifikasi Cuti",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       );
//   }
// }