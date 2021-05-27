import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pinjam_kredit/model/bank_model.dart';
import 'package:pinjam_kredit/model/nasabah_model.dart';

Dio dio = Dio();
String baseUrl = "https://api-kredit.rittercoding.com/";
String apiUrl = baseUrl + "Api2/";

class NasabahRepo {
  static Future addNasabah(Nasabah nasabah, File imageFile) async {
    try {
      final data = nasabah.toJson();
      data['id_bank'] = nasabah?.bank?.idBank;
      if (imageFile != null) {
        data['image'] = await MultipartFile.fromFile(imageFile.path);
      }

      final res = await dio.post(
        "$apiUrl" + "addNasabah",
        data: FormData.fromMap(data),
      );

      print("Data ${jsonDecode(res.data)}");
      if (res.statusCode == 200) {
        if (jsonDecode(res.data)['status'] == true) {
          return nasabahModelFromJson(res.data).status;
        }
      }
    } catch (e) {
      print("Exception $e");
    }
  }

  static Future updateStatus(Nasabah nasabah) async {
    try {
      final data = nasabah.toJson();
      final res = await dio.post(
        "$apiUrl" + "updateStatus",
        data: FormData.fromMap(data),
      );

      print("Data ${jsonDecode(res.data)}");
      if (res.statusCode == 200) {
        if (jsonDecode(res.data)['status'] == true) {
          return nasabahModelFromJson(res.data).status;
        }
      }
    } catch (e) {
      print("Exception $e");
    }
  }

  static Future updateNasabah(Nasabah nasabah, File imageFile) async {
    try {
      final data = nasabah.toJson();
      data['id_bank'] = nasabah?.bank?.idBank;
      if (imageFile != null) {
        data['image'] = await MultipartFile.fromFile(imageFile.path);
      }

      final res = await dio.post(
        "$apiUrl" + "updateNasabah",
        data: FormData.fromMap(data),
      );

      print("Data ${jsonDecode(res.data)}");
      if (res.statusCode == 200) {
        if (jsonDecode(res.data)['status'] == true) {
          return nasabahModelFromJson(res.data).status;
        }
      }
    } catch (e) {
      print("Exception $e");
    }
  }

  static Future getNasabah() async {
    try {
      final res = await dio.get("$apiUrl" + "getNasabah");
      if (res.statusCode == 200) {
        if (jsonDecode(res.data)['status'] == true) {
          return nasabahModelFromJson(res.data).nasabah;
        }
      }
    } catch (e) {}
  }

  static Future getBank() async {
    try {
      final res = await dio.get("$apiUrl" + "getBank");
      if (res.statusCode == 200) {
        if (jsonDecode(res.data)['status'] == true) {
          return bankModelFromJson(res.data).bank;
        }
      }
    } catch (e) {}
  }

  static Future<PhoneAuthCredential> credetialAuth(
      String phone, GlobalKey<ScaffoldState> key) async {
    PhoneAuthCredential credentialAuth;
    FirebaseAuth auth = FirebaseAuth.instance;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+62$phone",
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential result = await auth.signInWithCredential(credential);
        final user = result.user;
        if (user != null) {
          credentialAuth = credential;
        } else {
          print("Error");
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        key.currentState.showSnackBar(
          SnackBar(content: Text("${e.toString()}")),
        );
      },
      codeSent: (String verificationId, int resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return credentialAuth;
  }
}
