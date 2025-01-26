import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'globals.dart';
import 'templates_page.dart';

class AddToOrderPage extends StatefulWidget {
  const AddToOrderPage({super.key});

  @override
  State<AddToOrderPage> createState() => _AddToOrderPageState();
}

class _AddToOrderPageState extends State<AddToOrderPage> {
  String? attachedFileName;
  bool isColorPrint = true; // Default is color print
  String selectedFormat = 'A4'; // Default format is A4
  int numberOfCopies = 1; // Default number of copies
  PdfController? pdfController; // Controller for the PDF viewer
  PdfDocument? pdfDocument; // Variable to hold the resolved PDF document
  bool isPdfAttached = false; // Flag to indicate if a PDF is attached
  String? base64EncodedFile; // Base64 encoded file content
  bool isFileUploaded = false; // Flag to control button visibility

  // Method to calculate the price based on selected options
  double _calculatePrice() {
    double basePricePerCopy = 0;

    // Base price based on format
    switch (selectedFormat) {
      case 'A3':
        basePricePerCopy = 3;
        break;
      case 'Photo Paper':
        basePricePerCopy = 5;
        break;
      case 'A4':
      default:
        basePricePerCopy = 1;
    }

    // Double the price for color prints
    if (isColorPrint) {
      basePricePerCopy *= 1.5;
    }

    // Add the number of pages factor
    int numberOfPages = 0; // Default if no PDF is attached
    if (isPdfAttached && pdfDocument != null) {
      numberOfPages = pdfDocument!.pagesCount;
    }

    // Calculate the final price
    return basePricePerCopy * numberOfCopies * numberOfPages;
  }

  // Method to update the PDF controller
  Future<void> _updatePdfController(
      String newFilePath, PdfDocument document) async {
    // Dispose of the old controller if it exists
    pdfController?.dispose();

    // Use the provided document instead of opening a new one
    pdfDocument = document;
    pdfController = PdfController(
      document: Future.value(document),
    );

    // Update the state to reflect the changes
    setState(() {
      isPdfAttached = true;
      attachedFileName = newFilePath.split('/').last;
      isFileUploaded = true;
    });
  }

  // Method to handle file picking
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        PdfDocument document = await PdfDocument.openFile(filePath);
        _updatePdfController(filePath, document);

        // Convert the file to Base64
        File pickedFile = File(filePath);
        base64EncodedFile = base64Encode(pickedFile.readAsBytesSync());

        print(
            "File converted to Base64: ${base64EncodedFile?.substring(0, 50)}...");
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
    // Dispose the PdfController to free up resources
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(verdigris), // Background color
      appBar: AppBar(
        title: const Center(child: Text("Dodaj do zamówienia")),
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
              if (!isFileUploaded) ...[
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
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TemplatesPage(),
                            ),
                          );

                          if (result != null &&
                              result['file'] != null &&
                              result['pdfDocument'] != null) {
                            PdfDocument document = result['pdfDocument'];
                            String fileName = result['name'];
                            base64EncodedFile = result['encodedFile'];
                            await _updatePdfController(fileName, document);
                          }
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
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

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
                        Center(
                          child: Text(
                            attachedFileName!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(richBlack),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // In the Widget tree for displaying PDF

                        if (isPdfAttached && pdfController != null)
                          SizedBox(
                            height: 400,
                            child: GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                if (details.primaryDelta! < 0) {
                                  pdfController!.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else if (details.primaryDelta! > 0) {
                                  pdfController!.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: PdfView(
                                  controller: pdfController!,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                          )
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
                      'base64File': base64EncodedFile, // Send Base64 data
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
