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

class MongoDB {
  static late Db db;
  static late DbCollection userCollection;
  static late DbCollection drukomatCollection;
  static late DbCollection ordersCollection;
  static late DbCollection draftsCollection;
  static late DbCollection malfunctionCollection;

  // Correcting the connect method
  static Future<void> connect() async {
    db = await Db.create(MONGO_URL); // Correcting the initialization of db
    await db.open();
    userCollection = db.collection(COLLECTION_USER);
    drukomatCollection = db.collection(COLLECTION_DRUKOMAT);
    ordersCollection = db.collection(COLLECTION_ORDERS);
    draftsCollection = db.collection(COLLECTION_DRAFTS);
    malfunctionCollection = db.collection(COLLECTION_MALFUNCTION);
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
        user = userP; // Set the global variable
        print("User logged in: $user");
        if (userP['AccessLevel'] >= 2) {
          service = true;
        } else {
          service = false;
        }
        ;
        print("status: ${service}\n");
        return userP; // Return the user data if found
      } else {
        user = null; // Clear user on failed login
        print("User not found.");
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      user = null; // Clear user on error
      return null; // Return null in case of an error
    }
  }

  static Future<List<Drukomat>> fetchDrukomats() async {
    final List<Map<String, dynamic>> data =
        await MongoDB.drukomatCollection.find(<String, dynamic>{}).toList();
    if (data.isEmpty) {
      print("No Drukomats found in the database.");
      return [];
    }

    List<Drukomat> drukomats = data.map<Drukomat>((item) {
      print('Item: $item'); // Wyświetla zawartość item
      return Drukomat.fromMap(item);
    }).toList();
    return drukomats;
  }

  // Modify the fetchOrders method to accept a userID and filter orders by that userID
  static Future<List<Map<String, dynamic>>> fetchOrders(String userID) async {
    try {
      // Convert the userID to an ObjectId since MongoDB stores it as ObjectId
      var objectId = ObjectId.fromHexString(userID);

      // Filter the orders collection by the user's ObjectId
      final List<Map<String, dynamic>> data = await MongoDB.ordersCollection
          .find(
              {'UserID': objectId}) // Filter orders by userID (_id in MongoDB)
          .toList();

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

  // Add this method to save orders to the database
  static Future<void> saveOrder(Map<String, dynamic> orderData) async {
    try {
      await MongoDB.ordersCollection.insert(orderData);
      print("Order saved to database: $orderData");
    } catch (e) {
      print("Error saving order to database: $e");
    }
  }

  // Function to fetch Drafts collection and return encoded PDFs
  static Future<List<Map<String, dynamic>>> fetchDrafts() async {
    try {
      // Fetch all documents from the 'Drafts' collection
      final List<Map<String, dynamic>> data =
          await draftsCollection.find(<String, dynamic>{}).toList();

      if (data.isEmpty) {
        print("No drafts found in the database.");
        return [];
      }

      // Map and return the results with the base64-encoded PDFs
      return data.map((doc) {
        return {
          'name':
              doc['name'], // Can be changed based on the document's metadata
          'pdfBase64': doc[
              'encodedFile'], // Assuming 'encodedFile' holds the base64 string
        };
      }).toList();
    } catch (e) {
      print("Error fetching drafts: $e");
      return [];
    }
  }

  static Future<List<ErrorReport>> findErrorReports() async {
    print(user!["_id"]);
    try {
      final List<Map<String, dynamic>> reports =
          await MongoDB.malfunctionCollection.find({
        "\$or": [
          {"Status": true},
          //{"Status": "\$oid 67615ba4a34a5613f6e06304"}
        ]
      }).toList();
      print(reports);

      if (reports.isEmpty) {
        print("No error reports found with the given criteria.");
        return [];
      }

      // Convert each report into an ErrorReport object
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
  final String drukomatName;
  final int errorCode;
  final DateTime date;
  final bool status;
  final String? userID;

  ErrorReport({
    required this.drukomatName,
    required this.errorCode,
    required this.date,
    required this.status,
    this.userID,
  });

  factory ErrorReport.fromMap(Map<String, dynamic> map) {
    // Sprawdź, czy Date jest DateTime, czy obiektem Timestamp
    DateTime parsedDate;
    if (map['Date'] is DateTime) {
      parsedDate =
          map['Date']; // ISODate jest automatycznie mapowany na DateTime
    } else if (map['Date'] is Map<String, dynamic> &&
        map['Date']['t'] != null) {
      // Obsługa daty jako Timestamp (np. {"t": 1672531200})
      parsedDate =
          DateTime.fromMillisecondsSinceEpoch((map['Date']['t'] as int) * 1000);
    } else {
      throw ArgumentError("Invalid date format in map['Date']");
    }

    return ErrorReport(
      drukomatName: map['DrukomatName'],
      errorCode: map['ErrorCode'],
      date: parsedDate,
      status: map['Status'] as bool,
      userID: map['UserID']?['\$oid'],
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

String hashPassword(String password) {
  final bcrypt = DBCrypt();
  return bcrypt.hashpw(password, r'$2b$06$C6UzMDM.H6dfI/f/IKxGhu');
}
