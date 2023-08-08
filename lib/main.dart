import 'package:flutter/material.dart';
import 'dart/degree/degree.dart';
import 'dart/form/degrees_list_screen.dart';
//import 'dart/degree/degree_storage.dart';                       //commented out bc apparently these files dont exist. 
//import 'package:shared_preferences/shared_preferences.dart';    //will leave here for now in case we need them later ig

void main() {
  runApp(const EduApp());
}

class EduApp extends StatelessWidget {
  const EduApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Degree Pathway App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 7, 143, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Degree Pathway App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _openDegreesListScreen(BuildContext context) {
    // Sample degree data
    List<Degree> degrees = [
      Degree("Bachelor's", "Computer Science", 2022),    
      Degree("Bachelor's", "Finance", 2022)
      // Add more degrees here
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DegreesListScreen(degrees: degrees),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openDegreesListScreen(
              context); // Call the function to open the new screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
