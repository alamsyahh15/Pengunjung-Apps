import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinjam_kredit/components/progress_dialog.dart';
import 'package:pinjam_kredit/model/bank_model.dart';
import 'package:pinjam_kredit/model/nasabah_model.dart';

import 'nasabah_repository.dart';

class NasabahProvider extends ChangeNotifier {
  // Construct
  NasabahProvider.init() {
    this.init();
  }
  NasabahProvider.upAdd() {
    this.getBank();
  }

  /// Property
  List<Nasabah> listNasabah;
  List<Nasabah> listNasabahBackup = [];
  List<Bank> listBank = [];

  /// Function

  // Get Nasabah
  void init() async {
    listNasabah = await NasabahRepo.getNasabah();
    listNasabahBackup.addAll(listNasabah);
    notifyListeners();
  }

  void refresh() {
    listNasabah = null;
    listNasabahBackup.clear();
    notifyListeners();
    init();
  }

  void search(String query) {
    listNasabah = listNasabahBackup;
    if (query.isNotEmpty) {
      listNasabah = listNasabah
          .where((element) => element.nameNasabah.toLowerCase().contains(query))
          .toList();
    }
    notifyListeners();
  }

  void getBank() async {
    final res = await NasabahRepo.getBank();
    if (res != null) {
      listBank = res;
    }
    notifyListeners();
  }

  void addNasabah(context, Nasabah nasabah, File image) async {
    if (validation("Create", nasabah, image: image)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            "Apakah anda yakin telah mengedit data dengan benar ?",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Setiap data yang anda edit akan kami simpan dan mengubahnya di data kantor pusat. Perhatikan kembali data - data yang anda input",
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            MaterialButton(
              child: Text("Mengedit Lagi"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text("Simpan Data"),
              onPressed: () async {
                progressDialog(context);
                final res = await NasabahRepo.addNasabah(nasabah, image);
                Navigator.pop(context);
                if (res != null) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  dialogData(
                    context,
                    "Attention!!",
                    "Gagal daftarkan pengunjung",
                    onBack: () {
                      Navigator.pop(context);
                    },
                  );
                }
              },
            ),
          ],
        ),
      );
    } else {
      dialogData(context, "Attention!!", "Silahkan lengkapi data");
    }
  }

  void updateNasabah(context, Nasabah nasabah, File image) async {
    if (validation("Update", nasabah, image: image)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            "Apakah anda yakin telah mengedit data dengan benar ?",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Setiap data yang anda edit akan kami simpan dan mengubahnya di data kantor pusat. Perhatikan kembali data - data yang anda input",
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            MaterialButton(
              child: Text("Mengedit Lagi"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text("Simpan Data"),
              onPressed: () async {
                progressDialog(context);
                final res = await NasabahRepo.updateNasabah(nasabah, image);
                Navigator.pop(context);
                if (res != null) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  dialogData(
                    context,
                    "Attention!!",
                    "Gagal daftarkan pengunjung",
                    onBack: () {
                      Navigator.pop(context);
                    },
                  );
                }
              },
            ),
          ],
        ),
      );
    } else {
      dialogData(context, "Attention!!", "Silahkan lengkapi data");
    }
  }

  void updateStatus(context, Nasabah nasabah) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "Silahkan pilih status untuk mengedit data ini ?",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Pilih status REJECT untuk menolak data ini, dan pilih status ACCEPT untuk menyetujui data ini",
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          MaterialButton(
            child: Text("Accept"),
            onPressed: () async {
              progressDialog(context);
              nasabah.statusNasabah = 1;
              final res = await NasabahRepo.updateStatus(nasabah);
              Navigator.pop(context);
              if (res != null) {
                Navigator.pop(context);
                refresh();
              } else {
                dialogData(
                  context,
                  "Attention!!",
                  "Gagal update status pengunjung",
                  onBack: () {
                    Navigator.pop(context);
                  },
                );
              }
            },
          ),
          MaterialButton(
            child: Text("Reject"),
            onPressed: () async {
              progressDialog(context);
              nasabah.statusNasabah = 2;
              final res = await NasabahRepo.updateStatus(nasabah);
              Navigator.pop(context);
              if (res != null) {
                Navigator.pop(context);
                refresh();
              } else {
                dialogData(
                  context,
                  "Attention!!",
                  "Gagal update status pengunjung",
                  onBack: () {
                    Navigator.pop(context);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  dialogData(BuildContext context, String title, String content,
      {Function() onBack}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? ""),
        content: Text(content ?? ""),
        actions: [
          MaterialButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Text("Back"),
            onPressed: () {
              Navigator.pop(context);
              if (onBack != null) {
                onBack();
              }
            },
          )
        ],
      ),
    );
  }

  bool validation(String action, Nasabah nas, {File image}) {
    if (action == "Create") {
      return image != null &&
          nas.nikNasabah != null &&
          nas.nameNasabah != null &&
          nas.birthNasabah != null &&
          nas.addressNasabah != null &&
          nas.workStatus != null &&
          nas.salaryMonth != null &&
          nas?.bank?.idBank != null &&
          nas.salesResponse != null &&
          nas.phoneNasabah != null;
    } else {
      return nas.nikNasabah != null &&
          nas.nameNasabah != null &&
          nas.birthNasabah != null &&
          nas.addressNasabah != null &&
          nas.workStatus != null &&
          nas.salaryMonth != null &&
          nas?.bank?.idBank != null &&
          nas.salesResponse != null &&
          nas.phoneNasabah != null;
    }
  }
}
