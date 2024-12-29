import 'package:flutter/material.dart';
import 'globals.dart';
import 'main_page.dart';
import 'register_page.dart';
import 'mongodb.dart'; // MongoDB helper class for connection

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog("Wprowadź zarówno email, jak i hasło.");
      return;
    }

  try{
      await MongoDB.findUser(email, password);
      if (user != null) {
        print("Login successful: ${user?['contact']['email']}");

        setState(() {
          loggedIn = true;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        showErrorDialog("Nieprawidłowy email lub hasło.");
        user=null;
      }
  }catch (e) {
      print("Login error: $e");
      showErrorDialog("Logowanie się nie powiodło. Spróbuj ponownie później.");
    }
    
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Błąd"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !loggedIn
        ? Scaffold(
            backgroundColor: const Color(verdigris),
            appBar: AppBar(
              title: const Text("Logowanie"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: const Color(midnightGreen),
              foregroundColor: const Color(electricBlue),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
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
                    cursorColor: const Color(midnightGreen),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
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
                    cursorColor: const Color(midnightGreen),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: loginUser,
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
                      foregroundColor: const Color(richBlack),
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
