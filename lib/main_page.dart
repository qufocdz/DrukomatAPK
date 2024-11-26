import 'package:aplikacjadrukomat/globals.dart';
import 'package:aplikacjadrukomat/login_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final Widget homePage = const Center(
    child: Text(
      'Główna',
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
  );

  final Widget mapPage = const Center(
    child: Text(
      'Mapa',
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
  );

  final Widget ordersPage = const Center(
    child: Text(
      'Zamówienia',
      style: TextStyle(fontSize: 24, color: Colors.white),
    ),
  );

  Widget settingsPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Card(
              color: const Color(midnightGreen),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Imię i nazwisko:',
                      style:
                          TextStyle(fontSize: 16, color: Color(electricBlue)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jan Kowalski',
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
                      'jan.kowalski@example.com',
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
                      '+48 123 456 789',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to the login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Wyloguj się',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      homePage,
      mapPage,
      ordersPage,
      settingsPage(context),
    ];
    return Scaffold(
      backgroundColor: const Color(verdigris),
      appBar: AppBar(
        title: const Text("DrukoApp"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(electricBlue),
        unselectedItemColor: const Color(lighSkyblue),
        backgroundColor: const Color(midnightGreen),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Główna',
            icon: Icon(Icons.home),
            backgroundColor: Color(midnightGreen),
          ),
          BottomNavigationBarItem(
            label: 'Mapa',
            icon: Icon(Icons.add_location_rounded),
            backgroundColor: Color(midnightGreen),
          ),
          BottomNavigationBarItem(
            label: 'Zamówienia',
            icon: Icon(Icons.text_snippet),
            backgroundColor: Color(midnightGreen),
          ),
          BottomNavigationBarItem(
            label: 'Ustawienia',
            icon: Icon(Icons.settings),
            backgroundColor: Color(midnightGreen),
          ),
        ],
      ),
    );
  }
}
