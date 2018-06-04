import 'package:flutter/material.dart';
import 'package:flutter_24_lista_tarefas/ui/item_tarefa.dart';
import 'package:flutter_24_lista_tarefas/utilidades/cliente_bancodados.dart';
import 'package:flutter_24_lista_tarefas/utilidades/formata_datas.dart';

class TelaTarefas extends StatefulWidget {
  @override
  _TelaTarefasState createState() => new _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final TextEditingController _campoItemController =
      new TextEditingController();
  var bd = new BancoDadosHelper();

  final List<ItemTarefa> _listaTarefas =
      <ItemTarefa>[]; // Inicializa a lista como vazia

  @override
  void initState() {
    super.initState();

    _lerListaTarefas();
  }

  void _trataEnviar(String textoTarefa) async {
    _campoItemController.clear();
    ItemTarefa item =
        //new ItemTarefa(textoTarefa, new DateTime.now().toIso8601String());
    new ItemTarefa(textoTarefa, formataData());
    int idItemIncluido = await bd.insereItem(item);

    ItemTarefa itemAdicionado = await bd.obtemItem(idItemIncluido);
    // Algo mudou, atualiza o estado
    setState(() {
      _listaTarefas.insert(0, itemAdicionado);
    });
    print("Item incluido: $idItemIncluido");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              itemBuilder: (_, int posicao) {
                return new Card(
                  color: Colors.white10,
                  child: new ListTile(
                    title: _listaTarefas[posicao],
                    onLongPress: () =>
                        atualizaItem(_listaTarefas[posicao], posicao),
                    // Sera usado para atualizar o item
                    trailing: new Listener(
                      key: new Key(_listaTarefas[posicao].nome),
                      child: new Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (eventoPonteiro) => _removeItem(
                          _listaTarefas[posicao].id,
                          posicao), // Sera usado para remover o item
                    ),
                  ),
                );
              },
              reverse: false, //Go Horse, Workaround, Gambiarra...
              padding: new EdgeInsets.all(8.0),
              itemCount: _listaTarefas.length,
            ),
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: "Adicione um item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _mostraFormlarioComoDialog),
    );
  }

  void _mostraFormlarioComoDialog() {
    var alerta = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _campoItemController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Item",
              hintText: "Ex: Malhar na academia",
              icon: new Icon(Icons.note_add),
            ),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            _trataEnviar(_campoItemController.text);
            Navigator.pop(context);
          },
          child: new Text("Salvar"),
        ),
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text("Cancelar")),
      ],
    );

    // para mostra o Dialog
    /// Novo comentario....
    showDialog(
        context: context,
        builder: (_) {
          /// _ é o mesmo que passar o context
          return alerta;
        });
  }

  _lerListaTarefas() async {
    List tarefas = await bd.obtemItems();
    tarefas.forEach((item) {
//      ItemTarefa tarefa = ItemTarefa.map(item);
      setState(() {
        _listaTarefas.add(ItemTarefa.map(item));
      });
//      print("Tarefas do banco: ${tarefa.nome}");
    });
  }

  _removeItem(int id, int posicao) async {
    debugPrint("Removendo o item $id");
    await bd.removeItem(id);
    // Atualiza a tela
    setState(() {
      _listaTarefas.removeAt(posicao);
    });
  }

  atualizaItem(ItemTarefa tarefa, int posicao) {
    var alerta = new AlertDialog(
      title: new Text("Atualiza Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _campoItemController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Item",
              hintText: tarefa.nome, // Aqui poderia substuir o valor do campo com o que estava preenchido
              icon: new Icon(Icons.update),
            ),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              ItemTarefa tarefaAtualizada = ItemTarefa.fromMap({
                "nome" : _campoItemController.text,
                "dataCriacao" : formataData(),
                "id" : tarefa.id
              });
              _trataAtualizacao(posicao, tarefa);
              await bd.atualizaItem(tarefaAtualizada);
              setState(() {
                _lerListaTarefas();
              });
              Navigator.pop(context);
            },
            child: new Text("Atualizar")),
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text("Cancelar"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alerta;
        });
  }

  void _trataAtualizacao(int posicao, ItemTarefa tarefa) {

    setState(() {
      _listaTarefas.removeWhere((item){
        _listaTarefas[posicao].nome == tarefa.nome;
      });
    });
  }
}
