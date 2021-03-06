import 'dart:convert';

import 'package:clean_architecture/data/models/number_trivia_model.dart';
import 'package:clean_architecture/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia()  {
    final jsonString =   sharedPreferences.getString(cachedNumberTrivia);
    if (jsonString != null) {
      //convert to future
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString) as Map<String, dynamic>));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache)  {
     return sharedPreferences.setString(
      cachedNumberTrivia,
      json.encode(triviaToCache.toJson()),
    );
  }
}
