class Foo {
  final String name;

  Foo._(this.name);

  factory Foo.instance(String name){
    return Foo._(name);
  }

  Foo calculate(String name) {
    return  Foo.instance(name);
  }
}