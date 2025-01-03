import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'globals.dart';

class AddToOrderPage extends StatefulWidget {
  const AddToOrderPage({Key? key}) : super(key: key);

  @override
  State<AddToOrderPage> createState() => _AddToOrderPageState();
}

class _AddToOrderPageState extends State<AddToOrderPage> {
  String? attachedFileName;
  bool isColorPrint = true; // Default is color print
  String selectedFormat = 'A4'; // Default format is A4
  int numberOfCopies = 1; // Default number of copies

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          attachedFileName = file.name;
        });
      } else {
        print("No file picked.");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  // Function to handle changes in number of copies
  void _changeCopies(bool increase) {
    setState(() {
      if (increase) {
        numberOfCopies++;
      } else if (numberOfCopies > 1) {
        numberOfCopies--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(verdigris), // Background color
      appBar: AppBar(
        title: const Text("Dodaj do zamówienia"),
        backgroundColor: const Color(midnightGreen), // Use midnightGreen
        foregroundColor: const Color(electricBlue), // Use electricBlue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buttons at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(midnightGreen), // Button background color
                    foregroundColor: const Color(beige), // Button text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25), // More rounded corners
                    ),
                    elevation: 8, // Elevated shadow for better depth
                  ),
                  child: const Text(
                    "Dodaj własny druk",
                    style: TextStyle(fontSize: 14), // Smaller font size
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Does nothing for now
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(midnightGreen), // Button background color
                    foregroundColor: const Color(beige), // Button text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25), // More rounded corners
                    ),
                    elevation: 8, // Elevated shadow for better depth
                  ),
                  child: const Text(
                    "Dodaj druk z szablonu",
                    style: TextStyle(fontSize: 14), // Smaller font size
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Placeholder for attached file display
            Card(
              elevation: 5,
              color: const Color(beige),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: attachedFileName != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Załączony plik:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(midnightGreen),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            attachedFileName!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(richBlack),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          "Nie dodano żadnego pliku.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(richBlack),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Print settings card
            Card(
              elevation: 5,
              color: const Color(beige),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Color or Black & White option
                    const Text(
                      "Wydruk w kolorze:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(midnightGreen),
                      ),
                    ),

                    Switch(
                      value: isColorPrint,
                      onChanged: (bool value) {
                        setState(() {
                          isColorPrint = value;
                        });
                      },
                      activeColor: const Color(midnightGreen),
                      activeTrackColor: const Color(verdigris), // Active color
                      inactiveThumbColor:
                          const Color(richBlack), // Inactive thumb color
                      inactiveTrackColor:
                          const Color(beige), // Inactive track color
                    ),

                    const SizedBox(height: 10),

                    // Format selection (A4, A3, Photo Paper)
                    const Text(
                      "Format:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(midnightGreen),
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedFormat,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFormat = newValue!;
                        });
                      },
                      items: <String>['A4', 'A3', 'Photo Paper']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(richBlack),
                      ),
                      iconEnabledColor:
                          const Color(midnightGreen), // Green icon color
                      iconSize: 30,
                      underline: Container(
                        height: 2,
                        color: const Color(midnightGreen), // Green underline
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Number of copies counter
                    const Text(
                      "Liczba kopii:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(midnightGreen),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _changeCopies(false),
                        ),
                        Text(
                          '$numberOfCopies',
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _changeCopies(true),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Button to go back to the OrderingPage
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'file': attachedFileName,
                    'isColorPrint': isColorPrint,
                    'format': selectedFormat,
                    'copies': numberOfCopies,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(midnightGreen),
                  foregroundColor: const Color(beige),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  "Wróć do koszyka",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
