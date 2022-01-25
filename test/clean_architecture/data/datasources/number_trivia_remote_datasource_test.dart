import 'dart:convert';

import 'package:clean_architecture/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture/data/models/number_trivia_model.dart';
import 'package:clean_architecture/errors/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
main() {
  late MockClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(){
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
     final tNumberTriviaModel =  NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')) as Map<String, dynamic>);
    test(
      'should perfrom GET request on URL with number being the endpoint and with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockHttpClient
            .get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {
          'Content-Type': 'application/json',
        }));
      },
    );

    test(
      'should return NumberTrivia, when response is 200',
      () async {
        setUpMockHttpClientSuccess200();

        //act
        final result = await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);

        //assert
        //response should be the same as in fixture
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should return ServerException, when response is other than 200',
          () async {
        //arrange
            when(mockHttpClient.get(any, headers: anyNamed('headers')))
                .thenAnswer((_) async => http.Response('Something went wrong', 404));
        //act
        final call = remoteDataSourceImpl.getConcreteNumberTrivia;
        expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomTrivia', () {
    final tNumberTriviaModel =  NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')) as Map<String, dynamic>);
    test(
      'should perfrom GET request on URL with number being the endpoint and with application/json header',
          () async {
        //arrange
        setUpMockHttpClientSuccess200();
        //act
        remoteDataSourceImpl.getRandomNumberTrivia();
        //assert
        verify(mockHttpClient
            .get(Uri.parse('http://numbersapi.com/random'), headers: {
          'Content-Type': 'application/json',
        }));
      },
    );

    test(
      'should return NumberTrivia, when response is 200',
          () async {
        setUpMockHttpClientSuccess200();

        //act
        final result = await remoteDataSourceImpl.getRandomNumberTrivia();

        //assert
        //response should be the same as in fixture
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should return ServerException, when response is other than 200',
          () async {
        //arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Something went wrong', 404));
        //act
        final call = remoteDataSourceImpl.getRandomNumberTrivia;
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
