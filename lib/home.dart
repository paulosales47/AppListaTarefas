import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = [];
  var _controllerTarefa = TextEditingController();

  Future<File> _recuperarDiretorioArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  Future _criarArquivo() async{
    File arquivo = await _recuperarDiretorioArquivo();
    if(! await arquivo.exists()){
      await _salvarArquivo();
    }
  }

  Future _salvarArquivo() async {
    File arquivo = await _recuperarDiretorioArquivo();
    String listaTarefaJson = json.encode(_listaTarefas);
    await arquivo.writeAsString(listaTarefaJson);
  }

  Future _carregarArquivo() async {
    try {
      File arquivo = await _recuperarDiretorioArquivo();
      String dadosArquivo = await arquivo.readAsString();
      _listaTarefas = json.decode(dadosArquivo);
    } catch(e){
      print("ERRO: $e");
      throw e;
    }
  }

  Future _salvarTarefa() async{
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = _controllerTarefa.text;
    tarefa["realizada"] = false;
    setState(() {
      _listaTarefas.add(tarefa);
    });
    await _salvarArquivo();
    _controllerTarefa.text = "";
  }

  @override
  void initState() {
    super.initState();

      _criarArquivo().then((value) {
        _carregarArquivo().then((value) {
          setState(() {});
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: (context, indice) {
                  return Dismissible(
                    key:  UniqueKey(),
                    direction: DismissDirection.horizontal,
                    child: CheckboxListTile(
                        title: Text(_listaTarefas[indice]["titulo"]),
                        value: _listaTarefas[indice]["realizada"],
                        onChanged: (valor) async {
                          _listaTarefas[indice]["realizada"] = valor;
                          await _salvarArquivo();
                          setState(() {});
                        }
                    ),
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        children: [
                          Icon(Icons.delete)
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.edit)
                        ],
                      ),
                    ),
                    onDismissed:(direcao) {
                      Map<String, dynamic> ultimaTarefaRemovida = Map();
                      ultimaTarefaRemovida = _listaTarefas[indice];

                      if(direcao == DismissDirection.startToEnd){
                        _listaTarefas.removeAt(indice);
                        _salvarArquivo().then((value){
                          _carregarArquivo();
                        });
                      }

                      if(direcao == DismissDirection.endToStart)
                        print("Editar");

                      final snackBar = SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text("Tarefa removida", style: TextStyle(color: Colors.yellow)),
                        action: SnackBarAction(
                          label: "Desfazer",
                          onPressed: () async {
                            setState(() {
                              _listaTarefas.insert(indice, ultimaTarefaRemovida);
                            });
                            await _salvarArquivo();
                          },
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    },
                  );
                }),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 6,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(
                        labelText: "Informe sua tarefa"
                    ),
                  ),
                  actions: [
                    ElevatedButton(onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar")),
                    ElevatedButton(onPressed: () async {
                      await _salvarTarefa();
                      Navigator.pop(context);
                    }, child: Text("Salvar")),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );

  }




}
