import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'globals.dart';
import 'mongodb.dart';

class ServicePage extends StatefulWidget {
  final mongo.ObjectId currentUserId;

  const ServicePage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  bool isLoading = true;
  List<ErrorReport> errorReports = [];

  @override
  void initState() {
    super.initState();
    _fetchErrorReports();
  }

  Future<void> _fetchErrorReports() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      final reports = await MongoDB.findErrorReports();
      if (!mounted) return;
      setState(() {
        errorReports = reports;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching error reports: $e");
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'stycznia',
      'lutego',
      'marca',
      'kwietnia',
      'maja',
      'czerwca',
      'lipca',
      'sierpnia',
      'września',
      'października',
      'listopada',
      'grudnia'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}, '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildSectionLabel(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(beige),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(midnightGreen).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(midnightGreen),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(verdigris),
      appBar: AppBar(
        title: const Text("Zgłoszenia serwisowe"),
        centerTitle: true,
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: RawScrollbar(
        thumbColor: const Color(midnightGreen),
        thickness: 8,
        radius: const Radius.circular(4),
        crossAxisMargin: 0,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorReports.isEmpty
                ? const Center(
                    child:
                        Text("Brak zgłoszeń", style: TextStyle(fontSize: 18)),
                  )
                : SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: const Color(midnightGreen),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      _buildSectionLabel(
                                          "Nieodebrane zgłoszenia"),
                                      const SizedBox(height: 12),
                                      ...errorReports
                                              .where((report) =>
                                                  !(report.status
                                                      is mongo.ObjectId) &&
                                                  report.status != false)
                                              .isEmpty
                                          ? [
                                              Card(
                                                elevation: 4,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                color: const Color(beige),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Text(
                                                    'Brak nieodebranych zgłoszeń',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(richBlack),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]
                                          : errorReports
                                              .where((report) =>
                                                  !(report.status
                                                      is mongo.ObjectId) &&
                                                  report.status != false)
                                              .map((report) => Card(
                                                    elevation: 4,
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    color: const Color(beige),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Błąd ${report.errorCode} - ${report.drukomatName}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  midnightGreen),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      'Adres: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        midnightGreen),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: report
                                                                      .address,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        richBlack),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      'Opis błędu: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        midnightGreen),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: report
                                                                      .errorDescription,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        richBlack),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      'Status: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        midnightGreen),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: report.status
                                                                          is mongo
                                                                          .ObjectId
                                                                      ? 'Rozwiązane'
                                                                      : 'Nierozwiązane',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        richBlack),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      'Data: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        midnightGreen),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: _formatDate(
                                                                      report
                                                                          .date),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        richBlack),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Center(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color(
                                                                        midnightGreen),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      24,
                                                                  vertical: 12,
                                                                ),
                                                              ),
                                                              onPressed: report
                                                                          .status
                                                                      is mongo
                                                                      .ObjectId
                                                                  ? null
                                                                  : () async {
                                                                      final scaffoldMessenger =
                                                                          ScaffoldMessenger.of(
                                                                              context);
                                                                      try {
                                                                        await MongoDB
                                                                            .updateReportStatus(
                                                                          report
                                                                              .id,
                                                                          widget
                                                                              .currentUserId,
                                                                        );

                                                                        scaffoldMessenger
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Center(child: Text('Z sukcesem przyjąłeś zgłoszenie!')),
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                          ),
                                                                        );

                                                                        if (!mounted)
                                                                          return;
                                                                        await _fetchErrorReports();
                                                                      } catch (e) {
                                                                        if (!mounted)
                                                                          return;
                                                                        scaffoldMessenger
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Center(child: Text('Błąd w zmianie statusu: $e')),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                              child: const Text(
                                                                'Przyjmij zgłoszenie',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: const Color(midnightGreen),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      _buildSectionLabel("Twoje zgłoszenia"),
                                      const SizedBox(height: 12),
                                      ...errorReports
                                              .where((report) =>
                                                  report.status
                                                      is mongo.ObjectId &&
                                                  report.status.toHexString() ==
                                                      widget.currentUserId
                                                          .toHexString() &&
                                                  report.status != false)
                                              .isEmpty
                                          ? [
                                              Card(
                                                elevation: 4,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                color: const Color(beige),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Text(
                                                    'Brak przyjętych zgłoszeń',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(richBlack),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]
                                          : errorReports
                                              .where((report) =>
                                                  report.status
                                                      is mongo.ObjectId &&
                                                  report.status.toHexString() ==
                                                      widget.currentUserId
                                                          .toHexString() &&
                                                  report.status != false)
                                              .map((report) => Card(
                                                    elevation: 4,
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    color: const Color(beige),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Błąd ${report.errorCode} - ${report.drukomatName}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  midnightGreen),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      'Adres: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        midnightGreen),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: report
                                                                      .address,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        richBlack),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      'Opis błędu: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        midnightGreen),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: report
                                                                      .errorDescription,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        richBlack),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      'Status: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        midnightGreen),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: report.status
                                                                          is mongo
                                                                          .ObjectId
                                                                      ? 'Nierozwiązane'
                                                                      : 'Rozwiązane',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        richBlack),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      'Data: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        midnightGreen),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: _formatDate(
                                                                      report
                                                                          .date),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        richBlack),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Center(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color(
                                                                        midnightGreen),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      24,
                                                                  vertical: 12,
                                                                ),
                                                              ),
                                                              onPressed: report
                                                                              .status
                                                                          is mongo
                                                                          .ObjectId &&
                                                                      report.status ==
                                                                          widget
                                                                              .currentUserId
                                                                  ? () async {
                                                                      final scaffoldMessenger =
                                                                          ScaffoldMessenger.of(
                                                                              context);
                                                                      try {
                                                                        await MongoDB.resolveReport(
                                                                            report.id);
                                                                        scaffoldMessenger
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Center(child: Text('Zgłoszenie zostało zamknięte!')),
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                          ),
                                                                        );
                                                                        if (!mounted)
                                                                          return;
                                                                        await _fetchErrorReports();
                                                                      } catch (e) {
                                                                        scaffoldMessenger
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Center(child: Text('Błąd w zamykaniu zgłoszenia: $e')),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                          ),
                                                                        );
                                                                      }
                                                                    }
                                                                  : null,
                                                              child: const Text(
                                                                'Zamknij zgłoszenie',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
