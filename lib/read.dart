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
      appBar: CreateAppBar(theme, "Interactive"),
      body: SafeArea(
          child: Center(
              child: Column(
        children: [
          ReadButton(0, Icons.sim_card, "test"),
          ReadButton(0, Icons.sim_card, "test"),
          ReadButton(0, Icons.sim_card, "test"),
          ReadButton(0, Icons.sim_card, "test"),
          ReadButton(0, Icons.sim_card, "test"),
          ReadButton(0, Icons.sim_card, "test"),
        ],
      ))),
      bottomNavigationBar: CreateNavBar(theme, 1, context),
    );
  }

  ButtonTheme ReadButton(int i, icon, text) {
    return ButtonTheme(
      minWidth: 300.0,
      height: 100.0,
      child: OutlinedButton(
          onPressed: () {
            print(i);
          },
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [Icon(Icons.sim_card_alert), Text("test")])),
    );
  }
}
