import 'package:flutter/material.dart';
import 'package:sqlite/database.dart';
import 'package:sqlite/pessoa.dart';

class ListPessoas extends StatefulWidget {
  const ListPessoas({Key? key}) : super(key: key);

  @override
  _ListPessoasState createState() => _ListPessoasState();
}

class _ListPessoasState extends State<ListPessoas> {
  late DatabaseHandler handler;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.handler = new DatabaseHandler();
    this.handler.initializeDB().whenComplete(() {
      setState(() {
        this.handler.listarPessoas();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Pessoas List'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Pessoa>>(
          future: this.handler.listarPessoas(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].nome),
                    subtitle: Text(snapshot.data![index].idade),
                    leading: Icon(Icons.person),
                    onTap: () {
                      print('Clicou aqui');
                    },
                  );
                },
              );
            }
            return Container(
              alignment: AlignmentDirectional.center,
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
