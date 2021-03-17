import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter_test/Helpers/Database.dart';
import 'package:new_flutter_test/Models/UserModel.dart';
import 'dart:math' as math;

import 'package:new_flutter_test/DummyData.dart' as DummyData;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter New Test")),
      body: FutureBuilder<List<User>>(
        future: DBProvider.db.getAllUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                User item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBProvider.db.deleteUser(item.id);
                  },
                  child: ListTile(
                    title: Text(item.firstName),
                    leading: Text(item.id.toString()),
                    trailing: Text(item.lastName),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          User rnd = DummyData.testUsers[math.Random().nextInt(DummyData.testUsers.length)];
          await DBProvider.db.newUser(rnd);
          setState(() {});
        },
      ),
    );
  }
}
