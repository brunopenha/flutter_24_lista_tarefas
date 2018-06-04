
import 'dart:async';
import 'dart:io';

import 'package:flutter_24_lista_tarefas/ui/item_tarefa.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BancoDadosHelper {

  // Aplicando Singleton na classe
  static final BancoDadosHelper _instancia = new BancoDadosHelper.interno();

  //Construtor privado
  BancoDadosHelper.interno();

  // Toda a vez que essa classe for chamada, fara com que seja retornado o atributo _instancia
  factory BancoDadosHelper() => _instancia;

  // Dados da tabela
  static final String tabelaTarefa = "tarefas";
  static final String colunaId = "id";
  static final String colunaItem = "nome";
  static final String colunaDataCriacao = "dataCriacao";



  // Acesso ao banco
  static Database _bd;

  //Getters
  Future<Database> get bd async {

    if(_bd != null){
      return _bd;
    }

    _bd = await inicializaBanco();

    return _bd;

  }

  inicializaBanco() async {

    Directory diretorio = await getApplicationDocumentsDirectory();
    String caminho = join(diretorio.path,"bancoTarefas.bd");
    var nossoBd = await openDatabase(caminho,
                                      version: 1,
                                      onCreate: _criaTabelas
                                    );
    return nossoBd;
  }

  Future finalizar() async {
    var clienteDb = await bd;
    return clienteDb.close();
  }


  Future _criaTabelas(Database bd, int versaoBanco) async {
    await bd.execute("CREATE TABLE $tabelaTarefa ($colunaId INTEGER PRIMARY KEY, $colunaItem TEXT, $colunaDataCriacao TEXT)");
  }

  // Obtem a quantidade de dados
  Future<int> obtemQtdTarefas()async {
    var clienteBd = await bd;
    return Sqflite.firstIntValue(await clienteBd.rawQuery("SELECT COUNT(*) FROM $tabelaTarefa"));
  }

  // Listagem de dados
  Future<List> obtemItems() async {
    var clienteBd = await bd;
    var todosItens = await clienteBd.rawQuery("SELECT * FROM $tabelaTarefa ORDER BY $colunaItem ASC");
    return todosItens.toList();
  }

  // Obtem um item
  Future<ItemTarefa> obtemItem(int id) async {
    ItemTarefa tarefa;
    var clienteDb = await bd;
    var resultado = await clienteDb.rawQuery("SELECT * FROM $tabelaTarefa WHERE $colunaId = $id");
    if(resultado != null){
      tarefa = new ItemTarefa.fromMap(resultado.first);
    }

    return tarefa;
  }

  // Inserção de dados
  Future<int> insereItem(ItemTarefa item)async {
    var clienteBd = await bd;
    int idIncluido =  await clienteBd.insert("$tabelaTarefa", item.toMap());
    return idIncluido;
  }

  // Atualização de dados
  Future<int> atualizaItem(ItemTarefa tarefa)async {
    var clienteBd = await bd;
    return await clienteBd.update("$tabelaTarefa", tarefa.toMap(), where: "$colunaId = ?", whereArgs: [tarefa.id]);
  }

  // Remoção de dados
  Future<int> removeItem(int id) async {
    var clienteBd = await bd;
    return await clienteBd.delete("$tabelaTarefa", where: "$colunaId = ?" , whereArgs: [id]);
  }

}