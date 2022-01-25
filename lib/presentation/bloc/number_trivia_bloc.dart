import 'package:clean_architecture/domain/entities/number_trivia.dart';
import 'package:clean_architecture/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/errors/failures.dart';
import 'package:clean_architecture/usecases/usecase.dart';
import 'package:clean_architecture/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server failure';
const String cacheFailureMessage = 'Cache failure';
const String invalidInputMessage =
    'Invalid input, the number should be positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

       inputEither.fold((failure) => emit(Error(message: invalidInputMessage)),
          (integer) async {
        emit(Loading());
        final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));


        _eitherLoadedOrErrorState(failureOrTrivia);
      });
    });

    on<GetTriviaForRandomNumber>(
      (event, emit) async {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());

        _eitherLoadedOrErrorState(failureOrTrivia);
      },
    );
  }
  void _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia,
      )  {
    emit(failureOrTrivia.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (trivia) => Loaded(trivia: trivia),
    ),);
  }


  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
