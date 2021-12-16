import 'package:clean_architecture/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(primaryColor: Colors.blueGrey,
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFF9000 )),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
