import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(child: Text("Enter url to be shortened")),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                    controller: _controller,
                    onChanged: (val) {
                      _controller.value = _controller.value.copyWith(
                        text: val,
                        selection: TextSelection.collapsed(offset: val.length),
                      );
                    })),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _writeToCloudFirestore,
                child: const Text("Make it short!")),
            const SizedBox(height: 20),
            const Center(child: Text("Your shortened url")),
            const SizedBox(height: 20),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("urls")
                    .doc("qTfq50BhL4BYcR54srpe") // <-- replace with your doc id
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.data == null
                      ? const Text("waiting ...")
                      : Text(snapshot.data!.data()!["shortUrl"]);
                }),
          ],
        )));
  }

  Future _writeToCloudFirestore() async {
    await FirebaseFirestore.instance
        .collection("urls")
        .doc("qTfq50BhL4BYcR54srpe") // <-- replace with your doc id
        .update({"url": _controller.text});
  }
}
