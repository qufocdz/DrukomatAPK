import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/globals.dart';
import 'package:aplikacjadrukomat/login_page.dart';

Widget settingsPage(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(verdigris),
    appBar: AppBar(
      title: const Text("Ustawienia"),
      centerTitle: true,
      automaticallyImplyLeading: true,
      backgroundColor: const Color(midnightGreen),
      foregroundColor: const Color(electricBlue),
    ),
    body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Card(
                color: const Color(midnightGreen),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Imię i nazwisko:',
                        style:
                            TextStyle(fontSize: 16, color: Color(electricBlue)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user?['FirstName'] ?? 'Nie podano'} ${user?['LastName'] ?? 'Nie podano'}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Email:',
                        style:
                            TextStyle(fontSize: 16, color: Color(electricBlue)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user?['contact']['email'] ?? 'Nie podano'}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Numer telefonu:',
                        style:
                            TextStyle(fontSize: 16, color: Color(electricBlue)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user?['contact']['phone'] ?? 'Nie podano'}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Adres:',
                        style:
                            TextStyle(fontSize: 16, color: Color(electricBlue)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user?['contact']?['address']?['StreetAndNumber'] ?? 'Nie podano'}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user?['contact']?['address']?['PostalCode'] ?? 'Nie podano'} ${user?['contact']?['address']?['City'] ?? 'Nie podano'}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  loggedIn = false;
                  user = null;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Wyloguj się',
                  style: TextStyle(
                    color: Color(beige),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
