import 'package:bloc/bloc.dart';
import 'package:clean_architecture/domain/entities/number_trivia.dart';
import 'package:clean_architecture/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/usecases/usecase.dart';
import 'package:clean_architecture/util/input_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server failure';
const String cacheFailureMessage = 'Cache failure';
const String invalidInputMessage =
    'Invalid input, te number should be positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {

    on<GetTriviaForConcreteNumber>(
      (event, emit) async {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        inputEither.fold((l) => emit(Error(message: "Invalid input")),
            (r) async {
          emit(Loading());
          final failureOrTrivia = await getConcreteNumberTrivia(Params(r));
          //todo message
          failureOrTrivia.fold((l) => emit(Error(message: 'problem message')),
              (r) => emit(Loaded(trivia: r)));
        });
      },
    );

    on<GetTriviaForRandomNumber>(
      (event, emit) async {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());

        failureOrTrivia.fold((l) => emit(Error(message: "Invalid input")),
            (r) async {
          emit(Loading());
          final failureOrTrivia =
              await getConcreteNumberTrivia(const Params(1));
          //todo message
          failureOrTrivia.fold(
              (l) => emit(Error(message: 'problem message')),
              (r) => emit(
                  Loaded(trivia: const NumberTrivia(text: 'txt', number: 1))));
        });
      },
    );
  }
}
