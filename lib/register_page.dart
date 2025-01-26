import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_page.dart';
import 'mongodb.dart'; // MongoDB helper class for connection
import 'globals.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool agreeToTerms = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // New controllers for separate address fields
  final TextEditingController streetAndNumberController =
      TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  Future<void> registerUser() async {
    if (!agreeToTerms) {
      showErrorDialog("Musisz wyrazić zgodę na warunki użytkowania.");
      return;
    }

    // Check if all fields are filled
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        streetAndNumberController.text.isEmpty ||
        postalCodeController.text.isEmpty ||
        cityController.text.isEmpty ||
        countryController.text.isEmpty) {
      showErrorDialog("Wszystkie pola muszą być wypełnione.");
      return;
    }

    // Email validation
    final email = emailController.text;
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) {
      showErrorDialog("Podaj prawidłowy adres email.");
      return;
    }

    // Phone number validation
    final phone = phoneController.text;
    if (!RegExp(r"^[0-9]+$").hasMatch(phone)) {
      showErrorDialog("Podaj prawidłowy numer telefonu (tylko cyfry).");
      return;
    }

    try {
      // Check if an account with the provided email already exists
      var existingUser =
          await MongoDB.userCollection.findOne({"contact.email": email});
      if (existingUser != null) {
        showErrorDialog("Konto z tym adresem email już istnieje.");
        return;
      }

      // Split the name into first name and last name
      var nameParts = nameController.text.split(" ");
      String firstName = nameParts[0];
      String lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

      // Prepare user data
      final userData = {
        "FirstName": firstName,
        "LastName": lastName,
        "contact": {
          "email": email,
          "phone": phone,
          "address": {
            "StreetAndNumber": streetAndNumberController.text,
            "PostalCode": postalCodeController.text,
            "City": cityController.text,
            "Country": countryController.text,
          },
        },
        "Password": passwordController.text, // Hash this in production!
        "AccessLevel": 0, // Default access level
      };

      // Insert the user into the 'User' collection
      var result = await MongoDB.userCollection.insertOne(userData);

      if (result.isSuccess) {
        print("User registered successfully with ID: ${result.id}");

        setState(() {
          loggedIn = true;
        });
        user = userData;
        // Navigate to the main page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        showErrorDialog("Nie udało się zarejestrować użytkownika.");
      }
    } catch (e) {
      showErrorDialog(
          "Rejestracja się nie powiodła. Spróbuj ponownie później.");
      print("Error: $e");
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
              title: const Text("Rejestracja"),
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: const Color(midnightGreen),
              foregroundColor: const Color(electricBlue),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Imię i nazwisko",
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
                          Icons.person_2_outlined,
                          color: Color(richBlack),
                        ),
                        labelStyle: TextStyle(color: Color(richBlack)),
                      ),
                      cursorColor: const Color(midnightGreen),
                    ),
                    const SizedBox(height: 16.0),
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
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: "Numer telefonu",
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
                          Icons.phone_outlined,
                          color: Color(richBlack),
                        ),
                        labelStyle: TextStyle(color: Color(richBlack)),
                      ),
                      cursorColor: const Color(midnightGreen),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Restrict to digits
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: streetAndNumberController,
                      decoration: const InputDecoration(
                        labelText: "Ulica i numer",
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
                          Icons.add_location_outlined,
                          color: Color(richBlack),
                        ),
                        labelStyle: TextStyle(color: Color(richBlack)),
                      ),
                      cursorColor: const Color(midnightGreen),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: postalCodeController,
                      decoration: const InputDecoration(
                        labelText: "Kod pocztowy",
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
                          Icons.local_post_office_outlined,
                          color: Color(richBlack),
                        ),
                        labelStyle: TextStyle(color: Color(richBlack)),
                      ),
                      cursorColor: const Color(midnightGreen),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: "Miasto",
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
                          Icons.location_city_outlined,
                          color: Color(richBlack),
                        ),
                        labelStyle: TextStyle(color: Color(richBlack)),
                      ),
                      cursorColor: const Color(midnightGreen),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: countryController,
                      decoration: const InputDecoration(
                        labelText: "Kraj",
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
                          Icons.public_outlined,
                          color: Color(richBlack),
                        ),
                        labelStyle: TextStyle(color: Color(richBlack)),
                      ),
                      cursorColor: const Color(midnightGreen),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Checkbox(
                          value: agreeToTerms,
                          activeColor: const Color(midnightGreen),
                          side:
                              const BorderSide(color: Colors.black, width: 2.0),
                          onChanged: (value) {
                            setState(() {
                              agreeToTerms = value!;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "Wyrażam zgodę na regulamin i politykę prywatności.",
                            style: TextStyle(color: Color(richBlack)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(midnightGreen),
                        foregroundColor: const Color(electricBlue),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text("Zarejestruj się"),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(richBlack),
                      ),
                      child: const Text("Masz już konto? Zaloguj się"),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const MainPage();
  }
}
