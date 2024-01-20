import 'package:cloud_firestore/cloud_firestore.dart';

class UrunModel {
  final String urunID;
  final String adi;
  final double fiyat;
  final String aciklama;
  final String kategori;
  final String resim;
  final String kullaniciID;

  UrunModel({
    required this.urunID,
    required this.adi,
    required this.fiyat,
    required this.aciklama,
    required this.kategori,
    required this.resim,
    required this.kullaniciID,
  });

  factory UrunModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UrunModel(
      urunID: doc.id,
      adi: data['urunAdi'] ?? '',
      fiyat: (data['urunFiyat'] ?? 0).toDouble(),
      aciklama: data['urunAciklama'] ?? '',
      kategori: data['urunKatagorisi'] ?? '',
      resim: data['resimURL'] ?? '',
      kullaniciID: data['kullaniciID'] ?? '',
    );
  }
}
