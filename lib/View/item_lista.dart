import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/sqflite/Sqlite.dart' as Sqlite;

class ListaItem extends StatefulWidget {
  const ListaItem({Key? key}) : super(key: key);

  @override
  _ListaItemState createState() => _ListaItemState();
}

class _ListaItemState extends State<ListaItem> {
  var key = const ListaItem().key;

  mostrarDialog(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Deseja excluir o item?"),
            actions: [
              ElevatedButton(
                child: const Text("Sim"),
                onPressed: () {
                  Sqlite.Sqflite.deletarItem(id);
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              ElevatedButton(
                child: const Text("Não"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Itens"),
          backgroundColor: Colors.green,

          //Define as ações que podem ser realizadas na appbar
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.pushNamed(context, '/itemCadastro', arguments: null).then((value) {
                    setState(() {});
                  }),
            )
          ],
        ),

        body: FutureBuilder(

          // future: Sqlite.Sqflite.buscarDadosItem(),
          key: key,
          future: Sqlite.Sqflite.buscarDadosItem(),


          builder: (context,
              AsyncSnapshot<List<Map<String, Object?>>?> dadosFuturos) {
            //Caso a consulta ainda não tenha retornado os dados vai ser mostrado
            // o spinner de carregando
            if (!dadosFuturos.hasData) {
              return const CircularProgressIndicator();
            }
            var listaItem = dadosFuturos.data!;
            return ListView.builder(
              itemCount: listaItem.length,
              itemBuilder: (context, contador) {
                var item = listaItem[contador];
                return ListTile(
                  title: Text(item['nome'].toString()),
                  subtitle: Text(item['descricao'].toString()),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.amber,
                          onPressed: () => Navigator.pushNamed(
                              context, '/itemCadastro',
                              arguments: item).then((value) {
                                setState(() {});
                              }),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => mostrarDialog(
                              context, int.parse(item['id'].toString())),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}

