import 'package:flutter/material.dart';
import 'package:pinjam_kredit/model/nasabah_model.dart';
import 'package:pinjam_kredit/provider/nasabah_provider.dart';
import 'package:pinjam_kredit/provider/nasabah_repository.dart';
import 'package:pinjam_kredit/view/add_nasabah.dart';
import 'package:pinjam_kredit/view/search_page.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NasabahProvider>(
      builder: (context, provider, _) => Scaffold(
        appBar: AppBar(
          title: Text("Kunjungan Saya"),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(
                        onBackDetail: () {
                          if ((provider?.listNasabah?.length ?? 0) < 15) {
                            provider.refresh();
                          }
                        },
                      ),
                    ));
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            provider.init();
          },
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
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.person, color: Colors.white);
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
                            provider.updateStatus(context, data);
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddNasabahPage(nasabah: data)),
                          ).then((value) {
                            if ((provider?.listNasabah?.length ?? 0) < 15) {
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNasabahPage()),
            ).then((value) {
              if ((provider?.listNasabah?.length ?? 0) < 15) {
                provider.refresh();
              }
            });
          },
        ),
      ),
    );
  }
}

class LoadingList extends StatelessWidget {
  final double width;

  const LoadingList({Key key, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
        ),
        title: Container(
          width: width,
          height: 10,
          color: Colors.grey,
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: 5,
              color: Colors.grey,
            ),
            Container(
              width: width,
              height: 5,
              color: Colors.grey,
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text("Status"),
        ),
      ),
    );
  }
}
