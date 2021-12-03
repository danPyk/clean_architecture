import 'dart:convert';

import 'package:clean_architecture/errors/exceptions.dart';
import 'package:clean_architecture/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


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
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'getLastNumber should return NumberTriviaModel from SharedPreferences, when there is one in cache ',
      () async {
        //because we save SHaredPreferences as string
        when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));

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

        final result = await localDataSourceImpl.getLastNumberTrivia();

        expect(result, throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =  NumberTriviaModel(text: 'test trivia', number: 1);

    test(
      'cacheNumberTrivia should call SharedPreferences to cache data ',
          () async {
          //atc
            await localDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
            //assert
            //check if mock is called with proper json representation of tNumberTriviaModel
            final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
            verify(when(mockSharedPreferences.setString(cachedNumberTrivia, expectedJsonString)).thenReturn(Future.value(true)));

      },
    );

  });


}
