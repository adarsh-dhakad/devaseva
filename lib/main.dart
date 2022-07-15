import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

List<SevasItem> sevaList = [];
Map<int, List<SevasItem>> mapList = HashMap();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      print("wertsdfggfds");
      sevasItem.add(a);
    }
    return sevasItem;
  }

  Future<List<AllCampaignsItem>> getdata() async {
    Uri u =
        Uri.https('testapi.devaseva.com', 'api/campaigns/getFeaturedCampaigns');
    // var uri = Uri.parse(
    //     "https://testapi.devaseva.com/api/campaigns/getFeaturedCampaigns/");
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
    print(allCompaignsItem.length);

    for (AllCampaignsItem d in allCompaignsItem) {
      print(d.id);
      Future<List<SevasItem>> l = getSevas(d.id);
      List<SevasItem> list = await l;
      mapList.putIfAbsent(d.id, () => list);
    }
    print("after");
    return allCompaignsItem;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          title: Text('All campaingns'),
        ),
        body: Column(children: [
          Expanded(
              child: Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 25.0,
            ),
            child: FutureBuilder(
              future: getdata(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: const Center(
                      child: Text(
                        'Loading...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  );
                } else {
                  List<AllCampaignsItem> s =
                      snapshot.data as List<AllCampaignsItem>;
                  return ListView.builder(
                      itemCount: s.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          child: Card(
                            child: ExpansionTile(
                              title: Text(s[i].name),
                              subtitle: Text(s[i].templeName),
                              trailing: Text(s[i].code),
                              children: <Widget>[
                                Column(
                                  children: _buildExpandableContent(
                                      mapList[(s[i].id)]!),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          )),
        ]),
      ),
    );
  }

  _buildExpandableContent(List<SevasItem> sevasItem) {
    List<Widget> columnContent = [];

    if (sevasItem.isNotEmpty) {
      for (SevasItem sevas in sevasItem)
        columnContent.add(
          new ListTile(
            title: new Text(
              sevas.name,
              style: new TextStyle(fontSize: 18.0),
            ),
            //    leading: new Icon(sevas.image),
          ),
        );
    } else {
      columnContent.add(
        const ListTile(
          title: Text(
            "Loadiing...",
            style: TextStyle(fontSize: 18.0),
          ),
          //    leading: new Icon(sevas.image),
        ),
      );
    }

    return columnContent;
  }
}

class AllCampaignsItem {
  String code;
  var createdBy;
  var description;
  var donorCount;
  var endDate;
  var featured;
  var id;
  var image;
  String name;
  var prasadRequest;
  var priority;
  var raisedAmount;
  var shortDesc;
  var status;
  var targetAmount;
  var templeCode;
  var templeId;
  var templeImage;
  String templeName;
  int getInt() {
    return id;
  }

  AllCampaignsItem(
      this.code,
      this.createdBy,
      this.description,
      this.donorCount,
      this.endDate,
      this.featured,
      this.id,
      this.image,
      this.name,
      this.prasadRequest,
      this.priority,
      this.raisedAmount,
      this.shortDesc,
      this.status,
      this.targetAmount,
      this.templeCode,
      this.templeId,
      this.templeImage,
      this.templeName);
}

class SevasItem {
  var campaignId;
  var campaignSevaLanguageId;
  var category;
  var code;
  var description;
  var detailsMandatory;
  var devoteeCount;
  var discountedPrice;
  var displayPrice;
  var enabled;
  int id = 0;
  var image;
  var marketPrice;
  var name = "adarsh";
  var priority;
  var sevaId;
  var templeCode;
  var templeId;
  var templeImage;
  var templeName;
  SevasItem(
      this.campaignId,
      this.campaignSevaLanguageId,
      this.category,
      this.code,
      this.description,
      this.detailsMandatory,
      this.devoteeCount,
      this.discountedPrice,
      this.displayPrice,
      this.enabled,
      this.id,
      this.image,
      this.marketPrice,
      this.name,
      this.priority,
      this.sevaId,
      this.templeCode,
      this.templeId,
      this.templeImage,
      this.templeName);
  // SevasItem(this.id);
}
