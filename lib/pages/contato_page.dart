import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/contatos_model.dart';
import '../repository/contatos_repository.dart';
import '../routes/app_routes.dart';

class ContatoPage extends StatefulWidget {
  const ContatoPage({super.key});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  var contato = ContatosModel([]);
  var contatoRepository = ContatosRepository();
  var novoContato = ContatosModel([]);
  bool loading = false;

  @override
  void initState() {
    obterContatos();
    super.initState();
  }

  obterContatos() async {
    setState(() {
      loading = true;
    });
    contato = await contatoRepository.obtercontatos();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Contatos"),
        backgroundColor: Colors.red.shade100,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(
            AppRoutes.userForm,
          );
          obterContatos();
        },
        backgroundColor: Colors.red.shade200,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: contato.contato.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (DismissDirection dismissDirection) async {
                    await contatoRepository
                        .remover(contato.contato[index].objectId);
                    obterContatos();
                  },
                  key: Key(contato.contato[index].telefone),
                  child: InkWell(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: contato
                                            .contato[index].pathFoto.isNotEmpty
                                        ? FileImage(
                                            File(contato
                                                .contato[index].pathFoto),
                                          )
                                        : const AssetImage("images/person.png")
                                            as ImageProvider,
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(contato.contato[index].nome,
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold)),
                                    Text(contato.contato[index].email,
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold)),
                                    Text(contato.contato[index].telefone,
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _showOptions(context, index);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        child: const Text(
                          "Ligar",
                          style: TextStyle(
                              color: Color.fromARGB(255, 117, 85, 83),
                              fontSize: 20.0),
                        ),
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              "tel: ${contato.contato[index].telefone.toString()}"));
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        child: const Text(
                          "Editar",
                          style: TextStyle(
                              color: Color.fromARGB(255, 117, 85, 83),
                              fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(
                            context,
                            AppRoutes.userForm,
                            arguments: contato.contato[index],
                          );
                          obterContatos();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
