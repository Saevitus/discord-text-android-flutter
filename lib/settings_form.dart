import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsForm extends StatefulWidget {
  final Function(String) onTokenChanged;
  final Function(String) onUserIDChanged;

  const SettingsForm({
    super.key,
    required this.onTokenChanged,
    required this.onUserIDChanged,
  });

  @override
  SettingsFormState createState() => SettingsFormState();
}

class SettingsFormState extends State<SettingsForm> {
  final tokenController = TextEditingController();
  final userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPreferences();

    tokenController.addListener(() {
      widget.onTokenChanged(tokenController.text);
    });
    userIdController.addListener(() {
      widget.onUserIDChanged(userIdController.text);
    });
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenController.text = prefs.getString('discordBotToken') ?? '';
    userIdController.text = prefs.getString('userId') ?? '';
  }

  void savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('discordBotToken', tokenController.text);
    await prefs.setString('userId', userIdController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: tokenController,
            decoration: const InputDecoration(
              labelText: 'Discord Bot Token',
            ),
            onSubmitted: (_) => savePreferences(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: userIdController,
            decoration: const InputDecoration(
              labelText: 'User ID',
            ),
            onSubmitted: (_) => savePreferences(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    tokenController.dispose();
    userIdController.dispose();
    super.dispose();
  }
}
