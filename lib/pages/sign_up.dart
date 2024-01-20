import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanayitedarikprog/components/my_button.dart';
import 'package:sanayitedarikprog/components/my_text_field.dart';
import 'package:sanayitedarikprog/pages/sign_in.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => SignUpState();
}

late FirebaseAuth auth;

class SignUpState extends State<SignUp> {
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User oturumu kapalı');
      } else {
        debugPrint(
            'User oturum açık ${user.email} ve email durumu ${user.emailVerified}');
      }
    });
  }

  TextEditingController kurumadicontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController sifrecontroller = TextEditingController();
  TextEditingController sifrekontrolcontroller = TextEditingController();
  TextEditingController isimcontroller = TextEditingController();
  TextEditingController soyisimcontroller = TextEditingController();

  bool showPass = false;
  bool showConfirm = false;
  showConfPass() {
    setState(() {
      showConfirm = !showConfirm;
    });
  }

  showPassword() {
    setState(() {
      showPass = !showPass;
    });
  }

  Future<void> veriEklemeAdd(BuildContext context, String email, String isim,
      String soyad, String kurumAdi, String userUid) async {
    Map<String, dynamic> eklenecekUser = <String, dynamic>{};

    eklenecekUser['isim'] = isim;
    eklenecekUser['soyad'] = soyad;
    eklenecekUser['email'] = email;
    eklenecekUser['kurumAdi'] = kurumAdi;

    try {
      await firestore.collection('users').doc(userUid).set(eklenecekUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('Kayıt Başarılı',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('UPPSSS! Bir Hata Meydana Geldi.',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 1),
        ),
      );
      print('Hata: $e');
    }
  }

  void createUserEmailAndPassword(
      BuildContext context, String email, String sifre) async {
    try {
      var userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: sifre);
      var myUser = userCredential.user;

      if (!myUser!.emailVerified) {
        await myUser.sendEmailVerification();

        await veriEklemeAdd(context, email, isimcontroller.text,
            soyisimcontroller.text, kurumadicontroller.text, myUser.uid);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInPage(),
          ),
        );
      } else {
        debugPrint('Kullanıcının maili onaylanmış, ilgili sayfaya gidebilir.');
      }

      debugPrint(userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hesap Oluştur",
          style: TextStyle(color: Colors.orangeAccent),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF324553),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              MyTextField(
                hintText: "İsim",
                controller: isimcontroller,
              ),
              const SizedBox(height: 8),
              MyTextField(
                hintText: "Soyisim",
                controller: soyisimcontroller,
              ),
              const SizedBox(height: 8),
              MyTextField(
                hintText: "E-mail",
                controller: emailcontroller,
              ),
              const SizedBox(height: 8),
              MyTextField(
                hintText: "Kurum Adı",
                controller: kurumadicontroller,
              ),
              const SizedBox(height: 8),
              MyTextField(
                hintText: "Şifre",
                controller: sifrecontroller,
                onPressed: showPassword,
                icon: showPass ? Icons.visibility_off : Icons.visibility,
                obscureText: showPass ? false : true,
              ),
              const SizedBox(height: 8),
              MyTextField(
                hintText: "Şifreyi Onayla",
                controller: sifrekontrolcontroller,
                onPressed: showConfPass,
                icon: showConfirm ? Icons.visibility_off : Icons.visibility,
                obscureText: showConfirm ? false : true,
              ),
              const SizedBox(height: 15),
              MyButton(
                customColor: Colors.orangeAccent,
                text: "Kayıt Ol",
                onTap: () {
                  String email = emailcontroller.text;
                  String isim = isimcontroller.text;
                  String soyad = soyisimcontroller.text;
                  String kurumAdi = kurumadicontroller.text;
                  String sifre = sifrecontroller.text;
                  String sifrekontrol = sifrekontrolcontroller.text;

                  if (email == "" ||
                      isim == "" ||
                      soyad == "" ||
                      kurumAdi == "" ||
                      sifre == "" ||
                      sifrekontrol == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.orangeAccent,
                        content: Text(
                          'UPPSSS! Bir Hata Meydana Geldi. Her Yeri Doldurun!!',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    // Firestore belgesini güncellemek için createUserEmailAndPassword fonksiyonunu çağırın
                    createUserEmailAndPassword(context, email, sifre);
                  }
                },
              ),
              const SizedBox(height: 15),
              const Text(
                "şununla Kaydol",
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Zaten Bir Hesabınız Var mı ?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Giriş Yap",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
