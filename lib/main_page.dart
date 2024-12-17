import 'package:aplikacjadrukomat/globals.dart';
import 'package:aplikacjadrukomat/home_page.dart';
import 'package:aplikacjadrukomat/map_page.dart';
import 'package:aplikacjadrukomat/orders_page.dart';
import 'package:aplikacjadrukomat/settings_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      homePage(context),
      mapPage(context),
      ordersPage(context),
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
        unselectedItemColor: const Color(lightSkyblue),
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
