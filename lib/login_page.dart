import 'package:flutter/material.dart';
import 'globals.dart';
import 'package:aplikacjadrukomat/main_page.dart';
import 'package:aplikacjadrukomat/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return !loggedIn
        ? Scaffold(
            backgroundColor: const Color(verdigris),
            appBar: AppBar(
              title: const Text("Logowanie"),
              centerTitle: true,
              backgroundColor: const Color(midnightGreen),
              foregroundColor: const Color(electricBlue),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(richBlack),
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(richBlack),
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Color(richBlack),
                      ),
                      labelStyle: TextStyle(color: Color(richBlack)),
                    ),
                    cursorColor: Color(midnightGreen),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Hasło",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(richBlack),
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(richBlack),
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(richBlack),
                      ),
                      labelStyle: TextStyle(color: Color(richBlack)),
                    ),
                    cursorColor: Color(midnightGreen),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loggedIn = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(midnightGreen),
                      foregroundColor: const Color(electricBlue),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text("Zaloguj"),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(richBlack), // Text color
                    ),
                    child: const Text(
                      "Nie masz konta? Kliknij tutaj, aby się zarejestrować.",
                    ),
                  ),
                ],
              ),
            ),
          )
        : const MainPage();
  }
}
