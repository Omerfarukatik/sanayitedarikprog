import 'package:flutter/material.dart';
import 'package:sanayitedarikprog/drawer.dart';
import 'package:sanayitedarikprog/models/FirestoreService.dart';
import 'package:sanayitedarikprog/models/urun_model.dart';
import 'urundetay.dart';

class AnaSayfa extends StatefulWidget {
  final FirestoreService _firestoreService = FirestoreService();

  AnaSayfa({Key? key}) : super(key: key);

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<UrunModel> urunListesi = [];
  List<UrunModel> filteredUrunListesi = [];
  TextEditingController kategoriController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final Stream<List<UrunModel>> dataStream =
        widget._firestoreService.getUrunlerStream();

    dataStream.listen((data) {
      setState(() {
        urunListesi = data;
        filteredUrunListesi = List.from(urunListesi);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF324553),
      appBar: AppBar(
        title: const Text(
          "Anasayfa",
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
      drawer: drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: kategoriController,
              style: TextStyle(color: Colors.orange),
              decoration: InputDecoration(
                labelText: 'Kategori Giriniz..',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.orange),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: kategoriController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.orange),
                        onPressed: () {
                          setState(() {
                            kategoriController.clear();
                            filterUrunler('');
                          });
                        },
                      )
                    : Icon(Icons.search, color: Colors.white),
              ),
              onChanged: (value) {
                filterUrunler(value);
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : buildUrunListesi(),
          ),
        ],
      ),
    );
  }

  Widget buildUrunListesi() {
    return ListView.builder(
      itemCount: filteredUrunListesi.length,
      itemBuilder: (context, index) {
        final urun = filteredUrunListesi[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => urundetay(urun: urun),
                ),
              );
            },
            child: ListTile(
              tileColor: Color.fromARGB(75, 255, 255, 255),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(urun.resim),
              ),
              title: Text('${urun.adi} - ${urun.kategori}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${urun.fiyat} TL"),
                  Text(urun.aciklama),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Ürünleri filtreleme işlevi
  void filterUrunler(String query) {
    query = query.toLowerCase();

    if (kategoriController.text.isEmpty) {
      setState(() {
        filteredUrunListesi = urunListesi;
      });
    } else {
      setState(() {
        filteredUrunListesi = urunListesi.where((urun) {
          final kategori = urun.kategori.toLowerCase();
          return kategori.contains(query);
        }).toList();
      });
    }
  }
}
