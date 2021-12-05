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
  group('getLastNumber', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'getLastNumber should return NumberTriviaModel from SharedPreferences, when there is one in cache ',
      () async {
        //because we save SHaredPreferences as string
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));

        final result = await localDataSourceImpl.getLastNumberTrivia();

        verify(mockSharedPreferences.getString(cachedNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'getLastNumber should throw CacheException when there is not a cached value',
      () async {
        //empty SharedPreferences return null
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        final call = localDataSourceImpl.getLastNumberTrivia;

        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');

    var mock = MockCustomSharedPreferences();

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
