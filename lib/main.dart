import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_discord/settings_form.dart';
import 'package:test_discord/sms_listener.dart';

import 'discord_bot.dart';
import 'console.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Discord Bot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Discord Bot'),
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
  final GlobalKey<ConsoleState> consoleKey = GlobalKey<ConsoleState>();
  late DiscordBot discordBot;
  bool showReader = false;

  String _botToken = '';
  String _userID = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            child: Console(key: consoleKey),
          ),
          SettingsForm(
            onTokenChanged: (token) {
              setState(() {
                _botToken = token;
              });
            },
            onUserIDChanged: (userID) {
              setState(() {
                _userID = userID;
              });
            },
          ),
          if (showReader)
            Expanded(
              child: SMSReader(bot: discordBot),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('botToken', _botToken);
          await prefs.setString('userId', _userID);

          if (!showReader) {
            discordBot = DiscordBot(consoleKey: consoleKey);
            discordBot.initBot(
                _botToken, _userID); // Pass the token and ID here

            setState(() {
              showReader = true; // Modifies UI to show SMSReader
            });
          } else {
            discordBot.discordClient!.close(); // Shut down the bot here

            setState(() {
              showReader = false; // Hides SMSReader and bot is deactivated
            });
          }
        },
        label: showReader ? const Text('Deactivate Bot') : const Text('Initialize Bot'),
        icon: const Icon(Icons.adjust),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 55.0,
        ),
      ),
    );
  }
}
