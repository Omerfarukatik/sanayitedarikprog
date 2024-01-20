import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanayitedarikprog/drawer.dart';

class KurumDetay extends StatefulWidget {
  KurumDetay({Key? key, required String kullaniciID}) : super(key: key);

  @override
  _KurumDetayState createState() => _KurumDetayState();
}

class _KurumDetayState extends State<KurumDetay> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String kullaniciID;

  User? _user;
  late String _userEmail;
  late String _userName;
  late String _userSurname;
  late String _userCompanyName;
  // late String _userImageUrl;
  _KurumDetayState() {
    _userName = '';
    _userSurname = '';
    _userCompanyName = '';
    _userEmail = '';
    _getUserData();
  }
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      _userEmail = _user!.email!;

      QuerySnapshot urunlarSnapshot =
          await _firestore.collection('urunler').get();

      if (urunlarSnapshot.docs.isNotEmpty) {
        var urunBelgesi = urunlarSnapshot.docs[0];
        var kullaniciID = urunBelgesi['kullaniciID'];

        debugPrint('Kullanıcı ID: $kullaniciID');

        DocumentSnapshot userData =
            await _firestore.collection('users').doc(kullaniciID).get();
        if (userData.exists) {
          setState(() {
            _userName = userData['isim'];
            _userSurname = userData['soyad'];
            _userCompanyName = userData['kurumAdi'];
            _userEmail = userData['email'];
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF324553),
      appBar: AppBar(
        title: const Text(
          "Kurum Detay",
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
            CircleAvatar(
              radius: 50,
            ),
            SizedBox(height: 16.0),
            _buildInfoTile(
                "İsim Soyisim", "$_userName $_userSurname", Icons.person),
            _buildInfoTile("Kurum Adı", _userCompanyName, Icons.business),
            _buildInfoTile("E-posta", _userEmail, Icons.mail),
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
        // subtitle: Text(value ?? "", style: const TextStyle(fontSize: 18)),
        subtitle: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
