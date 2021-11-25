import 'package:clean_architecture/core/errors/exceptions.dart';
import 'package:clean_architecture/core/errors/failures.dart';
import 'package:clean_architecture/core/platform/network_info.dart';
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
  final mockNumberTriviaRemoteDatasource = MockNumberTriviaRemoteDataSource();
  final mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
  final mockNetworkInfo = MockNetworkInfo();

  setUp(() => repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockNumberTriviaRemoteDatasource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo));

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
    //becouse NumberTriviaModel is subclass of NumberTrivia, we can make it NumberTrivia by adding declaration
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if device is online',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act. when and Future.value is added by myself
        when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber))
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
          when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          //test if remote data source was called with proper argument
          verify(mockNumberTriviaRemoteDatasource
              .getConcreteNumberTrivia(tNumber));
          //we are using here NumberTrivia, because its entity, and its part of domain layer

          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNumberTriviaRemoteDatasource
              .getConcreteNumberTrivia(tNumber));
          verify(mockNumberTriviaLocalDataSource
              .cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNumberTriviaRemoteDatasource
              .getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockNumberTriviaLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('when device is offline', () {
      //execute only when device is online
      runTestsOffline(() {
        test(
          'should return last local cached data, when cached data id present',
          () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            //act
            //todo why I'm testing this here?
            final result = await repository.getConcreteNumberTrivia(tNumber);
            //assert
            verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          'should return CacheFailure, when data is not cached',
          () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            //act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            //assert
            verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
            verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
      });
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
        when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
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
          when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          //test if remote data source was called with proper argument
          verify(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia());
          //we are using here NumberTrivia, because its entity, and its part of domain layer

          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia());
          verify(mockNumberTriviaLocalDataSource
              .cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(
              mockNumberTriviaRemoteDatasource.getRandomNumberTrivia());
          //todo why below comment fail? like networkInfo.isConnected
          // verifyZeroInteractions(mockNumberTriviaLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last local cached data, when cached data is present',
            () async {
          //arrange
          when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          //todo why I'm testing this here?
          final result = await repository.getRandomNumberTrivia();
          //assert
          //todo why below comment fail? like networkInfo.isConnected
          //verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
          verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure, when data is not cached',
            () async {
          //arrange
          when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          //todo why below comment fail? like networkInfo.isConnected
          //verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
          verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
