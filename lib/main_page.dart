import 'package:aplikacjadrukomat/globals.dart';
import 'package:aplikacjadrukomat/home_page.dart';
import 'package:aplikacjadrukomat/orders_page.dart'; // Make sure OrdersPage is imported
import 'package:aplikacjadrukomat/settings_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onDotTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildDot(int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onDotTapped(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: isSelected ? 12.0 : 8.0,
        height: isSelected ? 12.0 : 8.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? const Color(electricBlue)
              : const Color(lightSkyblue),
        ),
      ),
    );
  }

  Widget secondHomePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate directly to OrdersPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrdersPage(), // Use OrdersPage here
              ),
            );
          },
          child: Image.asset(
            'images/kartki2.png',
            height: 380.0,
            width: 240.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      homePage(context),
      secondHomePage(context),
    ];

    return Scaffold(
      backgroundColor: const Color(verdigris),
      appBar: AppBar(
        title: const Text("DrukoApp"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => settingsPage(context),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, _buildDot),
        ),
      ),
    );
  }
}
