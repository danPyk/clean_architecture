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

  NumberTriviaState get initialSTate => Empty();

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
          final failureOrTrivia =
              await getConcreteNumberTrivia(const Params(1));
          //todo message
          failureOrTrivia.fold((l) =>  emit(Error(message: 'problem message'))
              , (r) =>  emit(Loaded(trivia:  r)));
        });

        if (inputEither.isLeft()) {
          emit(Error(message: "Invalid input"));
        } else {
          emit(Loading());
          final failureOrTrivia = await getConcreteNumberTrivia(const Params(
              1)); //continue with the process of fetching your data here
          if (failureOrTrivia.isRight()) {
            //todo
            emit(Loaded(trivia: const NumberTrivia(text: 'txt', number: 1)));
          } else {
            //should emit Loaded
            //todo shuould return different errors
            emit(Error(message: serverFailureMessage));
          }
        }
      },
    );
    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTrivia(
          NoParams()); //continue with the process of fetching your data here
      if (failureOrTrivia.isRight()) {
        emit(Loaded(trivia: const NumberTrivia(text: 'txt', number: 1)));
      } else {
        //should emit Loaded
        //todo shuould return different errors
        emit(Error(message: serverFailureMessage));
      }
    });
  }
}
