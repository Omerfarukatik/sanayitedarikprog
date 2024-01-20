import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanayitedarikprog/drawer.dart';

class Bildirim extends StatelessWidget {
  Bildirim({Key? key}) : super(key: key);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF324553),
      appBar: AppBar(
        title: const Text(
          "Bildirimler",
          style: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme:
            IconThemeData(color: Colors.white), // Drawer simgesinin rengi
      ),
      drawer: const drawer(),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore.collection('Basvurular').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('Veri bulunamadı');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var document = snapshot.data!.docs[index];
                return _buildCard(context, document);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, QueryDocumentSnapshot<Object?> document) {
    String basvuranID = document['basvuranID'];
    String urunID = document['urunID'];
    int basvuruAdedi = document['b_adedi'];

    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserAndProductInfo(basvuranID, urunID),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (dataSnapshot.hasError) {
          return Text('Hata: ${dataSnapshot.error}');
        } else if (dataSnapshot.hasData) {
          String userName = dataSnapshot.data!['userName'];
          String productName = dataSnapshot.data!['productName'];

          return Card(
            child: ListTile(
              title: Text('Başvuran: $userName'),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ürün: $productName'),
                  Text('Başvuru Adedi: $basvuruAdedi'),
                ],
              ),
            ),
          );
        } else {
          return Text('Kullanıcı ve Ürün Bilgisi Bulunamadı');
        }
      },
    );
  }

  Future<Map<String, dynamic>> _getUserAndProductInfo(
      String basvuranID, String urunID) async {
    Map<String, dynamic> result = {};

    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(basvuranID).get();
      if (userSnapshot.exists) {
        result['userName'] = userSnapshot['isim'] ?? 'İsim Bulunamadı';
      }

      DocumentSnapshot productSnapshot =
          await _firestore.collection('urunler').doc(urunID).get();
      if (productSnapshot.exists) {
        result['productName'] = productSnapshot['urunAdi'] ?? 'Ürün Bulunamadı';
      }
    } catch (error) {
      print('Hata: $error');
    }

    return result;
  }
}
