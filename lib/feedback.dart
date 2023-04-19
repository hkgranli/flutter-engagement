import 'package:engagement/components.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, "Home"),
      body: Center(child: const Text("You are in the feedback")),
      bottomNavigationBar: EngagementNavBar(index: 2),
    );
  }
}
