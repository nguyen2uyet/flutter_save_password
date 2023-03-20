import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateAccount extends StatefulWidget {
  const UpdateAccount({Key? key, required this.accountKey}) : super(key: key);

  final String accountKey;

  @override
  State<StatefulWidget> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final websiteController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    //get data from different account firebase
    String username =
        FirebaseAuth.instance.currentUser!.email.toString().split(".").first;
    dbRef = FirebaseDatabase.instance.ref().child('Accounts').child(username);
    getAccountData();
  }

  void getAccountData() async {
    DataSnapshot snapshot = await dbRef.child(widget.accountKey).get();
    Map account = snapshot.value as Map;
    websiteController.text = account['website'];
    usernameController.text = account['username'];
    passwordController.text = account['password'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(websiteController.text),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: websiteController,
                  onChanged: (text) => {},
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Website: ",
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: usernameController,
                  onChanged: (text) => {},
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Username: ",
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  onChanged: (text) => {},
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Password: ",
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: passwordController.text));
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text("Copy Password"),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {
                  Map<String, String> accounts = {
                    'website': websiteController.text,
                    'username': usernameController.text,
                    'password': passwordController.text,
                  };
                  dbRef
                      .child(widget.accountKey)
                      .update(accounts)
                      .then((value) => {Navigator.pop(context)});
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text("Update data"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
