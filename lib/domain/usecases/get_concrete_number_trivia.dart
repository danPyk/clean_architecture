
import 'package:clean_architecture/core/errors/failures.dart';
import 'package:clean_architecture/domain/entities/number_trivia.dart';
import 'package:clean_architecture/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> call({
    required int number,
  }) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}