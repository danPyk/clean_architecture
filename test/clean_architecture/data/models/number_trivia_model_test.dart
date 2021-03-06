import 'dart:convert';

import 'package:clean_architecture/data/models/number_trivia_model.dart';
import 'package:clean_architecture/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  var tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test('should be subclass of number_trivia entity', () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json')) as Map<String, dynamic>;
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });
  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json')) as Map<String, dynamic>;
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test('sould return valid JSON map with proper data', () async {
      final result = tNumberTriviaModel.toJson();
      //assert
      final expectedJsonMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
