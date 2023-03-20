import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:save_password_project_1/auth_service.dart';
import 'package:save_password_project_1/update_account.dart';
import 'package:flutter/material.dart';
import 'package:save_password_project_1/insert_account.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username =
      FirebaseAuth.instance.currentUser!.email.toString().split(".").first;
  String fullname = FirebaseAuth.instance.currentUser!.displayName.toString();

  late Query dbRef;

  late DatabaseReference reference;

  //define Widget for one Item of list accounts
  Widget listItem({required Map account}) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: 150,
        color: Color.fromARGB(255, 170, 195, 212),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account['website'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              account['username'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              account['password'].toString().replaceAll(RegExp(r"."), "*"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    reference.child(account['key']).remove();
                  },
                  child: const Text("Delete"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  minWidth: 30,
                  height: 40,
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => UpdateAccount(accountKey: account['key'])))
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //if database don't have username => create new
    if (FirebaseDatabase.instance.ref().child('Accounts').child(username).key ==
        null) {
      Map<String, String> databaseOfUsername = {username: fullname};
      reference.push().set(databaseOfUsername);
    }
    dbRef = FirebaseDatabase.instance.ref().child('Accounts').child(username);
    reference =
        FirebaseDatabase.instance.ref().child('Accounts').child(username);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    AuthService().signOut();
                  },
                  child: const Text("Logout"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  minWidth: 30,
                  height: 40,
                ),
                const SizedBox(
                  width: 50,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => InsertAccount()));
                  },
                  child: const Text("Insert New Password"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  minWidth: 30,
                  height: 40,
                ),
              ],
            ),
            Flexible(
                child: FirebaseAnimatedList(
                    //get data from firebase
                    query: dbRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map account = snapshot.value as Map;
                      account['key'] = snapshot.key;
                      return listItem(account: account);
                    })),
          ],
        ));
  }
}
