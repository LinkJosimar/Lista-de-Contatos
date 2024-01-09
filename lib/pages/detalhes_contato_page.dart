import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';

import '../model/contatos_model.dart';
import '../repository/contatos_repository.dart';

class DetalhesContatoPage extends StatefulWidget {
  const DetalhesContatoPage({super.key});

  @override
  State<DetalhesContatoPage> createState() => _DetalhesContatoPageState();
}

class _DetalhesContatoPageState extends State<DetalhesContatoPage> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool editaContato = false;
  var contatoRepository = ContatosRepository();
  var pathFotoCarregada = "";
  var pathFotoCamera = "";
  bool salvando = false;

  pick(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      String path =
          (await path_provider.getApplicationDocumentsDirectory()).path;
      String name = basename(photo.path);
      await photo.saveTo("$path/$name");
      await GallerySaver.saveImage(photo.path);

      setState(() {
        pathFotoCamera = photo.path;
        pathFotoCarregada = pathFotoCamera;
        _formData['pathFoto'] = pathFotoCarregada;
      });
    }
  }

  void _carregarFormData(Contato contato) {
    _formData['objectId'] = contato.objectId;
    _formData['nome'] = contato.nome;
    _formData['telefone'] = contato.telefone;
    _formData['email'] = contato.email;
    pathFotoCarregada = contato.pathFoto;
  }

  void obterContatos() async {
    await contatoRepository.obtercontatos();
  }

  @override
  Widget build(BuildContext context) {
    final contatoEdit = ModalRoute.of(context)?.settings.arguments as Contato?;
    if (contatoEdit != null) {
      _carregarFormData(contatoEdit);
      editaContato = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dados Contato"),
        backgroundColor: Colors.red.shade100,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                _form.currentState!.save();
                if (editaContato) {
                  var contatoEditado = Contato.atualizar(
                      _formData['objectId'].toString(),
                      _formData['nome'].toString(),
                      _formData['telefone'].toString(),
                      _formData['email'].toString(),
                      _formData['pathFoto'].toString());
                  await contatoRepository.atualizar(contatoEditado);
                } else {
                  var novoContato = Contato.criar(
                      _formData['nome'].toString(),
                      _formData['telefone'].toString(),
                      _formData['email'].toString(),
                      _formData['pathFoto'].toString());
                  await contatoRepository.salvar(novoContato);
                }
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      backgroundColor: Colors.white,
      body: salvando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: pathFotoCarregada.isNotEmpty ||
                                      pathFotoCamera.isNotEmpty
                                  ? FileImage(File(pathFotoCamera.isNotEmpty
                                      ? pathFotoCamera
                                      : pathFotoCarregada))
                                  : const AssetImage("images/person.png")
                                      as ImageProvider,
                              fit: BoxFit.cover),
                        ),
                      ),
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? photo =
                            await _picker.pickImage(source: ImageSource.camera);
                        if (photo != null) {
                          String path = (await path_provider
                                  .getApplicationDocumentsDirectory())
                              .path;
                          String name = basename(photo.path);
                          await photo.saveTo("$path/$name");
                          await GallerySaver.saveImage(photo.path);
                          if (photo.path != null) {
                            setState(() {
                              pathFotoCamera = photo.path;
                              _formData['pathFoto'] = pathFotoCamera;
                            });
                          }
                        }

                        // XFile? imageFile;
                        // _openGallery() async {
                        //   imageFile = await ImagePicker()
                        //       .pickImage(source: ImageSource.camera);
                        //   if (imageFile != null) {
                        //     setState(() {
                        //       pathFotoCarregada = imageFile!.path;
                        //     });
                        //   }
                        // }

                        //pick(ImageSource.camera);
                        // ImagePicker.pickImage(source: ImageSource.camera)
                        //     .then((file) {
                        //   if (file == null) return;
                        //   setState(() {
                        //     pathFotoCarregada = file.path;
                        //   });
                        // });

                        // setState(() {
                        //   pathFotoCarregada = pathFotoCamera;
                        // });
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['nome'],
                      decoration: const InputDecoration(labelText: "Nome"),
                      onSaved: (value) => _formData['nome'] = value!,
                    ),
                    TextFormField(
                      initialValue: _formData['email'],
                      decoration: const InputDecoration(labelText: "E-mail"),
                      onSaved: (value) => _formData['email'] = value!,
                    ),
                    TextFormField(
                      initialValue: _formData['telefone'],
                      decoration: const InputDecoration(labelText: "Telefone"),
                      onSaved: (value) => _formData['telefone'] = value!,
                      keyboardType: TextInputType.number,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
