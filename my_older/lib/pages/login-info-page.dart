import 'package:flutter/material.dart';

// TODO: Use better pattern for this page
// TODO: Optimize Theme and Media with final variables
// TODO: Make this page responsive and adaptive
class LoginInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Login informations',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20),
                  child: Text('Credentials needed',
                      style: Theme.of(context).textTheme.headline1)),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'To access the safe zone you need to insert your credentials. The manager should give you a UserName and a Password to use this application. ',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'The only way to access data is using this',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'If you have lost them, you won\'t be able to access all your data!!!! Pay attention!!!',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'Additional informations',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'The user name couldn\'t contain spaces or special characters. The password should be longer than 5 characters.',
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
