import 'package:clean_architecture/domain/entities/number_trivia.dart';
import 'package:clean_architecture/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/errors/failures.dart';
import 'package:clean_architecture/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture/usecases/usecase.dart';
import 'package:clean_architecture/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

//todo ttps://bloclibrary.dev/#/testing
@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(getConcreteNumberTrivia : mockGetConcreteNumberTrivia,
        getRandomNumberTrivia : mockGetRandomNumberTrivia, inputConverter: mockInputConverter);
  });

  test(
    'initialState should be empty',
    () async {
      expect(bloc.initialSTate, equals(Empty()));
    },
  );
  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    //used because of class Loaded
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should call InputConverter to validate and convert string to unsigned int',
      () async {
        //arrange
        //todo why i'm returning concrete number while passing any?
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockInputConverter.stringToUnsignedInteger(tNumberString));
        //assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when input is invalid',
      () async {
        //arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        //assert
        //add do not return any value, so we need to take it from another place
        //todo
        //expectLater(bloc, emitsInOrder(Error(message: invalidInputMessage)))
        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from concrete use case',
      () async {
        //arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
           mockGetConcreteNumberTrivia(any));
        //assert
        //todo why Im using here Params
        verify(mockGetConcreteNumberTrivia(const Params( tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        //arrange
            when(mockInputConverter.stringToUnsignedInteger(any))
                .thenReturn(const Right(tNumberParsed));
            when(mockGetConcreteNumberTrivia(any))
                .thenAnswer((_) async => const Right(tNumberTrivia));
        //assert later
            final expected = [
              Empty(),
              Loading(),
              Loaded(trivia: tNumberTrivia)
            ];
        expectLater(bloc.state, emitsInOrder(expected));

        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test(
      'should emit [Loading, Error] with proper message for error, when data fetching fails',
          () async {
        //arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async =>  Left(CacheFailure()));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: cacheFailureMessage)
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberString = '1';
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from random use case',
          () async {
        //arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        //act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(
            mockGetRandomNumberTrivia(any));
        //assert
        //todo why Im using here Params
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        //arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia)
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        bloc.add(GetTriviaForRandomNumber());
      },
    );


    test(
      'should emit [Loading, Error] with proper message for error, when data fetching fails',
          () async {
        //arrange

        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async =>  Left(ServerFailure()));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: cacheFailureMessage)
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });
}
