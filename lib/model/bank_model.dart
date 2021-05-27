// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel {
  BankModel({
    this.status,
    this.message,
    this.bank,
  });

  bool status;
  String message;
  List<Bank> bank;

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        bank: json["bank"] == null
            ? null
            : List<Bank>.from(json["bank"].map((x) => Bank.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "bank": bank == null
            ? null
            : List<dynamic>.from(bank.map((x) => x.toJson())),
      };
}

class Bank {
  Bank({
    this.idBank,
    this.nameBank,
  });

  int idBank;
  String nameBank;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        idBank: json["id_bank"] == null ? null : json["id_bank"],
        nameBank: json["name_bank"] == null ? null : json["name_bank"],
      );

  Map<String, dynamic> toJson() => {
        "id_bank": idBank == null ? null : idBank,
        "name_bank": nameBank == null ? null : nameBank,
      };
}
