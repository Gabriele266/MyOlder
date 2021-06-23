import 'package:flutter/material.dart';
import 'package:myolder/textual_widgets/textual_widgets.dart';

import '../constructs/safe-file.dart';

class SafeFileInfoPage extends StatefulWidget {
  final SafeFile file;

  /// Creates a new instance of the class SafeFileInfoPage, that shows the informations <br>
  /// about a SafeFile.
  ///
  /// [file] The file to show informations on
  SafeFileInfoPage({
    Key key,
    @required this.file,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SafeFileInfoPageState();
}

// TODO: Make this page responsive and adaptive
// TODO: Add use of theme
class _SafeFileInfoPageState extends State<SafeFileInfoPage> {
  // TextEditingController
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add an empty listener
    controller.addListener(() {});
  }

  /// TODO: Implement function to show files by tag in main view
  /// TODO: Implement this page
  @override
  Widget build(BuildContext context) {
    // String description;
    // if (widget.file.description != null)
    //   description = widget.file.description;
    // else
    //   description = "";

    // if (widget.file != null) {
    //   return Scaffold(
    //     backgroundColor: Theme.of(context).backgroundColor,
    //     appBar: AppBar(
    //       title: Text('File details',
    //           style: Theme.of(context).textTheme.headline1),
    //     ),
    //     body: Center(
    //       child: Stack(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(10),
    //             child: Image(
    //               image: AssetImage('images/magnify.png'),
    //             ),
    //           ),
    //           ListView(
    //             padding: const EdgeInsets.only(
    //               top: 40,
    //               bottom: 20,
    //               left: 30,
    //               right: 30,
    //             ),
    //             children: [
    //               Article(
    //                 title: 'Details',
    //                 titleStyle: TextStyle(
    //                   color: Theme.of(context).accentColor,
    //                   fontSize: 20,
    //                   fontWeight: FontWeight.bold,
    //                   shadows: [
    //                     Shadow(
    //                       color: Colors.black,
    //                       blurRadius: 2,
    //                     ),
    //                   ],
    //                 ),
    //                 content: Column(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.only(
    //                         top: 30,
    //                         bottom: 30,
    //                       ),
    //                       child: Column(
    //                         children: [
    //                           InfoPropertyLine(
    //                             name: 'Name',
    //                             value: widget.file.name,
    //                           ),
    //                           InfoPropertyLine(
    //                             name: 'Path',
    //                             value: widget.file.path,
    //                           ),
    //                           InfoPropertyLineAction(
    //                             name: 'Info',
    //                             value: description,
    //                             actionIcon: Icon(
    //                               Icons.edit,
    //                               size: Theme.of(context).iconTheme.size,
    //                             ),
    //                             overlayWidget: TextField(
    //                               maxLines: 4,
    //                               controller: controller,
    //                               decoration: InputDecoration(
    //                                 border: const OutlineInputBorder(
    //                                   borderRadius: const BorderRadius.all(
    //                                     const Radius.circular(10),
    //                                   ),
    //                                   borderSide: const BorderSide(
    //                                     color: Colors.black,
    //                                     width: 2,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             overlayIcon: Icon(
    //                               Icons.check,
    //                               size: Theme.of(context).iconTheme.size,
    //                               color: Theme.of(context).iconTheme.color,
    //                             ),
    //                             onOverlayPerformed: (name, value) {
    //                               // Give informations about the accepted text
    //                               print('Overlay accepted: ${controller.text}');
    //                               // Set it as new
    //                               setState(
    //                                 () => widget.file.description =
    //                                     controller.text,
    //                               );
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               MetalPanelContainer(
    //                 child: Column(
    //                   children: [
    //                     InfoPropertyLine(
    //                       name: 'Date',
    //                       value: DateFormat.yMd().format(widget.file.dateTime),
    //                     ),
    //                     InfoPropertyLine(
    //                       name: 'Time',
    //                       value: DateFormat.Hm().format(widget.file.dateTime),
    //                     ),
    //                     InfoPropertyLine(
    //                       name: 'Suffix',
    //                       value: widget.file.suffix,
    //                     ),
    //                   ],
    //                 ),
    //                 margin: EdgeInsets.only(top: 30),
    //               ),
    //               MetalPanelContainer(
    //                 title: Text(
    //                   'Tags',
    //                   style: TextStyle(
    //                     color: Theme.of(context).accentColor,
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.bold,
    //                     shadows: [
    //                       Shadow(
    //                         color: Colors.black,
    //                         blurRadius: 2,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 child: Column(
    //                   children: (widget.file.tags.isNotEmpty)
    //                       ? widget.file.tags.map((tag) {
    //                           return TagWidget(
    //                             tag: tag,
    //                             showByTag: null,
    //                           );
    //                         }).toList()
    //                       : [
    //                           InfoPropertyLine(
    //                             name: 'Tags',
    //                             value: 'No tags provided. Add one!',
    //                           ),
    //                         ],
    //                 ),
    //                 margin: const EdgeInsets.only(top: 40),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    }
    // Throw exception
}

/// Represents an exception thrown when a null file is passed to this widget
class NullFileException implements Exception {
  String _text;

  NullFileException(this._text);

  @override
  String toString() =>
      'NullFileException: A null file was passed to a SafeFileInfoPage. $_text';
}
