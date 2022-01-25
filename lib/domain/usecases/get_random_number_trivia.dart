import 'package:clean_architecture/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/errors/failures.dart';
import 'package:clean_architecture/usecases/usecase.dart';
import 'package:clean_architecture/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository ;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(params) async {
    return await repository.getRandomNumberTrivia();
  }

}
