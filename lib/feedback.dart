import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:engagement/components.dart';
import 'package:engagement/interactive.dart';
import 'package:engagement/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, AppLocalizations.of(context)!.feedback),
      body: Center(child: evalButton(context)),
      bottomNavigationBar: EngagementNavBar(index: 2),
    );
  }

  Widget evalButton(BuildContext context) => ElevatedButton(
      onPressed: () => launchUrl(
          Uri.parse('https://forms.office.com/e/wjguScpCCa'),
          mode: LaunchMode.inAppWebView),
      child: Text(AppLocalizations.of(context)!.feedb));
}
