import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = ["Estudar Flutter", "Algoritimos", "Arquitetura", "Desenho"];

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
                itemBuilder: (context, indice){
                  return ListTile(
                    title: Text(_listaTarefas[indice]),
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
        onPressed: (){
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("Adicionar tarefa"),
                  content: TextField(
                    decoration: InputDecoration(
                      labelText: "Informe sua tarefa"
                    ),
                    onChanged: (valorInformado){

                    },
                  ),
                  actions: [
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
                    ElevatedButton(onPressed: (){

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
