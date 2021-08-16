import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/questions.dart';

class FaqPage extends StatelessWidget {
  static const String routeName = '/faq';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return ChangeNotifierProvider.value(
      value: Questions(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Faq page',
            style: theme.appBarTheme.titleTextStyle,
          ),
        ),
        body: _FaqPageBody(),
      ),
    );
  }
}

class _FaqPageBody extends StatefulWidget {
  @override
  __FaqPageBodyState createState() => __FaqPageBodyState();
}

class __FaqPageBodyState extends State<_FaqPageBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        _buildPageHeading(context),
      ],
    );
  }

  Widget _buildPageHeading(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(media.size.width * 0.05),
          child: Center(
            child: Text(
              'Faq',
              style: theme.textTheme.bodyText2,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.05),
          child: Image(
            image: AssetImage('images/info.png'),
            width: media.size.width * 0.80,
            height: media.size.height * 0.30,
          ),
        ),
      ],
    );
  }

  void _loadPageQuestions(BuildContext context) {
    // Ask for loading
    final questions = Questions.of(context).loadQuestions('questions.json');
  }

  Widget _buildPageQuestions(BuildContext context) {

  }
}

