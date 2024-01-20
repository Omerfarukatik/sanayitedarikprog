import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanayitedarikprog/models/urun_model.dart';

class ImagePickerControlLer extends GetxController {
  Rx<File> image = File('').obs;

  Future pickImage() async {
    try {
      final imagePick =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imagePick == null) {
        return;
      }
      final imageTemp = File(imagePick.path);
      image.value = imageTemp;
    } on PlatformException catch (e) {
      return e;
    }
  }

  Future<String> uploadImageToFirebase() async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    try {
      Reference reference =
          FirebaseStorage.instance.ref().child('mypicture/$fileName.png');
      await reference.putFile(image.value);
      String downloadURL = await reference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return '';
    }
  }

  Future<void> addProductToFirestore(
      String downloadURL, UrunModel urunModel) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Firestore'a ürünü ekleyin
      await firestore.collection('urunler').add({
        'resimURL': downloadURL,
        'urunAdi': urunModel.adi,
        'urunFiyat': urunModel.fiyat,
        'urunAciklama': urunModel.aciklama,
        'urunKatagorisi': urunModel.kategori,
        'kullaniciID': FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {
      print('Ürün eklenirken bir hata oluştu: $e');
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
      print('Başvuru başarıyla eklendi!');
    } catch (e) {
      print('Başvuru eklenirken bir hata oluştu: $e');
    }
  }

  void clearImage() {
    image.value = File('');
  }
}
