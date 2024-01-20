import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanayitedarikprog/drawer.dart';
import 'package:sanayitedarikprog/pages/urunekle.dart';

class Basvurular extends StatelessWidget {
  const Basvurular({Key? key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF324553),
      appBar: AppBar(
        title: const Text(
          "Tedariklerim",
          style: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: drawer(),
      body: FutureBuilder(
        future: getKullaniciUrunleri(user?.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }

          List<DocumentSnapshot> urunBelgeleri =
              snapshot.data as List<DocumentSnapshot>;

          return ListView.builder(
            itemCount: urunBelgeleri.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> urunData =
                  urunBelgeleri[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: Container(
                    width: 50.0, // Resmin genişliği
                    height: 50.0, // Resmin yüksekliği
                    child: Image.network(urunData['resimURL']),
                  ),
                  title: Text('Ürün Adı: ${urunData['urunAdi']}'),
                  subtitle: Text('Fiyat: ${urunData['urunFiyat']} TL'),
                  // Diğer bilgileri ekleyebilirsiniz.
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UrunEklePage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<DocumentSnapshot>> getKullaniciUrunleri(
      String? kullaniciID) async {
    QuerySnapshot urunlerQuery = await FirebaseFirestore.instance
        .collection('urunler')
        .where('kullaniciID', isEqualTo: kullaniciID)
        .get();

    return urunlerQuery.docs;
  }
}
