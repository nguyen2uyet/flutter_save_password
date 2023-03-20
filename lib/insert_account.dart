import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:save_password_project_1/main.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class InsertAccount extends StatefulWidget {
  const InsertAccount({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InsertAccountState();
}

class _InsertAccountState extends State<InsertAccount> {
  // final Account account;
  final userNameController = TextEditingController();
  final websiteController = TextEditingController();
  final passwordController = TextEditingController();

  late DatabaseReference dbRef;

  String getCharFromASCIICodeRange(int a, int b) {
    return String.fromCharCode(math.Random().nextInt(b - a) + a);
  }

  String randomPasswordWith16Characters(int number) {
    List<String> password = [];
    for (int i = 1; i <= number; i++) {
      List<String> list_of_char = [];
      String lowercase = getCharFromASCIICodeRange(97, 122);
      String uppercase = getCharFromASCIICodeRange(65, 90);
      String special_character_1 = getCharFromASCIICodeRange(32, 47);
      String special_character_2 = getCharFromASCIICodeRange(58, 64);
      String special_character_3 = getCharFromASCIICodeRange(91, 96);
      String special_character_4 = getCharFromASCIICodeRange(123, 126);
      list_of_char.add(lowercase);
      list_of_char.add(uppercase);
      list_of_char.add(special_character_1);
      list_of_char.add(special_character_2);
      list_of_char.add(special_character_3);
      list_of_char.add(special_character_4);
      String randomChar = list_of_char[math.Random().nextInt(6)];
      password.add(randomChar);
    }
    return password.join('');
  }

  @override
  void initState() {
    super.initState();
    //get data from different account firebase
    String username =
        FirebaseAuth.instance.currentUser!.email.toString().split(".").first;
    dbRef = FirebaseDatabase.instance.ref().child("Accounts").child(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert data"),
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
                  controller: userNameController,
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
                  String password = randomPasswordWith16Characters(16);
                  passwordController.text = password;
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text("Generate Strong Password"),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {
                  Map<String, String> accounts = {
                    'website': websiteController.text,
                    'username': userNameController.text,
                    'password': passwordController.text,
                  };
                  dbRef.push().set(accounts);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => MyApp()));
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text("Insert data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
