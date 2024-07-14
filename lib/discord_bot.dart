import 'package:flutter/cupertino.dart';
import 'package:nyxx/nyxx.dart';

import 'console.dart';

class DiscordBot {
  final GlobalKey<ConsoleState> consoleKey;
  var botToken = "";
  var userId = "";

  DiscordBot({required this.consoleKey});

  NyxxGateway? discordClient;

  Future<void> sendMessageToServer(String message) async {
    if (discordClient != null) {
      final dmChannel =
          await discordClient!.users.createDm(Snowflake(int.parse(userId)));
      await dmChannel.sendMessage(MessageBuilder(content: message));
    }
  }

  Future<void> initBot(botToken, userId) async {
    this.botToken = botToken;
    this.userId = userId;

    //MTIwMjY4OTQ5ODEyMzczMTAyNA.Ghyi5W.lfC2mx9BoDOSm02v9XUB-MSZRtGANiQcYfLj78
    discordClient =
        await Nyxx.connectGateway(this.botToken, GatewayIntents.all);

    //final botUser = await discordClient.users.fetchCurrentUser();

    final dm = await discordClient!.users.createDm(Snowflake(int.parse(userId)));
    await dm.sendMessage(MessageBuilder(content: 'App Started'));

    discordClient!.onMessageCreate.listen((event) async {
      consoleKey.currentState!.write(event.message.content);
    });
  }
}
