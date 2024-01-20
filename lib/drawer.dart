import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanayitedarikprog/bildirim.dart';
import 'package:sanayitedarikprog/pages/anasayfa.dart';
import 'package:sanayitedarikprog/pages/basvurular.dart';
import 'package:sanayitedarikprog/pages/login_or_register.dart';
import 'package:sanayitedarikprog/pages/profil.dart';
import 'package:sanayitedarikprog/pages/sign_in.dart';

class drawer extends StatelessWidget {
  const drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/SANTeam.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 16),
                Text('Profil'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const profil(),
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.home_filled),
                SizedBox(width: 16),
                Text('AnaSayfa'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnaSayfa(),
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.shopping_cart),
                SizedBox(width: 16),
                Text('Tedariklerim'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Basvurular(), //* Basvurular()
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.notifications),
                SizedBox(width: 16),
                Text('Bildirim'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Bildirim(),
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.exit_to_app),
                SizedBox(width: 16),
                Text('Çıkış Yap'),
              ],
            ),
            onTap: () {
              _signOut(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginOrRegisterPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint("Çıkış Yapıldı"); // Drawer'ı kapat
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    } catch (e) {
      print('Çıkış yaparken bir hata oluştu: $e');
    }
  }
}
