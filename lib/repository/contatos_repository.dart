import 'package:listacontatos/model/contatos_model.dart';
import 'package:listacontatos/repository/custom_dio.dart';

class ContatosRepository {
  final _customDio = ContatosCustomDio();

  ContatosRepository();

  Future<ContatosModel> obtercontatos() async {
    var result = await _customDio.dio.get("/contato");
    return ContatosModel.fromJson(result.data);
  }

  Future<void> salvar(Contato contato) async {
    try {
      await _customDio.dio.post("/contato", data: contato.toCreateJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      await _customDio.dio.delete("/contato/$objectId");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(Contato contato) async {
    try {
      await _customDio.dio
          .put("/contato/${contato.objectId}", data: contato.toUpdateJson());
    } catch (e) {
      rethrow;
    }
  }
}
