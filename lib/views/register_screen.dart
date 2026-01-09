// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:myberikan/controllers/auth_akun.dart';
// import 'login_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   static String id = '/register';

//   RegisterScreen({Key? key}) : super(key: key);

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final FirestoreServiceUser firestoreService = FirestoreServiceUser();
//   final _idController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmController = TextEditingController();

//   XFile? _pickedImage;
//   final ImagePicker _picker = ImagePicker();

//   bool _obscurePassword = true;
//   bool _obscureConfirm = true;

//   Future<void> _pickImage() async {
//     final image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _pickedImage = image;
//       });
//     }
//   }

//   Future<String> _encodeImageBase64() async {
//     final bytes = await _pickedImage!.readAsBytes();
//     return base64Encode(bytes);
//   }

//   void _register() async {
//     if (_pickedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Silakan pilih foto profil")),
//       );
//       return;
//     }

//     if (_passwordController.text != _confirmController.text) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Kata sandi tidak cocok")));
//       return;
//     }

//     try {
//       final base64Image = await _encodeImageBase64();

//       final result = await firestoreService.registerUser(
//         idKaryawan: _idController.text.trim(),
//         email: _emailController.text.trim(),
//         username: _usernameController.text.trim(),
//         password: _passwordController.text.trim(),
//         fotoBase64: base64Image,
//       );

//       if (result != 'success') {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(result)));
//         return;
//       }

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Pendaftaran berhasil!")));

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Gagal mendaftar: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: GestureDetector(
//                         onTap: _pickImage,
//                         child: CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.grey[300],
//                           backgroundImage: _pickedImage != null
//                               ? FileImage(File(_pickedImage!.path))
//                               : null,
//                           child: _pickedImage == null
//                               ? const Icon(Icons.camera_alt, size: 40)
//                               : null,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 40),
//                     const Text(
//                       'ID Karyawan',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _idController,
//                       decoration: InputDecoration(
//                         hintText: 'Masukkan ID karyawan',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Email Pengguna',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         hintText: 'Masukkan Email Pengguna',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       // keyboardType: TextInputType.emailAddress(),
//                     ),
//                     const Text(
//                       'Username',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(
//                         hintText: 'Masukkan Username',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Kata Sandi',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _passwordController,
//                       obscureText: _obscurePassword,
//                       decoration: InputDecoration(
//                         hintText: 'Masukkan kata sandi',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscurePassword
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscurePassword = !_obscurePassword;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Konfirmasi Kata Sandi',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _confirmController,
//                       obscureText: _obscureConfirm,
//                       decoration: InputDecoration(
//                         hintText: 'Ulangi kata sandi',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscureConfirm
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscureConfirm = !_obscureConfirm;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: SizedBox(
//                         width: MediaQuery.of(context).size.width / 3,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           onPressed: _register,
//                           child: const Text(
//                             'Daftar',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Sudah punya akun?',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (_) => const LoginScreen()),
//                     );
//                   },
//                   child: const Text(
//                     'Masuk',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myberikan/controllers/auth_akun.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static String id = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirestoreServiceUser firestoreService = FirestoreServiceUser();

  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _pickedImage = image);
    }
  }

  Future<String> _encodeImageBase64() async {
    final bytes = await _pickedImage!.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _register() async {
    if (_pickedImage == null) {
      _showMsg("Silakan pilih foto profil");
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      _showMsg("Kata sandi tidak cocok");
      return;
    }

    try {
      setState(() => _loading = true);

      final fotoBase64 = await _encodeImageBase64();

      final result = await firestoreService.registerUser(
        idKaryawan: _idController.text.trim(),
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        fotoBase64: fotoBase64,
      );

      if (result != 'success') {
        _showMsg(result);
        return;
      }

      _showMsg("Pendaftaran berhasil");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      _showMsg("Gagal mendaftar: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _pickedImage != null
                          ? FileImage(File(_pickedImage!.path))
                          : null,
                      child: _pickedImage == null
                          ? const Icon(Icons.camera_alt, size: 40)
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                _label("ID Karyawan"),
                _input(_idController, "Masukkan ID karyawan"),

                _label("Email"),
                _input(
                  _emailController,
                  "Masukkan email",
                  keyboard: TextInputType.emailAddress,
                ),

                _label("Username"),
                _input(_usernameController, "Masukkan username"),

                _label("Kata Sandi"),
                _password(_passwordController, _obscurePassword, () {
                  setState(() => _obscurePassword = !_obscurePassword);
                }),

                _label("Konfirmasi Kata Sandi"),
                _password(_confirmController, _obscureConfirm, () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                }),

                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 40,
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Daftar",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 6),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _input(
    TextEditingController controller,
    String hint, {
    TextInputType keyboard = TextInputType.text,
  }) =>
      TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      );

  Widget _password(
    TextEditingController controller,
    bool obscure,
    VoidCallback toggle,
  ) =>
      TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: "Masukkan kata sandi",
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon:
                Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
      );
}
