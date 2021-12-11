import 'package:flutter/material.dart';

void main() {
  runApp(FurgoApp());
}

class FurgoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FurGO',
      theme: ThemeData(
         scaffoldBackgroundColor: const Color(0xff5472d3),
      ),
      home: LicensePlatePage(),
    );
  }
}

class LicensePlatePage extends StatefulWidget {
  LicensePlatePage({Key? key}) : super(key: key);

  @override
  _LicensePlatePageState createState() => _LicensePlatePageState();
}

class _LicensePlatePageState extends State<LicensePlatePage> {
  @override
  final _formKey = GlobalKey<FormState>();
  bool isEnabled = false;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: const BoxDecoration(color: Color(0xff5472d3)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    'Matrícula de tu coche',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Sin espacios',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 300.0,
                  height: 100.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 3)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25.0,
                          height: 100.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xff030EC3),
                              border: Border.all(color: Colors.black, width: 3)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "E",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          )
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (value) {
                                  RegExp regExpNumbers = RegExp("[0-9]");
                                  RegExp regExpLetters = RegExp("[a-zA-Z]");
                                  if (value == null || value.isEmpty || value
                                      .length != 8 || regExpLetters
                                      .allMatches(value)
                                      .length != 3 || regExpNumbers
                                      .allMatches(value)
                                      .length != 5) {
                                    setState(() {
                                      isEnabled = false;
                                    });
                                  } else {
                                    setState(() {
                                      isEnabled = true;
                                    });
                                  }
                                },
                                validator: (value) {
                                  RegExp regExpNumbers = RegExp("[0-9]");
                                  RegExp regExpLetters = RegExp("[a-zA-Z]");
                                  if (value == null || value.isEmpty || value.length != 8 || regExpLetters.allMatches(value).length != 3 || regExpNumbers.allMatches(value).length != 5) {
                                    return "Formato incorrecto";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          )
                        )
                      ]
                    )
                  )
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xff002071)),
                  ),
                  onPressed: isEnabled ? () {
                    // Validate returns true if the form is valid, or false otherwise.
                    print("Entered here");
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  } : null,
                  child: const Text('Submit'),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}