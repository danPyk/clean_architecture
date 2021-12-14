part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {

   const NumberTriviaEvent([List props = const <dynamic>[]]) ;

  @override
  List<Object> get props => [];
}
class GetTriviaForConcreteNumber extends NumberTriviaEvent {
   final String numberString;

   GetTriviaForConcreteNumber(this.numberString) : super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
