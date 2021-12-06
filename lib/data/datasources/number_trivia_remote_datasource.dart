import 'package:clean_architecture/data/models/number_trivia_model.dart';
import 'package:clean_architecture/errors/exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource{

  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {

   final response = await client.get(Uri.parse('http://numbersapi.com/$number'), headers: {
      'Content-Type': 'application/json',
    });
   if (response.statusCode == 200) {
     return NumberTriviaModel.fromJson(json.decode(response.body));
   } else {
     throw ServerException();
   }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await client.get(Uri.parse('http://numbersapi.com/random'), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

}