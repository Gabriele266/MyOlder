/// Created by gabriele on 16/08/21
/// Project my_older
import 'dart:convert';

import 'package:flutter/material.dart';

import './faq-answer.dart';

/// Represents a question in the faq page
class FaqQuestion {
  /// The question title
  final String title;

  /// The question body
  final String body;

  /// The question id
  final int id;

  /// The question answer
  final FaqAnswer answer;

  /// The question image
  final String imageUrl;

  /// Creates a new [FaqQuestion]
  FaqQuestion({
    @required this.title,
    @required this.body,
    @required this.id,
    @required this.answer,
    @required this.imageUrl,
  });

  // TODO: Implement fromJsonString
  static FaqQuestion fromJsonString(String jsonString) {
    final questionDecoded = json.decode(jsonString);

    return FaqQuestion(
      title: questionDecoded['title'],
      body: questionDecoded['body'],
      id: questionDecoded['id'],
      imageUrl: questionDecoded['img'],
      answer: FaqAnswer.fromJsonString(json.encode(questionDecoded['answer'])),
    );
  }

  @override
  String toString() {
    return 'FaqQuestion. Title: $title. \nBody: $body. Id: $id';
  }
}
