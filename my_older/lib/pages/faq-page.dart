import 'package:flutter/material.dart';
import 'package:myolder/constructs/faq-question.dart';
import 'package:myolder/widgets/faq/question.dart';
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
        _buildPageQuestions(context),
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
            child: FittedBox(
              child: Text(
                'Frequent asked questions',
                style: theme.textTheme.bodyText2,
              ),
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

  /// Builds the page questions
  Widget _buildPageQuestions(BuildContext context) {
    // Ask for loading
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return FutureBuilder<List<FaqQuestion>>(
      future: Questions.of(context).loadQuestions('questions.json'),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: media.size.width * 0.05,
              vertical: media.size.height * 0.02,
            ),
            child: Column(
              children: [
                ...snapshot.data.map((e) => Question(
                  title: e.title,
                  body: e.body,
                  imageUrl: e.imageUrl,
                  leadingIcon: Icons.question_answer,
                )).toList(),
              ],
            ),
          );
        } else if(snapshot.hasError) return _buildLoadingError(context);
        else return _buildLoadingProgress(context);
      },
    );
  }

  Widget _buildLoadingProgress(BuildContext context) {
    return CircularProgressIndicator(

    );
  }

  Widget _buildLoadingError(BuildContext context) {
    return const Text('Error during load');
  }
}
