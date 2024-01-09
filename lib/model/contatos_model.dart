class ContatosModel {
  List<Contato> contato = [];

  ContatosModel(this.contato);

  ContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contato = <Contato>[];
      json['results'].forEach((v) {
        contato.add(Contato.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = contato.map((v) => v.toJson()).toList();
    return data;
  }
}

class Contato {
  String objectId = "";
  String nome = "";
  String telefone = "";
  String email = "";
  String pathFoto = "";
  String createdAt = "";
  String updatedAt = "";

  Contato(this.objectId, this.nome, this.telefone, this.email, this.pathFoto,
      this.createdAt, this.updatedAt);

  Contato.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['nome'];
    telefone = json['telefone'];
    email = json['email'];
    pathFoto = json['path_foto'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Contato.criar(this.nome, this.telefone, this.email, this.pathFoto);

  Contato.atualizar(
      this.objectId, this.nome, this.telefone, this.email, this.pathFoto);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['nome'] = nome;
    data['telefone'] = telefone;
    data['email'] = email;
    data['path_foto'] = pathFoto;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['telefone'] = telefone;
    data['email'] = email;
    data['path_foto'] = pathFoto;
    return data;
  }

  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['telefone'] = telefone;
    data['email'] = email;
    data['path_foto'] = pathFoto;
    return data;
  }
}
