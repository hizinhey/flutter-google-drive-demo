import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:io';

import 'package:flutter_google_drive/secureStorage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

const _clientId =
    "707809137640-t94snev90qi6k16c66sv0mmm6389jo50.apps.googleusercontent.com";
const _clientSecret = "XAOk2FR2-6BZEX6VT6KKii_f";
const _scopes = [ga.DriveApi.DriveFileScope];

class GoogleDrive {
  final storage = secureStorage();

  // Get Authenticated http Client
  Future<http.Client> getHttpClent() async {
    //Get Credentails
    var credentails = await storage.getCredentails();
    if (credentails == null) {
      var authClent = await clientViaUserConsent(
          ClientId(_clientId, _clientSecret), _scopes, (url) {
        // Open Url in Brower
        launch(url);
      });
      return authClent;
    } else {
        // Already Authenticated
        return authenticatedClient(
          http.Client(), 
          AccessCredentials(AccessToken(
            credentails["type"], 
            credentails["data"],
            DateTime.parse(credentails["expriy"])), 
            credentails["refreshToken"],

            _scopes)); 
      }
  }

  // Upload file
  Future upload(File file) async {
    var client = await getHttpClent();
    var drive = ga.DriveApi(client);

    var response = await drive.files.create(
        ga.File()..name = p.basename(file.absolute.path),
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()));

    print(response.toJson());
  }
}
