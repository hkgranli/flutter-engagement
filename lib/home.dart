import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.grid});
  final Widget grid;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var inkWell = FittedBox(
        fit: BoxFit.fitHeight,
        child: Image.asset('assets/images/helios_logo_bg.png'));
    var helios = SafeArea(
      child: Image.asset(
        'assets/images/helios_logo_stroke.png',
      ),
    );
    return Scaffold(
        extendBodyBehindAppBar: true,
        //appBar: createAppBar(context, "", null, null, Colors.transparent, 0),
        body: CustomScrollView(slivers: [
          createSliverBar(context, true, false, false, helios, inkWell),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) => ConstrainedBox(
                    constraints: BoxConstraints(), child: widget.grid)),
          ),
        ])
        //bottomNavigationBar: EngagementNavBar(index: 0),
        );
  }

  AppBar infoBar(BuildContext context) {
    return createAppBar(
        context,
        AppLocalizations.of(context)!.p_info,
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ));
  }
}
