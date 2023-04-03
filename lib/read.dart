import 'package:engagement/components.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadPage extends StatelessWidget {
  const ReadPage({super.key});
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CreateAppBar(theme, "Readable"),
      body: SafeArea(
          child: Center(
              child: Column(
        children: [
          ReadButton(0, Icons.sunny, "Solar Potential"),
          ReadButton(0, Icons.storage, "Energy Storage"),
          ReadButton(0, Icons.account_balance, "Regulations"),
          ReadButton(0, Icons.people, "Social Sustainability"),
          ReadButton(0, Icons.money, "Economic Sustainability"),
          ReadButton(0, Icons.eco, "Environmental Sustainability"),
        ],
      ))),
      bottomNavigationBar: CreateNavBar(theme, 2, context),
    );
  }

  ButtonTheme ReadButton(int i, IconData icon, String text) {
    return ButtonTheme(
      minWidth: 300.0,
      height: 100.0,
      child: OutlinedButton(
          onPressed: () {
            print(i);
          },
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [Icon(icon), Text(text)])),
    );
  }
}
