// Mocks generated by Mockito 5.0.16 from annotations
// in clean_architecture/test/clean_architecture/util/foo.dart.
// Do not manually edit this file.

import 'package:clean_architecture/util/Foo.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeFoo_0 extends _i1.Fake implements _i2.Foo {}

/// A class which mocks [Foo].
///
/// See the documentation for Mockito's code generation for more information.
class MockFoo extends _i1.Mock implements _i2.Foo {
  MockFoo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get name =>
      (super.noSuchMethod(Invocation.getter(#name), returnValue: '') as String);
  @override
  _i2.Foo calculate(String? name) =>
      (super.noSuchMethod(Invocation.method(#calculate, [name]),
          returnValue: _FakeFoo_0()) as _i2.Foo);
  @override
  String toString() => super.toString();
}
