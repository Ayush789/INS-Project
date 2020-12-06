import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

class Token_VM extends BaseViewModel {
  String token;
  List<String> resources;
  String authurl = "http://localhost:5000/";
  String resurl = "http://localhost:8080/";
  Image res;

  Future<String> login(String username, String password) async {
    setBusy(true);

    token = null;
    resources = [];
    setBusy(true);

    print("Logging In");

    var response = await post(
      authurl,
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode != 200) {
      setBusy(false);
      return "Internet Connection Error!!";
    }

    print(response.body);

    var tokendata = jsonDecode(response.body);

    if (tokendata["accepted"] == true) {
      token = tokendata["token"];
    } else {
      setBusy(false);
      return "Incorrect Username or Password";
    }

    var reslistresp = await post(
      resurl,
      body: jsonEncode({"token": token}),
    );

    if (reslistresp.statusCode != 200) {
      setBusy(false);
      return "Internet Connection Error!!";
    }

    print(reslistresp.body);

    var resdata = jsonDecode(reslistresp.body);
    if (resdata["accepted"] == true) {
      for (var item in resdata["reslist"]) {
        print(item);
        resources.add(item as String);
      }
    } else {
      setBusy(false);
      return "Incorrect Username or Password";
    }

    print(resources);
    setBusy(false);
    return "";
  }

  Future<String> fetchResource(String resource) async {
    setBusy(true);

    var response = await post(
      resurl,
      body: jsonEncode({"token": token, "res": resource}),
    );

    if (response.statusCode != 200) {
      setBusy(false);
      return "Internet Connection Error!!";
    }

    // print(response.body);

    var data = jsonDecode(response.body);
    if (data["accepted"] == true) {
      res = Image.memory(base64Decode(data["res"]));
    } else {
      setBusy(false);
      return "Incorrect Username or Password";
    }
    setBusy(false);
    return "";
  }
}
