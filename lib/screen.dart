import 'dart:collection';
import 'dart:convert';
import 'package:devaseva/model/AllCampaignsItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/SevasItem.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _Screen createState() => _Screen();
}

class _Screen extends State<Screen> {
  late List<AllCampaignsItem> campaignsList;
  Map<int, List<SevasItem>> mapList = HashMap();
  bool waiting = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    Uri u =
        Uri.https('testapi.devaseva.com', 'api/campaigns/getFeaturedCampaigns');
    var res = await http.get(u);
    var jsonData = jsonDecode(res.body);
    List<AllCampaignsItem> allCompaignsItem = [];

    for (var u in jsonData) {
      AllCampaignsItem a = AllCampaignsItem(
        u['code'],
        u['createdBy'],
        u['description'],
        u['donorCount'],
        u['endDate'],
        u['featured'],
        u['id'],
        u['image'],
        u['name'],
        u['prasadRequest'],
        u['priority'],
        u['raisedAmount'],
        u['shortDesc'],
        u['status'],
        u['targetAmount'],
        u['templeCode'],
        u['templeId'],
        u['templeImage'],
        u['templeName'],
      );
      allCompaignsItem.add(a);
    }

    campaignsList = allCompaignsItem;
    for (AllCampaignsItem d in allCompaignsItem) {
      Future<List<SevasItem>> l = getSevas(d.id);
      List<SevasItem> list = await l;
      mapList.putIfAbsent(d.id, () => list);
    }
    setState(() {
      waiting = false;
    });
  }

  Future<List<SevasItem>> getSevas(int id) async {
    Uri u = Uri.https('testapi.devaseva.com', 'api/campaigns/GetAllSevas/$id');
    var res = await http.get(u);
    var jsonData = jsonDecode(res.body);

    List<SevasItem> sevasItem = [];
    for (var u in jsonData) {
      SevasItem a = SevasItem(
          u['campaignId'],
          u['campaignSevaLanguageId'],
          u['category'],
          u['code'],
          u['description'],
          u['detailsMandatory'],
          u['devoteeCount'],
          u['discountedPrice'],
          u['displayPrice'],
          u['enabled'],
          u['id'],
          u['image'],
          u['marketPrice'],
          u['name'],
          u['priority'],
          u['sevaId'],
          u['templeCode'],
          u['templeId'],
          u['templeImage'],
          u['templeName']);
      sevasItem.add(a);
    }

    return sevasItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('All campaigns'),
      ),
      body: (waiting)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: campaignsList.length,
                      itemBuilder: (BuildContext context, i) {
                        return Card(
                          elevation: 3,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 25.0,
                          ),
                          child: ClipPath(
                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3))),
                            child: Column(children: [
                              const CircleAvatar(
                                radius: 50.0,
                                backgroundImage: AssetImage('images/temple.jpg'),
                             )
                              ,
                              ExpansionTile(
                                title: Text(campaignsList[i].name),
                                subtitle: Text(campaignsList[i].templeName),
                                leading : Text(campaignsList[i].code),
                                children: <Widget>[
                                  Column(
                                    children: _buildExpandableContent(
                                        mapList[(campaignsList[i].id)]!),
                                  ),
                                ],
                              ),
                              Row(children: [
                                SizedBox(
                                  height: 100.0,
                                  width: 100.0,
                                  child: Column(children: [
                                    Image.network(
                                        'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif')
                                  ]),
                                ),
                                SizedBox(
                                  height: 100.0,
                                  width: 100.0,
                                  child: Column(children: [
                                    Image.network(
                                        'https://picsum.photos/250?image=9'),
                                  ]),
                                ),
                              ]),
                            ]),
                          ),
                        );
                      }))
            ]),
    );
  }

  _buildExpandableContent(List<SevasItem> sevasItem) {
    List<Widget> columnContent = [];

    if (sevasItem.isNotEmpty) {
      for (SevasItem seva in sevasItem) {
        columnContent.add(
          ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(
                    color: Colors.lightBlueAccent, width: 3),
              ),
              title: Text(
                seva.name,
                style: const TextStyle(fontSize: 18.0),
              ),
              subtitle: Text(" ${seva.description}"),
              //    leading: new Icon(sevas.image),
            ),
          ),
        );
      }
    } else {
      columnContent.add(
        const ListTile(
          title: Text(
            "Loading...",
            style: TextStyle(fontSize: 18.0),
          ),
          //    leading: new Icon(sevas.image),
        ),
      );
    }

    return columnContent;
  }
}
