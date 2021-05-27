import 'package:flutter/material.dart';
import 'package:pinjam_kredit/components/header_widget.dart';
import 'package:pinjam_kredit/model/nasabah_model.dart';
import 'package:pinjam_kredit/provider/nasabah_provider.dart';
import 'package:pinjam_kredit/provider/nasabah_repository.dart';
import 'package:pinjam_kredit/view/add_nasabah.dart';
import 'package:pinjam_kredit/view/page_home.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final Function() onBackDetail;

  const SearchPage({Key key, this.onBackDetail}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NasabahProvider.init(),
      child: Consumer<NasabahProvider>(
        builder: (context, provider, _) => Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                HeaderWidget(
                  onClear: () {},
                  onSubmited: (String value) {
                    provider.search(value);
                  },
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: provider?.listNasabah?.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (provider.listNasabah == null) {
                            return LoadingList(
                                width: MediaQuery.of(context).size.width);
                          } else {
                            Nasabah data = provider?.listNasabah[index];
                            return Container(
                              child: ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      "${data.photoNasabah}",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.person,
                                            color: Colors.white);
                                      },
                                    ),
                                  ),
                                ),
                                title: Text(data?.nameNasabah ?? "Nama"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data?.phoneNasabah ?? "Phone"),
                                    Text(data?.salesResponse ?? "Response"),
                                  ],
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    print("Test");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: data?.statusNasabah == 2
                                          ? Colors.red
                                          : data?.statusNasabah == 1
                                              ? Colors.green
                                              : Colors.orange,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                        data?.statusNasabah == 2
                                            ? "Reject"
                                            : data?.statusNasabah == 1
                                                ? "Accept"
                                                : "Pending",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddNasabahPage(nasabah: data)),
                                  ).then((value) {
                                    if ((provider?.listNasabah?.length ?? 0) <
                                        15) {
                                      provider.refresh();
                                    }
                                  });
                                },
                              ),
                            );
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
