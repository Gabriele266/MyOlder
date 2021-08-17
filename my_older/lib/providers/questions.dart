/// Created by gabriele on 16/08/21
/// Project my_older
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myolder/exceptions/exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../constructs/faq-answer.dart';
import '../constructs/faq-question.dart';

class Questions with ChangeNotifier {
  static Questions of(BuildContext context, {bool listen = false}) =>
      Provider.of<Questions>(context, listen: listen);

  List<FaqQuestion> _questions;

  List<FaqQuestion> get questions => [..._questions];

  FaqQuestion getQuestionByIndex(int index) => _questions[index];

  FaqQuestion getQuestionById(int id) => _questions.firstWhere((element) => element.id == id);

  Questions() {
    loadQuestions('questions.json');
  }

  /// Loads the questions from a specific file path
  ///
  /// [file] The file path starting from the app documents.
  Future<List<FaqQuestion>> loadQuestions(String file) async {
    // Check exceptions
    if (file.isEmpty)
      throw NullFileException('The file given to loadQuestions is empty');

    // Read the file
    final readFile = File('${(await getApplicationDocumentsDirectory()).path}/$file');

    readFile.openRead();

    final result = json.decode(await readFile.readAsString());

    final questions = result['questions'] as List;

    List<FaqQuestion> temp = [];

    // Load every question into the list
    questions.forEach((element) {
      // Read current question and add it to list
      final qs = FaqQuestion.fromJsonString(json.encode(element));
      temp.add(qs);
    });

    return temp;
  }
}
