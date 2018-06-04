import 'package:flutter/material.dart';
import 'package:flutter_24_lista_tarefas/ui/tela_tarefas.dart';

class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tarefas"),
        backgroundColor: Colors.black54,
      ),
      body: new TelaTarefas(),
    );
  }
}
