import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'globals.dart';
import 'templates_page.dart';

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
  PdfControllerPinch? pdfController; // Controller for the PDF viewer
  bool isPdfAttached = false; // Flag to indicate if a PDF is attached

  // Method to calculate the price based on selected options
  double _calculatePrice() {
    double basePrice = 0;

    switch (selectedFormat) {
      case 'A3':
        basePrice = 3;
        break;
      case 'Photo Paper':
        basePrice = 5;
        break;
      case 'A4':
      default:
        basePrice = 1;
    }

    if (isColorPrint) {
      basePrice *= 2; // Double the price for color prints
    }

    return basePrice * numberOfCopies;
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;

        // Dispose the previous PdfControllerPinch
        pdfController?.dispose(); // Remove 'await' here

        setState(() {
          attachedFileName = file.name;
          isPdfAttached = file.extension == 'pdf';

          // Reset the pdfController when a new file is picked
          pdfController = null; // Clear any existing PDF controller

          if (isPdfAttached) {
            // Only create a new controller if the file is a PDF
            pdfController = PdfControllerPinch(
              document: PdfDocument.openFile(file.path!),
            );
          }
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
  void dispose() {
    // Dispose the PdfControllerPinch to free up resources
    pdfController?.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buttons at the top
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _pickFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(midnightGreen),
                        foregroundColor: const Color(beige),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        "Dodaj własny druk",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TemplatesPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(midnightGreen),
                        foregroundColor: const Color(beige),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        "Dodaj druk z szablonu",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Placeholder for attached file display
              if (attachedFileName != null) ...[
                Card(
                  elevation: 5,
                  color: const Color(beige),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
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
                        const SizedBox(height: 20),
                        if (isPdfAttached && pdfController != null)
                          SizedBox(
                            height: 400,
                            child: GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                if (details.primaryDelta! < 0) {
                                  // Swipe left (next page)
                                  pdfController!.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else if (details.primaryDelta! > 0) {
                                  // Swipe right (previous page)
                                  pdfController!.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: PdfViewPinch(
                                controller: pdfController!,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

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
                        activeTrackColor: const Color(verdigris),
                        inactiveThumbColor: const Color(richBlack),
                        inactiveTrackColor: const Color(beige),
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
                        iconEnabledColor: const Color(midnightGreen),
                        iconSize: 30,
                        underline: Container(
                          height: 2,
                          color: const Color(midnightGreen),
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

              // Display the calculated price
              Card(
                elevation: 5,
                color: const Color(beige),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Cena:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(midnightGreen),
                        ),
                      ),
                      Text(
                        "${_calculatePrice().toStringAsFixed(2)} zł",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(midnightGreen),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Button to go back to the OrderingPage with the price included
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'file': attachedFileName,
                      'isColorPrint': isColorPrint,
                      'format': selectedFormat,
                      'copies': numberOfCopies,
                      'price': _calculatePrice(),
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(midnightGreen),
                    foregroundColor: const Color(beige),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    "Dodaj do koszyka",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
