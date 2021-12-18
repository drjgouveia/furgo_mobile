import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:furgo/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: InfoInputPage(),
    );
  }
}

class InfoInputPage extends StatefulWidget {
  InfoInputPage({Key? key}) : super(key: key);

  @override
  _InfoInputPageState createState() => _InfoInputPageState();
}

class _InfoInputPageState extends State<InfoInputPage> {
  @override
  final _formKey = GlobalKey<FormState>();
  String kms = "";
  String comb = "";
  String plate = "";

  Future<String> getPlate() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
    plate = prefs.getString("plate") ?? "";
    return plate;
  }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getPlate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            plate = snapshot.data!;
            return Scaffold(
              body: Form(
                key: _formKey,
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xff5472d3)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            "Matricula",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff0d46a0),
                            )
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              plate,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                              )
                            ),
                            IconButton(
                                disabledColor: const Color(0xff135cc7),
                                color: Colors.white,
                                onPressed: () async {
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
                                            return LicensePlatePage();
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
                                },
                                icon: const Icon(Icons.refresh)
                            )
                          ]
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          margin: const EdgeInsets.all(12),
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: TextFormField(
                                decoration: const InputDecoration.collapsed(
                                    hintText: 'KMs del coche',
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintStyle: TextStyle(fontSize: 20)
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  kms = value!;
                                }
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          margin: const EdgeInsets.all(12),
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: TextFormField(
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Cuantidad de combustible',
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintStyle: TextStyle(fontSize: 20),
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  comb = value!;
                                }
                            ),
                          ),
                        ),
                        IconButton(
                            disabledColor: const Color(0xff0d46a0),
                            color: Colors.white,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Enviando los datos')),
                                );
                                _formKey.currentState!.save();
                                if (plate != "" && kms != "" && comb != "") {
                                  var dio = Dio();
                                  dio.options.baseUrl =
                                  'http://furgo.drjgouveia.dev/';
                                  dio.options.connectTimeout = 5000;
                                  dio.options.receiveTimeout = 3000;
                                  try {
                                    var response = await dio.post(
                                      'api/',
                                      data: FormData.fromMap({
                                        'plate': plate,
                                        'kms': kms,
                                        "comb": comb
                                      }),
                                    );

                                    if (response.statusCode == 200) {
                                      await Alert(
                                          context: context,
                                          title: "Alerta",
                                          desc: "Datos enviados con éxito!",
                                          buttons: [
                                            DialogButton(
                                              child: const Text(
                                                "Ok",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              width: 120,
                                            )
                                          ]
                                      ).show();
                                    } else {
                                      await Alert(
                                          context: context,
                                          title: "Alerta",
                                          desc: "Datos enviados sin éxito!",
                                          buttons: [
                                            DialogButton(
                                              color: const Color(0xff5472d3),
                                              child: const Text(
                                                "Ok",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              width: 120,
                                            )
                                          ]
                                      ).show();
                                    }
                                  } catch(e) {
                                    await Alert(
                                        context: context,
                                        title: "Alerta",
                                        desc: "Datos enviados sin éxito! Comprobar la conexión a internet.",
                                        buttons: [
                                          DialogButton(
                                            color: const Color(0xff5472d3),
                                            child: const Text(
                                              "Ok",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            width: 120,
                                          )
                                        ]
                                    ).show();
                                  }
                                }
                              } else {
                                await Alert(
                                    context: context,
                                    title: "Alerta",
                                    desc: "Datos mal formateados!",
                                    buttons: [
                                      DialogButton(
                                        child: const Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        width: 120,
                                      )
                                    ]
                                ).show();
                              }
                            },
                            icon: const Icon(Icons.check)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}