// To parse this JSON data, do
//
//     final nasabahModel = nasabahModelFromJson(jsonString);

import 'dart:convert';

import 'package:pinjam_kredit/model/bank_model.dart';

NasabahModel nasabahModelFromJson(String str) =>
    NasabahModel.fromJson(json.decode(str));

String nasabahModelToJson(NasabahModel data) => json.encode(data.toJson());

class NasabahModel {
  NasabahModel({
    this.status,
    this.message,
    this.nasabah,
  });

  bool status;
  String message;
  List<Nasabah> nasabah;

  factory NasabahModel.fromJson(Map<String, dynamic> json) => NasabahModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        nasabah: json["nasabah"] == null
            ? null
            : List<Nasabah>.from(
                json["nasabah"].map((x) => Nasabah.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "nasabah": nasabah == null
            ? null
            : List<dynamic>.from(nasabah.map((x) => x.toJson())),
      };
}

class Nasabah {
  Nasabah({
    this.idNasabah,
    this.nikNasabah,
    this.nameNasabah,
    this.birthNasabah,
    this.addressNasabah,
    this.workStatus,
    this.salaryMonth,
    this.salesResponse,
    this.photoNasabah,
    this.phoneNasabah,
    this.bank,
    this.statusNasabah,
  });

  int idNasabah;
  String nikNasabah;
  String nameNasabah;
  DateTime birthNasabah;
  String addressNasabah;
  int workStatus;
  String salaryMonth;
  String salesResponse;
  String photoNasabah;
  String phoneNasabah;
  Bank bank;
  int statusNasabah;

  factory Nasabah.fromJson(Map<String, dynamic> json) => Nasabah(
        idNasabah: json["id_nasabah"] == null ? null : json["id_nasabah"],
        nikNasabah: json["nik_nasabah"] == null ? null : json["nik_nasabah"],
        nameNasabah: json["name_nasabah"] == null ? null : json["name_nasabah"],
        birthNasabah: json["birth_nasabah"] == null
            ? null
            : DateTime.parse(json["birth_nasabah"]),
        addressNasabah:
            json["address_nasabah"] == null ? null : json["address_nasabah"],
        workStatus: json["work_status"] == null ? null : json["work_status"],
        salaryMonth: json["salary_month"] == null ? null : json["salary_month"],
        salesResponse:
            json["sales_response"] == null ? null : json["sales_response"],
        photoNasabah:
            json["photo_nasabah"] == null ? null : json["photo_nasabah"],
        phoneNasabah:
            json["phone_nasabah"] == null ? null : json["phone_nasabah"],
        bank: json["bank"] == null ? null : Bank.fromJson(json["bank"]),
        statusNasabah:
            json['status_nasabah'] == null ? null : json['status_nasabah'],
      );

  Map<String, dynamic> toJson() => {
        "id_nasabah": idNasabah == null ? null : idNasabah,
        "nik_nasabah": nikNasabah == null ? null : nikNasabah,
        "name_nasabah": nameNasabah == null ? null : nameNasabah,
        "birth_nasabah": birthNasabah == null
            ? null
            : "${birthNasabah.year.toString().padLeft(4, '0')}-${birthNasabah.month.toString().padLeft(2, '0')}-${birthNasabah.day.toString().padLeft(2, '0')}",
        "address_nasabah": addressNasabah == null ? null : addressNasabah,
        "work_status": workStatus == null ? null : workStatus,
        "salary_month": salaryMonth == null ? null : salaryMonth,
        "sales_response": salesResponse == null ? null : salesResponse,
        "photo_nasabah": photoNasabah == null ? null : photoNasabah,
        "phone_nasabah": phoneNasabah == null ? null : phoneNasabah,
        "bank": bank == null ? null : bank.toJson(),
        "status_nasabah": statusNasabah == null ? null : statusNasabah,
      };
}
