import 'package:flutter/material.dart';
import 'package:sanayitedarikprog/components/my_button.dart';
import 'package:sanayitedarikprog/pages/sign_in.dart';
import 'package:sanayitedarikprog/pages/sign_up.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});
  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF324553),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 50,
                    ),
                    margin: const EdgeInsets.all(40),
                    height: 200,
                    child: Image.asset(
                      "assets/logo_for_project4.png",
                    ),
                  ),

                  // sign in button
                  MyButton(
                    customColor: Colors.white.withOpacity(0.7),
                    text: "Giriş Yap",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  MyButton(
                    customColor: Colors.orangeAccent,
                    text: "Hesap Oluştur",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const Spacer(),
              // Footer
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Terms of use",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
