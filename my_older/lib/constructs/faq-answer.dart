/// Created by gabriele on 16/08/21
/// Project my_older
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myolder/constructs/faq-question.dart';

/// Represents an answer in the faq page
class FaqAnswer {
  /// The answer title
  final String title;

  /// The answer details
  final String body;

  /// The answer id
  final int id;

  /// The question this answer answers to
  FaqQuestion question;

  /// Creates a new [FaqAnswer]
  FaqAnswer({
    @required this.title,
    @required this.body,
    @required this.id,
  });

  /// Reads an answer from a json string
  static FaqAnswer fromJsonString(String jsonString) {
    final answerDecoded = (json.decode(jsonString) as List).single;

    return FaqAnswer(
      title: answerDecoded['title'],
      body: answerDecoded['body'],
      id: answerDecoded['id'],
    );
  }
}
