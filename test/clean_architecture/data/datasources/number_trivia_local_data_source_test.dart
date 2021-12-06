import 'dart:convert';

import 'package:clean_architecture/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture/data/models/number_trivia_model.dart';
import 'package:clean_architecture/errors/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImpl =
        LocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });


  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');

    test(
      'should call SharedPreferences to cache the data',
      () {
        // act
        // when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
        //todo why im getting this error?
        try {
          localDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
        } on MissingStubError {
          var logger = Logger();
          logger.e('Error! Something bad happened', 'Test Error');
        }
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(
          cachedNumberTrivia,
          expectedJsonString,
        ));
      },
    );
  });
}
