import 'package:mongo_dart/mongo_dart.dart';
import 'package:aplikacjadrukomat/globals.dart';

const MONGO_URL =
    "mongodb+srv://admin:admin@users.tmgbk.mongodb.net/Drukomat?retryWrites=true&w=majority&appName=Users";
const COLLECTION_USER = "User";
const COLLECTION_ORDERS = "Orders";

class MongoDB {
  static late Db db;
  static late DbCollection userCollection;

  static Future<void> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    userCollection = db.collection(COLLECTION_USER);
  }
  static Future<void> login(String email,String password) async {
      
      final userP = await MongoDB.userCollection.findOne({
        "contact.email": email, 
        "Password": password, 
      });
      print("Login : |$email| |$password|");
      
      user=userP;
      print("$user");
}

static Future<void> countDocuments() async {
    
  }
}
