import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter_test/Constants/AppTextStyle.dart';
import 'package:new_flutter_test/Constants/ColorConstants.dart';
import 'package:new_flutter_test/Helpers/Database.dart';
import 'package:new_flutter_test/Models/UserModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:new_flutter_test/DummyData.dart' as DummyData;

import 'Components/UnderScreenContainer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        leading: SizedBox.shrink(),
      ),
      body: FutureBuilder<List<User>>(
        future: DBProvider.db.getAllUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Database is Empty !",
                    style: AppTextStyle.boldTitle20
                        .copyWith(color: PaletteColors.blackAppColor),
                  ),
                  Text(
                    "Click Button Below for adding new data!",
                    style: AppTextStyle.thinTitle10
                        .copyWith(color: PaletteColors.blackAppColor),
                  ),
                ],
              ));
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                User item = snapshot.data[index];

                return Dismissible(
                  secondaryBackground: UnderScreenContainer(),
                  key: UniqueKey(),
                  background: UnderScreenContainer(),
                  onDismissed: (direction) {
                    DBProvider.db.deleteUser(item.id);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.firstName,
                              style: AppTextStyle.regularTitle16,
                            ),
                            Text(
                              item.email,
                              style: AppTextStyle.thinTitle12,
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.location_on,
                            color: PaletteColors.mainAppColor,
                            size: 24,
                          ),
                          onPressed: () {
                            _launchURL(
                                url:
                                    "https://www.google.com/maps/search/?api=1&query=${snapshot.data[index].lat},${snapshot.data[index].lng}");
                          },
                        ),
                        CircleAvatar(
                            backgroundImage:
                                FileImage(File(snapshot.data[index].picture)),
                            radius: 20,
                            backgroundColor: Colors.white),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () async {
      //     User rnd = DummyData.testUsers[math.Random().nextInt(DummyData.testUsers.length)];
      //      var sss =await DBProvider.db.newUser(new User(IMEI: 123323,firstName: "fffff",lastName: "sjjdjj",email: "wsdsdsd",picture: "Ewqdeqdw",passport: 121313,doB:"12-12-2020",deviceName: "IOS :",lat: 12.222,lng: 23.333));
      //      print(sss);
      //     setState(() {});
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: PaletteColors.mainAppColor,
          child: Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, "/registration")),
    );
  }

  _launchURL({String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
