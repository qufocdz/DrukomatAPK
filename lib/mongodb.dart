import 'package:mongo_dart/mongo_dart.dart';
import 'package:aplikacjadrukomat/globals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const MONGO_URL =
    "mongodb+srv://admin:admin@users.tmgbk.mongodb.net/Drukomat?retryWrites=true&w=majority&appName=Users";
const COLLECTION_USER = "User";
const COLLECTION_ORDERS = "Orders";
const COLLECTION_DRUKOMAT = "Drukomat";

class MongoDB {
  static late Db db;
  static late DbCollection userCollection;
  static late DbCollection drukomatCollection;
  static Future<void> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    userCollection = db.collection(COLLECTION_USER);
    drukomatCollection = db.collection(COLLECTION_DRUKOMAT);
  }
  static Future<void> findUser(String email,String password) async {
      
      final userP = await MongoDB.userCollection.findOne({
        "contact.email": email, 
        "Password": password, 
      });
      print("Login : |$email| |$password|");
      
      user=userP;
      print("$user");
}
static Future<List<Drukomat>> fetchDrukomats() async{
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


}

class Drukomat {
  final String name;
  final LatLng location;
  final String? address;
  final String? city;
  final int? status;
  final String? description;

  Drukomat({
    required this.name,
    required this.location,
    this.address,
    this.city,
    this.status,
    this.description,
  });

  factory Drukomat.fromMap(Map<String, dynamic> map) {
    double latitude = double.tryParse(map['Latitude']?.toString() ?? '0.0') ?? 0.0;
    double longitude = double.tryParse(map['Longitude']?.toString() ?? '0.0') ?? 0.0;
    print("________________");
    print("nazwa ${map['Name']}");
    print("addres ${map['Address']}");
    print("miasto ${map['City']}");
    print("opis ${map['Description']}");
    print("________________");
    return Drukomat(
      name: map['Name'] ?? 'Unknown',
      location: LatLng(latitude, longitude),
      address: map['Address'],
      city: map['City'],
      status: map['Status'],
      description: map['Description'],
    );
  }
}
