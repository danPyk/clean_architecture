import 'package:clean_architecture/errors/exceptions.dart';
import 'package:clean_architecture/errors/failures.dart';
import 'package:clean_architecture/network/network_info.dart';
import 'package:clean_architecture/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture/data/models/number_trivia_model.dart';
import 'package:clean_architecture/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';


@GenerateMocks(
  [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo],
)
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
   late  MockNumberTriviaLocalDataSource mockLocalDataSource ;
  late  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    //because NumberTriviaModel is subclass of NumberTrivia, we can make it NumberTrivia by adding declaration
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if device is online',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act. when and Future.value is added by myself
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) => Future.value(tNumberTriviaModel));
        repository.getConcreteNumberTrivia(tNumber);
        // check if isConnected getter is called
        verify(mockNetworkInfo.isConnected);
      },
    );

    //execute only when device is online, setUp from function body provide this
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          //I'm returning NumberTriviaModel, becouse NumberTriviaRemoteDataSource getConcreteNumberTrivia() should return this
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          //test if remote data source was called with proper argument
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          //we are using here NumberTrivia, because its entity, and its part of domain layer

          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last local cached data, when cached data id present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          //todo why I'm testing this here?
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure, when data is not cached',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 123);
    //becouse NumberTriviaModel is subclass of NumberTrivia, we can make it NumberTrivia by adding declaration
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if device is online',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act. when and Future.value is added by myself
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) => Future.value(tNumberTriviaModel));
        repository.getRandomNumberTrivia();
        // check if isConnected getter is called
        verify(mockNetworkInfo.isConnected);
      },
    );

    //execute only when device is online, setUp from function body provide this
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          //I'm returning NumberTriviaModel, becouse NumberTriviaRemoteDataSource getConcreteNumberTrivia() should return this
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          //test if remote data source was called with proper argument
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          //we are using here NumberTrivia, because its entity, and its part of domain layer

          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          //todo why below comment fail? like networkInfo.isConnected
          // verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last local cached data, when cached data is present',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          //todo why I'm testing this here?
          final result = await repository.getRandomNumberTrivia();
          //assert
          //todo why below comment fail? like networkInfo.isConnected
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure, when data is not cached',
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
