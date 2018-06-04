import 'package:flutter/material.dart';
import 'package:flutter_24_lista_tarefas/ui/inicio.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tarefas',
      home: new Inicio(),
    );
  }
}
