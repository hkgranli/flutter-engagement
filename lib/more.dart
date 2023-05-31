import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

enum MorePages { landing, helios, app }

class MoreInfo extends StatefulWidget {
  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  MorePages activePage = MorePages.landing;

  void setActivePage(MorePages mp) {
    setState(() {
      activePage = mp;
    });
  }

  Scaffold about() {
    Widget content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/helios_logo.png',
                  width: 250,
                ),
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
          Center(
            child: ElevatedButton(
              onPressed: () => launchUrl(
                  Uri.parse('https://www.ntnu.edu/helios'),
                  mode: LaunchMode.externalApplication),
              child: Text(AppLocalizations.of(context)!.helios_homepage),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: createAppBar(
        context,
        AppLocalizations.of(context)!.about_h,
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setActivePage(MorePages.landing),
        ),
      ),
      body: SingleChildScrollView(
        child: content,
      ),
    );
  }

  Scaffold landing() {
    Widget content = Column(
      children: [
        ListTile(
          leading: Icon(Icons.app_shortcut),
          title: Text(AppLocalizations.of(context)!.about_a),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setActivePage(MorePages.app),
        ),
        ListTile(
          leading: Icon(Icons.source),
          title: Text(AppLocalizations.of(context)!.about_h),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setActivePage(MorePages.helios),
        ),
      ],
    );

    return Scaffold(
      appBar: createAppBar(context, AppLocalizations.of(context)!.more_info),
      body: content,
    );
  }

  Scaffold app() {
    Widget content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/ntnu_logo.png',
                  width: 250,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(AppLocalizations.of(context)!.about_project_blockp1),
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
        ],
      ),
    );
    return Scaffold(
      appBar: createAppBar(
        context,
        AppLocalizations.of(context)!.about_a,
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setActivePage(MorePages.landing),
        ),
      ),
      body: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (activePage) {
      case MorePages.app:
        return app();
      case MorePages.helios:
        return about();
      default:
        return landing();
    }
  }
}
