import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanayitedarikprog/drawer.dart';

class profil extends StatefulWidget {
  const profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<profil> {
  String kullaniciEmail = ''; 

  String userEmail = '';
  String kurumAdi = '';
  String isim = '';
  String soyad = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? kullanici = auth.currentUser;

    if (kullanici != null) {
      setState(() {
        kullaniciEmail = kullanici.email ?? '';
      });

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: kullaniciEmail)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            querySnapshot.docs.first;

        setState(() {
          userEmail = snapshot['email'] ?? '';
          kurumAdi = snapshot['kurumAdi'] ?? '';
          isim = snapshot['isim'] ?? '';
          soyad = snapshot['soyad'] ?? '';
        });
      } else {
        print("Belirtilen belge mevcut değil.");
      }
    } else {
      print("Kullanıcı oturumu açmış değil");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF324553),
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const drawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors
                  .orangeAccent, 
              child: Icon(
                Icons.person,
                size: 60,
                color:
                    Colors.white, 
              ),
            ),
            const SizedBox(height: 16.0),
            _buildInfoTile("Profil", userEmail, Icons.mail),
            _buildInfoTile("Kurum Adı", kurumAdi, Icons.business),
            _buildInfoTile("İsim", isim, Icons.person),
            _buildInfoTile("Soyisim", soyad, Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(label, style: const TextStyle(fontSize: 16)),
        subtitle: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
