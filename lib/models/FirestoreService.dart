import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanayitedarikprog/models/urun_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UrunModel>> getUrunlerStream() {
    return _firestore.collection('urunler').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UrunModel(
          urunID: doc.id, // Firestore'dan gelen belge ID'si
          adi: data['urunAdi'],
          fiyat: data['urunFiyat'],
          aciklama: data['urunAciklama'],
          kategori: data['urunKatagorisi'],
          resim: data['resimURL'],
          kullaniciID: data['kullaniciID'],
        );
      }).toList();
    });
  }
}

Future<void> addRequestToFirestore(String urunID, int b_adedi) async {
  try {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('Basvurular').add({
      'urunID': urunID,
      'b_adedi': b_adedi,
      'basvuranID': FirebaseAuth.instance.currentUser!.uid,
    });
  } catch (e) {
    print('Başvuru eklenirken bir hata oluştu: $e');
  }
}
