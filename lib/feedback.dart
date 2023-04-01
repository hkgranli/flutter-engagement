import 'package:engagement/components.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CreateAppBar(theme, "Home"),
      body: Center(child: const Text("You are in the feedback")),
      bottomNavigationBar: CreateNavBar(theme, 0, context),
    );
  }
}
