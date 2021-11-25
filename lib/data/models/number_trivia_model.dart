import 'package:clean_architecture/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia{
   const NumberTriviaModel({required String text, required int number}) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      // The 'num' type can be both a 'double' and an 'int', so we cast
      number: json['number'].toInt(),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'text' : text,
      'number' : number,
    };
  }

}