import 'package:dbcrypt/dbcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:aplikacjadrukomat/globals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const MONGO_URL =
    "mongodb+srv://admin:admin@users.tmgbk.mongodb.net/Drukomat?retryWrites=true&w=majority&appName=Users";
const COLLECTION_USER = "User";
const COLLECTION_ORDERS = "Orders";
const COLLECTION_DRUKOMAT = "Drukomat";
const COLLECTION_DRAFTS = "Drafts";
const COLLECTION_MALFUNCTION = "Malfunction";
const COLLECTION_RAPORTS = "Raports";
const COLLECTION_PRINTING_MODULE = 'PrintingModule';
const COLLECTION_PRINTER = 'Warehouse';

class MongoDB {
  static late Db db;
  static late DbCollection userCollection;
  static late DbCollection drukomatCollection;
  static late DbCollection ordersCollection;
  static late DbCollection draftsCollection;
  static late DbCollection malfunctionCollection;
  static late DbCollection raportsCollection;
  static late DbCollection printingModuleCollection;
  static late DbCollection printerCollection;
  static var isConnected = false;

  static Future<void> connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    userCollection = db.collection(COLLECTION_USER);
    drukomatCollection = db.collection(COLLECTION_DRUKOMAT);
    ordersCollection = db.collection(COLLECTION_ORDERS);
    draftsCollection = db.collection(COLLECTION_DRAFTS);
    malfunctionCollection = db.collection(COLLECTION_MALFUNCTION);
    raportsCollection = db.collection(COLLECTION_RAPORTS);
    printingModuleCollection = db.collection(COLLECTION_PRINTING_MODULE);
    printerCollection = db.collection(COLLECTION_PRINTER);
    isConnected = true;
    print("Database connected and collections initialized.");
  }

  static Future<void> findUser(String email, String password) async {
    final userP = await MongoDB.userCollection.findOne({
      "contact.email": email,
      "Password": password,
    });
    print("Login : |$email| |$password|");

    user = userP;
    print("$user");
  }

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    try {
      final userP = await MongoDB.userCollection.findOne({
        "contact.email": email,
        "Password": hashPassword(password),
      });

      print("Login : |$email| |$password|");

      if (userP != null) {
        user = userP;
        print("User logged in: $user");
        if (userP['AccessLevel'] >= 2) {
          service = true;
        } else {
          service = false;
        }
        ;
        print("status: ${service}\n");
        return userP;
      } else {
        user = null;
        print("User not found.");
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      user = null;
      return null;
    }
  }

  static Future<List<Drukomat>> fetchDrukomats() async {
    final List<Map<String, dynamic>> data =
        await MongoDB.drukomatCollection.find(where.ne('Status', 0)).toList();
    if (data.isEmpty) {
      print("No Drukomats found in the database.");
      return [];
    }

    List<Drukomat> drukomats = data.map<Drukomat>((item) {
      print('Item: $item');
      return Drukomat.fromMap(item);
    }).toList();
    return drukomats;
  }

  static Future<List<Map<String, dynamic>>> fetchOrders(String userID) async {
    try {
      var objectId = ObjectId.fromHexString(userID);

      final List<Map<String, dynamic>> data =
          await MongoDB.ordersCollection.find({'UserID': objectId}).toList();

      if (data.isEmpty) {
        print("No orders found for user: $userID.");
        return [];
      }

      return data;
    } catch (e) {
      print("Error fetching orders for user $userID: $e");
      return [];
    }
  }

  static Future<void> saveOrder(Map<String, dynamic> orderData) async {
    try {
      await MongoDB.ordersCollection.insert(orderData);
      print("Order saved to database: $orderData");
    } catch (e) {
      print("Error saving order to database: $e");
    }
  }

  static Future<void> updateReportStatus(
      ObjectId reportId, ObjectId userId) async {
    try {
      await MongoDB.malfunctionCollection.updateOne(
        where.id(reportId),
        modify.set('Status', userId),
      );
    } catch (e) {
      print('Error updating report status: $e');
      rethrow;
    }
  }

  static Future<void> resolveReport(ObjectId reportId) async {
    try {
      await MongoDB.malfunctionCollection.updateOne(
        where.id(reportId),
        modify.set('Status', false),
      );
    } catch (e) {
      print('Error resolving report: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> findRaports() async {
    try {
      final raports = await raportsCollection.find().toList();
      return raports;
    } catch (e) {
      print("Error fetching raports: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>?> findDrukomatById(ObjectId id) async {
    try {
      return await drukomatCollection.findOne({"_id": id});
    } catch (e) {
      print("Error fetching drukomat: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> findPrintingModuleById(
      ObjectId id) async {
    try {
      return await printingModuleCollection.findOne({"_id": id});
    } catch (e) {
      print("Error fetching printing module: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> findPrinterById(ObjectId id) async {
    try {
      return await printerCollection.findOne({"_id": id});
    } catch (e) {
      print("Error fetching printer: $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchDrafts() async {
    try {
      final List<Map<String, dynamic>> data =
          await draftsCollection.find(<String, dynamic>{}).toList();

      if (data.isEmpty) {
        print("No drafts found in the database.");
        return [];
      }

      return data.map((doc) {
        return {
          'name': doc['name'],
          'pdfBase64': doc['encodedFile'],
        };
      }).toList();
    } catch (e) {
      print("Error fetching drafts: $e");
      return [];
    }
  }

  static Future<List<ErrorReport>> findErrorReports() async {
    try {
      final List<Map<String, dynamic>> reports =
          await MongoDB.malfunctionCollection.find().toList();
      return reports.map((report) => ErrorReport.fromMap(report)).toList();
    } catch (e) {
      print("Error fetching error reports: $e");
      return [];
    }
  }
}

class Drukomat {
  final ObjectId drukomatID;
  final String name;
  final LatLng location;
  final String? address;
  final String? city;
  final int? status;
  final String? description;

  Drukomat({
    required this.drukomatID,
    required this.name,
    required this.location,
    this.address,
    this.city,
    this.status,
    this.description,
  });

  factory Drukomat.fromMap(Map<String, dynamic> map) {
    double latitude =
        double.tryParse(map['Latitude']?.toString() ?? '0.0') ?? 0.0;
    double longitude =
        double.tryParse(map['Longitude']?.toString() ?? '0.0') ?? 0.0;
    print("________________");
    print("nazwa ${map['Name']}");
    print("addres ${map['Address']}");
    print("miasto ${map['City']}");
    print("opis ${map['Description']}");
    print("________________");
    return Drukomat(
      drukomatID: map['_id'],
      name: map['Name'] ?? 'Unknown',
      location: LatLng(latitude, longitude),
      address: map['Address'],
      city: map['City'],
      status: map['Status'],
      description: map['Description'],
    );
  }
}

class ErrorReport {
  final ObjectId id;
  final String drukomatName;
  final int errorCode;
  final DateTime date;
  final dynamic status;
  final ObjectId? userID;
  final String errorDescription;
  final String? address;
  ErrorReport({
    required this.id,
    required this.drukomatName,
    required this.errorCode,
    required this.date,
    required this.status,
    required this.errorDescription,
    required this.address,
    this.userID,
  });

  factory ErrorReport.fromMap(Map<String, dynamic> map) {
    return ErrorReport(
      id: map['_id'],
      drukomatName: map['DrukomatName'],
      errorCode: map['ErrorCode'],
      date: map['Date'] is DateTime
          ? map['Date']
          : DateTime.fromMillisecondsSinceEpoch(
              (map['Date']['t'] as int) * 1000),
      status: map['Status'],
      userID: map['Status'] is ObjectId ? map['Status'] : null,
      errorDescription: map['ErrorDescription'],
      address: map['Address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'DrukomatName': drukomatName,
      'ErrorCode': errorCode,
      'Date': date.millisecondsSinceEpoch ~/ 1000,
      'Status': status,
      'UserID': userID,
    };
  }
}

class Printer {
  final String mac;
  final String model;
  final String type;
  final bool isColor;
  final String size;
  final int status;
  final String format;
  final String paperType;
  final int paperAmount;
  final double cyanInk;
  final double magentaInk;
  final double yellowInk;
  final double carbonInk;

  Printer({
    required this.mac,
    required this.model,
    required this.type,
    required this.isColor,
    required this.size,
    required this.status,
    required this.format,
    required this.paperType,
    required this.paperAmount,
    required this.cyanInk,
    required this.magentaInk,
    required this.yellowInk,
    required this.carbonInk,
  });

  factory Printer.fromMap(Map<String, dynamic> map) {
    final printers = map['Printers'];
    final paper = map['Paper'];

    return Printer(
      mac: printers['MAC'],
      model: printers['Model'],
      type: printers['Type'],
      isColor: printers['Color'],
      size: printers['Size'],
      status: printers['Status'],
      format: paper['Format'],
      paperType: paper['Type'],
      paperAmount: paper['Amount'],
      cyanInk: map['CyanInk'].toDouble(),
      magentaInk: map['MagentaInk'].toDouble(),
      yellowInk: map['YellowInk'].toDouble(),
      carbonInk: map['CarbonInk'].toDouble(),
    );
  }
}

String hashPassword(String password) {
  final bcrypt = DBCrypt();
  return bcrypt.hashpw(password, r'$2b$06$C6UzMDM.H6dfI/f/IKxGhu');
}
