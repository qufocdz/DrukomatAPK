import 'package:aplikacjadrukomat/globals.dart';
import 'package:aplikacjadrukomat/home_page.dart';
import 'package:aplikacjadrukomat/home_page_2.dart';
import 'package:aplikacjadrukomat/home_page_3.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages;
    int cDots = 2;
    if (service == true) {
      pages = [
        homePage(context),
        secondHomePage(context),
        thirdHomePage(context, user ?? {}),
      ];
      cDots = 3;
    } else {
      pages = [
        homePage(context),
        secondHomePage(context),
      ];
      cDots = 2;
    }
    ;

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
          children: List.generate(cDots, _buildDot),
        ),
      ),
    );
  }
}
