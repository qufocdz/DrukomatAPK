import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/globals.dart';
import 'package:aplikacjadrukomat/login_page.dart';

Widget settingsPage(BuildContext context) {
  return Scaffold(
    backgroundColor:
        const Color(verdigris), // Set the background color to verdigris
    appBar: AppBar(
      title: const Text("Ustawienia"),
      centerTitle: true,
      automaticallyImplyLeading: true,
      backgroundColor: const Color(midnightGreen),
      foregroundColor: const Color(electricBlue),
    ),
    body: Center(
      // Center the content
      child: SingleChildScrollView(
        // Allows scrolling if content overflows
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Let the Column take the minimum space
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Card for user information
              Card(
                color: const Color(midnightGreen),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Imię i nazwisko:',
                        style:
                            TextStyle(fontSize: 16, color: Color(electricBlue)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Michał Pakuła',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Email:',
                        style:
                            TextStyle(fontSize: 16, color: Color(electricBlue)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'michal.pakula@gmail.com',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Numer telefonu:',
                        style:
                            TextStyle(fontSize: 16, color: Color(electricBlue)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '+48 578 729 344',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Adres:',
                        style:
                            TextStyle(fontSize: 16, color: Color(electricBlue)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ul. Grundwaldzka 54,',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '50-357 Wrocław',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Log out button
              ElevatedButton(
                onPressed: () {
                  // Set loggedIn to false and navigate to LoginPage
                  loggedIn = false;
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
                    color: Colors.white,
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
