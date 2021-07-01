import 'package:flutter/material.dart';

import 'package:myolder/textual_widgets/textual_widgets.dart';

class ApplicationInformationsPage extends StatelessWidget {
  /// The route name
  static const String routeName = '/app-info';

  const ApplicationInformationsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'General informations',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(media.size.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Article(
                title: 'Keep your files safe',
                titleStyle: theme.textTheme.headline1,
                contentPadding: 10,
                contentAlignment: TextAlign.center,
                content:
                    'Protect all your secret files easily!! \nUsing myolder you can hide your secret files just by adding them to a safe zone. They won\'t be visible from the outside of the application, so no one will be able to see them except you!',
              ),
              Article(
                title: 'Encryption is security',
                titleStyle: theme.textTheme.headline1,
                contentPadding: 10,
                content:
                    'All the informations will be protected using AES encryption. \nWhen you add a file, like an image or a pdf or and audio, it will be encrypted with a secret password. Oly myolder will have that password. \nWhen you\'ll need to see the file contents, myolder will decrypt the file for you and it will show it to you!',
                contentAlignment: TextAlign.center,
              ),
              Article(
                title: 'No unsupported files',
                titleStyle: theme.textTheme.headline1,
                contentPadding: 10,
                content:
                    'All the files are supported. There aren\'t exceptions. You can add documents (Word, Pdf) or images (Jpg, Png, Gif, Jpeg), audios (mp3, wav), just as videos (mp4, mov) and more!!',
                contentAlignment: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(media.size.height * 0.04),
                child: TextButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
