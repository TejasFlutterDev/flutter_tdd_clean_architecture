import 'dart:convert';

import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test('should be a subclass of NumberTrivia entity', () async {
    // arrange

    // act
    expect(tNumberTriviaModel, isA<NumberTrivia>());
    // assert
  });

  group("fromJson", () {
    test('should return valid model when json number is an integer', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture("trivia.json"));
      // act

      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should return valid model when json number is regarded as double',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture("trivia_double.json"));
      // act

      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group("toJson", () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      final expectedMap = {"text": "Test Text", "number": 1};
      expect(result, expectedMap);
    });
  });
}
