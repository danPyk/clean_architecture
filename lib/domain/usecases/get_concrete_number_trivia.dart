import 'package:clean_architecture/errors/failures.dart';
import 'package:clean_architecture/usecases/usecase.dart';
import 'package:clean_architecture/domain/entities/number_trivia.dart';
import 'package:clean_architecture/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);
//thanks to this we can call objecs like methods
  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return  repository.getConcreteNumberTrivia(params.number);

  }
}
//data holder class. Case for all of use cases. Hold all parameters for call method

class Params extends Equatable{
  final int number;

   const Params({required this.number});

  @override
  List<Object> get props => [number];
}