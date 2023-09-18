import 'dart:convert';
import 'dart:io';

import 'package:sih_app/modal/login_response.dart';
import 'package:sih_app/modal/rest_response.dart';
import 'package:http/http.dart' as http;

var client = http.Client();

class API {
  var client = http.Client();
  static const baseUrl = "https://testsihlogin-chaitanyakanhar2004.b4a.run/";
  static const userSignUP = "${baseUrl}register/";
  static const userSignIn = "${baseUrl}login/"; // live
  //static const apiKey = "Replace your API key";
  Future<RestResponse> signup({email, pass, username}) async {
    var data =
        jsonEncode({"username": username, "email": email, "password": pass});
    final response = await client.post(
      Uri.parse(userSignUP),
      body: data,
    );

    print(response.body);
    return RestResponse.fromJson(response.body);
  }

  Future<LoginResponse> signin({token}) async {
    final response = await http.post(
      Uri.parse(userSignIn),
      body: jsonEncode({"token": token}),
    );
    //final responseJson = jsonDecode(response.body);
    print(response.body);
    return LoginResponse.fromJson(response.body);
  }
}
