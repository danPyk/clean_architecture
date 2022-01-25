import 'package:clean_architecture/domain/entities/number_trivia.dart';
import 'package:clean_architecture/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/errors/failures.dart';
import 'package:clean_architecture/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture/usecases/usecase.dart';
import 'package:clean_architecture/util/Foo.dart';
import 'package:clean_architecture/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'foo.mocks.dart';


//todo ttps://bloclibrary.dev/#/testing
@GenerateMocks([Foo])
void main() {
  late MockFoo mockFoo;


  setUp(() {
    mockFoo = MockFoo();
  });

  test(
    'initialState should be empty',
        () async {
    },
  );
}
