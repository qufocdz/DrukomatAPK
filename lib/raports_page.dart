import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'globals.dart';
import 'mongodb.dart';

class RaportsPage extends StatefulWidget {
  const RaportsPage({Key? key}) : super(key: key);

  @override
  _RaportsPageState createState() => _RaportsPageState();
}

class _RaportsPageState extends State<RaportsPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> raports = [];
  Map<mongo.ObjectId, Map<String, dynamic>> drukomatDetails = {};
  Map<mongo.ObjectId, Map<String, dynamic>> moduleDetails = {};
  Map<mongo.ObjectId, List<Printer>> printerDetails = {};
  Map<mongo.ObjectId, bool> expandedStates = {}; // Add this line

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      // Fetch all raports
      final fetchedRaports = await MongoDB.findRaports();
      raports = fetchedRaports;

      for (var raport in raports) {
        final raportId = raport['_id'] as mongo.ObjectId;
        final drukomatId = raport['drukomatId'] as mongo.ObjectId;

        // Fetch associated drukomat
        final drukomat = await MongoDB.findDrukomatById(drukomatId);
        if (drukomat != null) {
          drukomatDetails[raportId] = drukomat;

          // Fetch associated module
          final moduleId = drukomat['PrintingModule'] as mongo.ObjectId;
          final module = await MongoDB.findPrintingModuleById(moduleId);
          if (module != null) {
            moduleDetails[raportId] = module;

            // Fetch associated printers
            final printerIds = (module['Printers'] as List)
                .map((printerId) => printerId as mongo.ObjectId)
                .toList();

            final printers = await Future.wait(
                printerIds.map((id) => MongoDB.findPrinterById(id)));

            printerDetails[raportId] = printers
                .where((p) => p != null)
                .map((p) => Printer.fromMap(p!))
                .toList();
          }
        }
        expandedStates[raportId] = false; // Initialize expanded state
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(verdigris),
      appBar: AppBar(
        title: const Text('Raporty'),
        centerTitle: true,
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: raports.length,
              itemBuilder: (context, index) {
                final raport = raports[index];
                final raportId = raport['_id'] as mongo.ObjectId;
                final drukomat = drukomatDetails[raportId];
                final module = moduleDetails[raportId];
                final printers = printerDetails[raportId] ?? [];
                final isExpanded = expandedStates[raportId] ?? false;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .stretch, // Make children stretch
                          children: [
                            // Title section
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(midnightGreen),
                                      width: 3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  raport['title'] ?? 'Untitled Report',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(midnightGreen),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Stats card
                            Card(
                              margin: const EdgeInsets.only(top: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                    color: Color(richBlack), width: 2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Sprzedane kopie: ${raport['copiesSold']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        'Liczba błędów: ${raport['errorsNumber']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            // Module section
                            if (drukomat != null && module != null) ...[
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    expandedStates[raportId] = !isExpanded;
                                  });
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(top: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                        color: Color(richBlack), width: 2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Moduł: ${module['Name']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              isExpanded
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              color: Color(midnightGreen),
                                            ),
                                          ],
                                        ),
                                        if (isExpanded) ...[
                                          const SizedBox(height: 8),
                                          ...printers.map((printer) =>
                                              _buildPrinterCard(printer)),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPrinterCard(Printer printer) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(richBlack), width: 2), // Add border
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(printer.model,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Status: ${printer.status == 1 ? 'Aktywna' : 'Nieaktywna'}'),
            Text('Format: ${printer.format}'),
            Text('Papier: ${printer.paperAmount} szt.'),
            if (printer.isColor) ...[
              const SizedBox(height: 8),
              _buildInkLevel('Cyan', printer.cyanInk),
              _buildInkLevel('Magenta', printer.magentaInk),
              _buildInkLevel('Yellow', printer.yellowInk),
              _buildInkLevel('Black', printer.carbonInk),
            ] else
              _buildInkLevel('Toner', printer.carbonInk),
          ],
        ),
      ),
    );
  }

  Widget _buildInkLevel(String label, double level) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label)),
        Expanded(
          child: LinearProgressIndicator(
            value: level / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              label == 'Cyan'
                  ? Colors.cyan
                  : label == 'Magenta'
                      ? Colors.pink
                      : label == 'Yellow'
                          ? Colors.yellow
                          : Colors.black,
            ),
          ),
        ),
        SizedBox(width: 50, child: Text(' ${level.toStringAsFixed(1)}%')),
      ],
    );
  }
}
