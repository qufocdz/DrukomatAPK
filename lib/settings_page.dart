import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/globals.dart';
import 'package:aplikacjadrukomat/login_page.dart';

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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Imię i nazwisko:',
                    style: TextStyle(fontSize: 16, color: Color(electricBlue)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${user?['FirstName']??'Nie podano'} ${user?['LastName']??''}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Email:',
                    style: TextStyle(fontSize: 16, color: Color(electricBlue)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${user?['contact']['email']}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Numer telefonu:',
                    style: TextStyle(fontSize: 16, color: Color(electricBlue)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${user?['contact']['phone']??'Nie podano'}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Adres:',
                    style: TextStyle(fontSize: 16, color: Color(electricBlue)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${user?['contact']?['address']?['StreetAndNumber']??'Nie podano'}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${user?['contact']?['address']?['PostalCode']??''} ${user?['contact']?['address']?['City']??''}',
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
              loggedIn = false;
              user=null;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Wyloguj się',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
