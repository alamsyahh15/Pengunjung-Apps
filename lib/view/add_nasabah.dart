import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pinjam_kredit/model/bank_model.dart';
import 'package:pinjam_kredit/model/nasabah_model.dart';
import 'package:pinjam_kredit/provider/nasabah_provider.dart';
import 'package:pinjam_kredit/provider/nasabah_repository.dart';
import 'package:pinjam_kredit/view/camera_page.dart';
import 'package:provider/provider.dart';

String dateFormat(DateTime date) => DateFormat("MM/dd/yyyy").format(date);

class AddNasabahPage extends StatefulWidget {
  final Nasabah nasabah;

  const AddNasabahPage({Key key, this.nasabah}) : super(key: key);
  @override
  _AddNasabahPageState createState() => _AddNasabahPageState();
}

class _AddNasabahPageState extends State<AddNasabahPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  File imageFile;
  Nasabah dataNasabah = Nasabah(bank: Bank());
  int valueBank;
  DateTime timeNow = DateTime.now();
  Timer timer;
  int limitSend = 120;
  bool waiting = false;
  void sendOtp() {
    setState(() => waiting = true);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (limitSend > 0) {
        setState(() => limitSend--);
      }
      if (limitSend == 0) {
        timer.cancel();
        setState(() {
          limitSend = 60;
          waiting = false;
        });
      }
    });
  }

  void selectDate() async {
    DateTime res = await showDatePicker(
      context: context,
      initialDate: timeNow,
      firstDate: DateTime(1945, 1, 1),
      lastDate: DateTime(2099, 12, 31),
      initialEntryMode: DatePickerEntryMode.input,
    );

    if (res != null) {
      timeNow = res;
      dataNasabah.birthNasabah = timeNow;
    }
    setState(() {});
  }

  void selectWorkStatus(int val) {
    setState(() => dataNasabah.workStatus = val);
  }

  void initialize() async {
    final res = await Firebase.initializeApp();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();

    if (widget.nasabah != null) {
      this.dataNasabah = widget.nasabah;
      this.timeNow = dataNasabah.birthNasabah;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NasabahProvider.upAdd(),
      child: Consumer<NasabahProvider>(
        builder: (context, provider, _) => Scaffold(
          key: key,
          appBar: AppBar(
            title: Text(widget?.nasabah == null ? "Add Data" : "Update Data"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            imageFile = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraPage()),
                            );
                            setState(() {});
                          },
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: imageFile != null
                                        ? Image.file(
                                            imageFile,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            "${dataNasabah.photoNasabah}",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 16,
                          decoration: InputDecoration(
                            hintText: '16012312xxx',
                            labelText: 'NIK *',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          initialValue: dataNasabah?.nikNasabah ?? "",
                          onChanged: (val) {
                            dataNasabah.nikNasabah = val;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Mathius',
                            labelText: 'Nama *',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          initialValue: dataNasabah?.nameNasabah ?? "",
                          onChanged: (val) {
                            dataNasabah.nameNasabah = val;
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Tanggal Lahir",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: dateFormat(timeNow),
                          ),
                          onTap: () {
                            selectDate();
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Jalan Kesehatan...',
                            labelText: 'Alamat *',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          initialValue: dataNasabah?.addressNasabah ?? "",
                          onChanged: (val) {
                            dataNasabah.addressNasabah = val;
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixText: '+62 ',
                                  labelText: 'Telepon *',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                                initialValue: dataNasabah?.phoneNasabah ?? "",
                                onChanged: (val) {
                                  dataNasabah.phoneNasabah = val;
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            MaterialButton(
                              color: Colors.grey,
                              textColor: Colors.white,
                              child:
                                  Text(waiting ? "$limitSend s" : "Kirim OTP"),
                              onPressed: () {
                                if (waiting == false) {
                                  sendOtp();
                                  NasabahRepo.credetialAuth(
                                      dataNasabah.phoneNasabah, key);
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'OTP *',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(waiting ? "$limitSend detik tersisa" : ""),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Status Kepegawaian",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: RadioListTile(
                                value: 0,
                                groupValue: dataNasabah.workStatus,
                                title: Text("Aktif Bekerja"),
                                onChanged: (val) {
                                  selectWorkStatus(val);
                                },
                              ),
                            ),
                            Flexible(
                              child: RadioListTile(
                                value: 1,
                                groupValue: dataNasabah.workStatus,
                                title: Text("Pensiun"),
                                onChanged: (val) {
                                  selectWorkStatus(val);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixText: 'Rp ',
                            labelText: 'Gaji Aktif Pensiun *',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          initialValue: dataNasabah?.salaryMonth ?? "",
                          onChanged: (val) {
                            dataNasabah.salaryMonth = val;
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Pembayaran gaji dengan bank",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        DropdownButton(
                          isExpanded: true,
                          hint: Text("Select Bank"),
                          value: dataNasabah?.bank?.idBank,
                          items: provider.listBank.map((e) {
                            return DropdownMenuItem(
                              child: Text("${e.nameBank}"),
                              value: e.idBank,
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => dataNasabah?.bank?.idBank = val);
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '...',
                            labelText: 'Sales Response *',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          initialValue: dataNasabah?.salesResponse ?? "",
                          onChanged: (val) {
                            dataNasabah.salesResponse = val;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Button Trigger
              Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Text("Simpan"),
                        onPressed: () {
                          if (widget.nasabah != null) {
                            provider.updateNasabah(
                                context, dataNasabah, imageFile);
                          } else {
                            provider.addNasabah(
                                context, dataNasabah, imageFile);
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.nasabah != null,
                    child: Flexible(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: Colors.red,
                          child: Text("Delete"),
                          textColor: Colors.white,
                          onPressed: () {
                            provider.deleteNasabah(context, dataNasabah);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
