import 'package:flutter/material.dart';
//import 'dart:math';
import 'mongodb.dart';

class ServiceWidget extends StatefulWidget {
  const ServiceWidget({
    super.key,
    this.test = 10.0,
    this.ok,
  });

  final double test;
  final bool? ok;

  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
  String? dropdownValue;
  List<ErrorReport> errorReports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchErrorReports();
  }

  Future<void> _fetchErrorReports() async {
    setState(() {
      isLoading = true;
    });

    try {
      final reports = await MongoDB.findErrorReports();
      setState(() {
        errorReports = reports;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching error reports: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1067DA),
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Service',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Dropdown
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            hint: const Text('Select Malfunction'),
                            isExpanded: true,
                            underline: Container(),
                            items: errorReports.map((report) {
                              return DropdownMenuItem<String>(
                                value: report.errorCode.toString(),
                                child: Text(
                                  'Error ${report.errorCode} - ${report.drukomatName}',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Display selected error details
                        if (dropdownValue != null)
                          _buildErrorDetails(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildErrorDetails() {
    final selectedReport = errorReports.firstWhere(
      (report) => report.errorCode.toString() == dropdownValue,
    );

    return Column(
      children: [
        _buildInfoRow('Drukomat Name:', selectedReport.drukomatName),
        _buildInfoRow('Status:', selectedReport.status ? 'Resolved' : 'Unresolved'),
        _buildInfoRow('Error Code:', selectedReport.errorCode.toString()),
        _buildInfoRow('Date:', selectedReport.date.toLocal().toString()),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

