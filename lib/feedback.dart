import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_survey/flutter_survey.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with TickerProviderStateMixin {
  int tabIndex = 0;
  final _formKey = GlobalKey<FormState>();
  List<QuestionResult> _questionResults = [];

  final List<Question> _initialData = [
    Question(
        question: "Owner or tenant?",
        answerChoices: {"Owner": null, "Tenant": null}),
    Question(question: "What is your age?"),
    Question(
        question:
            "Have you ever considered installing solar panels on your home or property",
        answerChoices: {
          "Yes, I have already installed solar panels": null,
          "Yes, I have considered it but haven't done so yet": null,
          "No, I haven't considered it": null
        }),
    Question(
        question:
            "What factors have influenced your decision to install or not install solar panels?",
        answerChoices: {
          "Cost of installation": null,
          "Government incentives and rebates": null,
          "Concerns about maintenance and repair": null,
          "Aesthetics of solar panels": null,
          "Other reasons (please specify)": []
        }),
    Question(
        question: "How familiar are you with solar energy and its benefits?",
        answerChoices: {
          "Very familiar": null,
          "Somewhat familiar": null,
          "Not very familiar": null,
          "Not at all familiar": null
        }),
    Question(
        question:
            "What concerns do you have about installing solar panels on your home or property?",
        answerChoices: {
          "Cost of installation": null,
          "Reliability of the technology": null,
          "Aesthetics of solar panels": null,
          "Impact on property values": null,
          "Other concerns (please specify)": null,
        }),
    Question(
        question:
            "Do you believe that solar energy can help reduce your household's carbon footprint and contribute to a more sustainable future?",
        answerChoices: {
          "Yes, strongly agree": null,
          "Yes, somewhat agree": null,
          "No, somewhat disagree": null,
          "No, strongly disagree": null,
        }),
    Question(
        question:
            "What incentives or support would make you more likely to install solar panels on your home or property?",
        answerChoices: {
          "Tax credits or other financial incentives": null,
          "Low-interest financing": null,
          "Rebates from the utility company": null,
          "Assistance with installation and maintenance": null,
          "Other incentives or support (please specify)": null,
        }),
    Question(
        question:
            "How important is it for you to live in a sustainable community?",
        answerChoices: {
          "Very important": null,
          "Somewhat important": null,
          "Not very important": null,
          "Not at all important": null,
        }),
    Question(
        question:
            "What concerns do you have about the aesthetic impact of solar panels on historic homes or buildings?",
        answerChoices: {
          "None, I think solar panels can look great on any building": null,
          "Some, but I think the benefits of solar energy outweigh the aesthetic concerns":
              null,
          "Significant, I think solar panels can detract from the historic character of a building":
              null,
        }),
    Question(
        question:
            "Would you be interested in learning more about solar energy and how it can benefit your household and the community?",
        answerChoices: {
          "Yes, very interested": null,
          "Yes, somewhat interested": null,
          "No, not very interested": null,
          "No, not at all interested": null,
        }),
    Question(
        question:
            "What suggestions do you have for increasing awareness and social acceptance of solar energy in the neighborhood?",
        answerChoices: {
          "More outreach and education about the benefits of solar energy":
              null,
          "Incentives and rebates to encourage solar panel installations": null,
          "Community events or workshops about solar energy": null,
          "Other suggestions (please specify)": null,
        }),
    Question(question: "Any feedback about the app?", answerChoices: {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: feedbackBar(),
      body: tabIndex == 0 ? survey() : responses(),
      /*bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).highlightColor
                ),
                child: const Text("Submit"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //do something
                  }
                },
              ),
            ),
          ),
          EngagementNavBar(index: 2),
        ],
      ),*/
    );
  }

  AppBar feedbackBar() {
    final TabController tabController =
        TabController(length: 2, initialIndex: tabIndex, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          tabIndex = tabController.index;
        });
      }
    });

    return createAppBar(
        context,
        AppLocalizations.of(context)!.feedback,
        null,
        TabBar(
          tabs: [
            Tab(
                icon: Icon(Icons.campaign),
                text: AppLocalizations.of(context)!.survey),
            Tab(
                icon: Icon(Icons.summarize),
                text: AppLocalizations.of(context)!.responses),
          ],
          controller: tabController,
        ));
  }

  Widget responses() => Container();

  Widget survey() => Form(
        key: _formKey,
        child: Survey(
            onNext: (questionResults) {
              _questionResults = questionResults;
            },
            initialData: _initialData),
      );

  Widget evalButton(BuildContext context) => ElevatedButton(
      onPressed: () => launchUrl(
          Uri.parse('https://forms.office.com/e/wjguScpCCa'),
          mode: LaunchMode.inAppWebView),
      child: Text(AppLocalizations.of(context)!.feedb));
}
