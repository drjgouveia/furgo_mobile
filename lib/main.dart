import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'info.dart';

void main() {
  runApp(FurgoApp());
}

class FurgoApp extends StatelessWidget {
  Future<bool> loadPlate() async {
    final prefs = await SharedPreferences.getInstance();
    String s = prefs.getString("plate") ?? "";
    if (s == "") {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FurGO',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff5472d3),
        accentColor: const Color(0xff5472d3),
      ),
      home: FutureBuilder<bool>(
        future: loadPlate(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data == true) {
              return InfoInputPage();
            } else {
              return LicensePlatePage();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
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
                                          textCapitalization: TextCapitalization.characters,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            // decorating and styling your Text
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          onSaved: (value) async {
                                            final prefs = await SharedPreferences.getInstance();
                                            prefs.setString("plate", value ?? "");
                                          },
                                          onChanged: (value) {
                                            RegExp regExpNumbers = RegExp("[0-9]");
                                            RegExp regExpLetters = RegExp("[a-zA-Z]");
                                            if (value == null || value.isEmpty || value
                                                .length != 7 || regExpLetters
                                                .allMatches(value)
                                                .length != 3 || regExpNumbers
                                                .allMatches(value)
                                                .length != 4) {
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
                                            if (value == null || value.isEmpty || value.length != 7 || regExpLetters.allMatches(value).length != 3 || regExpNumbers.allMatches(value).length != 4) {
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
                  IconButton(
                      disabledColor: const Color(0xff0d46a0),
                      color: Colors.white,
                      onPressed: isEnabled ? () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Guardando los datos')),
                          );
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Datos guardados')),
                          );
                        }
                        Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                                opaque: true,
                                transitionDuration: const Duration(seconds: 2),
                                pageBuilder: (BuildContext context, _, __) {
                                  return InfoInputPage();
                                },
                                transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                  return SlideTransition(
                                    child: child,
                                    position: Tween<Offset>(
                                      begin: const Offset(10.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                  );
                                }
                            )
                        );
                      } : null,
                      icon: const Icon(Icons.check)
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}