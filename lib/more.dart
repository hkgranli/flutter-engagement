import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInfo extends StatefulWidget {
  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  Widget about() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/ntnu_logo.png',
                width: 250,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(AppLocalizations.of(context)!.about_project_blockp1),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/helios_logo.png',
                width: 250,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.about_project_blockp2),
          //SizedBox(height: 10),
          //Text(AppLocalizations.of(context)!.about_project_blockp3),
          SizedBox(height: 10),
          SizedBox(child: VideoApp()),
          SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.about_contact),
          SizedBox(height: 10),
          Row(children: [
            Icon(Icons.email),
            Text("Hans Kristian Granli - hkgranli@stud.ntnu.no")
          ]),
          Row(children: [
            Icon(Icons.email),
            Text("Sobah Abbas Petersen - sap@ntnu.no")
          ]),

          SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.helios_contact),

          Row(children: [
            Icon(Icons.email),
            Text("Gabriele Lobaccaro - gabriele.lobaccaro@ntnu.no")
          ]),
          Row(children: [
            Icon(Icons.email),
            Text("Tahmineh Akbarinejad - tahmineh.akbarinejad@ntnu.no")
          ]),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () => launchUrl(Uri.parse('https://www.ntnu.edu/helios'),
                mode: LaunchMode.externalApplication),
            child: Text(AppLocalizations.of(context)!.helios_homepage),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, "joe"),
      body: SingleChildScrollView(child: about()),
    );
  }
}
