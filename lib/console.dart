import 'package:flutter/material.dart';

class Console extends StatefulWidget {
  const Console({super.key});

  @override
  ConsoleState createState() => ConsoleState();
}

class ConsoleState extends State<Console> {
  final ScrollController logScrollController = ScrollController();
  final List<String> log = [];

  void write(String text) {
    setState(() {
      log.add(text);
      // Auto-scroll to the bottom whenever a new message is added
      logScrollController.animateTo(
          logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: logScrollController,
      itemCount: log.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(log[index]),
          ),
        );
      },
    );
  }
}
