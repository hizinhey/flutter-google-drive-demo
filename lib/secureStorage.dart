import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';

class secureStorage{
  final storage = FlutterSecureStorage();

// Save Credentials
Future saveCredentails(AccessToken token, String refreshToken) async {
  await storage.write(key: "type", value: token.type);
  await storage.write(key: "data", value: token.data);
  await storage.write(key: "expriy", value: token.expiry.toIso8601String());
  await storage.write(key: "refresh", value: refreshToken);
}


// Get Saved Credentails
Future<Map<String, dynamic>> getCredentails() async {
  var result = await storage.readAll();
  if(result.length == 0) return null;
  return result;
}


// Clear Saved Credentails
Future clear(){
  return storage.deleteAll();
}

}