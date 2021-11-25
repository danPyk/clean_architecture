// Mocks generated by Mockito 5.0.16 from annotations
// in clean_architecture/test/clean_architecture/domain/usecases/get_random_number_trivia_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:clean_architecture/core/errors/failures.dart' as _i5;
import 'package:clean_architecture/core/usecases/usecase.dart' as _i7;
import 'package:clean_architecture/domain/entities/number_trivia.dart' as _i6;
import 'package:clean_architecture/domain/usecases/get_random_number_trivia.dart'
    as _i3;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [GetRandomNumberTrivia].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetRandomNumberTrivia extends _i1.Mock
    implements _i3.GetRandomNumberTrivia {
  MockGetRandomNumberTrivia() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.NumberTrivia>> call(
          _i7.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
          returnValue: Future<_i2.Either<_i5.Failure, _i6.NumberTrivia>>.value(
              _FakeEither_0<_i5.Failure, _i6.NumberTrivia>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i6.NumberTrivia>>);
  @override
  String toString() => super.toString();
}
