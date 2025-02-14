import 'package:flutter/material.dart';
import 'package:workshop/core/lifecycle/lifecycle_listener.dart';
import 'package:workshop/core/lifecycle/page2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController textEditingController;

  late final LifecycleListener _lifecycleListener;
  @override
  void initState() {

    print("initState");
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Page2()),
              );
            }, child: const Text("Go to Page2"))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    print("dispose");
    super.dispose();
  }
}

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

