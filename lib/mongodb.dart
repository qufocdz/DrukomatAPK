import 'package:aplikacjadrukomat/globals.dart';
import 'package:mongo_dart/mongo_dart.dart';

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
}
