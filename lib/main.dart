import 'package:flutter/material.dart';
import 'package:pinjam_kredit/provider/nasabah_provider.dart';
import 'package:pinjam_kredit/view/page_home.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (BuildContext context) => NasabahProvider.init(),
        child: PageHome(),
      ),
    );
  }
}
