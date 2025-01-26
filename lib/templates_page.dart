import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'globals.dart';
import 'mongodb.dart'; // Import your MongoDB class

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({Key? key}) : super(key: key);

  @override
  _TemplatesPageState createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  List<Map<String, dynamic>> drafts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDrafts();
  }

  // Fetch drafts from MongoDB
  Future<void> _fetchDrafts() async {
    try {
      final fetchedDrafts = await MongoDB.fetchDrafts();
      setState(() {
        drafts = fetchedDrafts;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching drafts: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Decode base64 string and save the PDF to a file
  Future<File> _decodeAndSavePdf(String base64String, String fileName) async {
    try {
      final bytes = base64Decode(base64String);
      if (bytes.isEmpty) {
        throw Exception("Decoded bytes are empty. Invalid base64 string.");
      }

      final dir =
          await getApplicationDocumentsDirectory(); // App's internal directory
      final file =
          File('${dir.path}/$fileName'); // Create a file in the directory

      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print("Error decoding and saving PDF: $e");
      rethrow;
    }
  }

  // Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(verdigris),
      appBar: AppBar(
        title: const Center(child: Text("Szablony druku")),
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : drafts.isEmpty
              ? const Center(
                  child: Text(
                    "Brak szablonów do wyświetlenia.",
                    style: TextStyle(fontSize: 16, color: Color(richBlack)),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: drafts.length,
                    itemBuilder: (context, index) {
                      final draft = drafts[index];
                      final pdfBase64 = draft['pdfBase64'];
                      final name = draft['name'];

                      return FutureBuilder<File>(
                        future:
                            _decodeAndSavePdf(pdfBase64, 'draft_$index.pdf'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return ListTile(
                              title: Text(name),
                              subtitle:
                                  Text("Error loading PDF: ${snapshot.error}"),
                            );
                          } else if (snapshot.hasData) {
                            final file = snapshot.data!;
                            return FutureBuilder<PdfDocument>(
                              future: PdfDocument.openFile(file.path),
                              builder: (context, pdfSnapshot) {
                                if (pdfSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (pdfSnapshot.hasError) {
                                  return ListTile(
                                    title: Text(name),
                                    subtitle: Text(
                                        "Error loading PDF: ${pdfSnapshot.error}"),
                                  );
                                } else if (pdfSnapshot.hasData) {
                                  final pdfDocument = pdfSnapshot.data!;
                                  return Card(
                                    elevation: 8,
                                    color: const Color(beige),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(midnightGreen),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            height:
                                                300, // Adjust height as needed
                                            child: PdfView(
                                              controller: PdfController(
                                                document:
                                                    Future.value(pdfDocument),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context, {
                                                'file': file,
                                                'name': name,
                                                'encodedFile': pdfBase64,
                                                'pdfDocument': pdfDocument,
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(midnightGreen),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                                "Wybierz ten szablon"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(); // Handle other cases
                                }
                              },
                            );
                          } else {
                            return Container(); // Handle other cases
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
