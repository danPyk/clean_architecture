import 'package:clean_architecture/errors/failures.dart';
import 'package:dartz/dartz.dart';

import 'failure.dart';

class InputConverter{
  Either<Failure, int> stringToUnsignedInteger(String string){
    try {
      return Right(int.parse(string));
    }
   on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure{

}