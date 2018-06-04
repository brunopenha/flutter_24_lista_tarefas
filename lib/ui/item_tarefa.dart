import 'package:flutter/material.dart';

class ItemTarefa extends StatelessWidget {

  String _nome;
  String _dataCriacao;
  int _id;

  ItemTarefa(this._nome, this._dataCriacao);

  ItemTarefa.map(dynamic obj){
    this._nome = obj['nome'];
    this._dataCriacao = obj['dataCriacao'];
    this._id = obj['id'];
  }

  // Getters
  String get nome => _nome;
  String get dataCriada => _dataCriacao;
  int get id => _id;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['nome'] = _nome;
    map['dataCriacao'] = _dataCriacao;

    if(id != null){
      map['id'] = _id;
    }

    return map;

  }

  ItemTarefa.fromMap(Map<String, dynamic> map){
    this._nome = map["nome"];
    this._dataCriacao = map["dataCriacao"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                _nome,
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.9
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(
                  "Criado em $_dataCriacao",
                  style: new TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                      fontStyle: FontStyle.italic
                  ),
                ),
              )
            ],
          ),


        ],
      ),
    );
  }
}
