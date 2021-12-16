
import 'package:clean_architecture/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/network/network_info.dart';
import 'package:clean_architecture/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture/util/input_converter.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//sl = serviceLocator
final sl = GetIt.instance;

Future<void> init() async {
  //features
  //serviceLocator call looking for are registered types/dependencies
  //why factory? because when you change page then stream are closed, but when you would want to get back to this page stream will be closed
  sl.registerFactory(() => NumberTriviaBloc(getConcreteNumberTrivia: sl(), getRandomNumberTrivia: sl(), inputConverter: sl()));

  //usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //repository
  //todo this is istantinate like this? because FE GetConcreteNumberTrivia do not depend directly on impl, but on contract (abstrac class)
  sl.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  //datasources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //external
  //because SharedPreferences return Future, we need to make it asynchronous
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}