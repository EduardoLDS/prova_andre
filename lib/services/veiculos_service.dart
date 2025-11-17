import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VeiculosService {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference get _colecao =>
      db.collection("users").doc(user!.uid).collection("veiculos");

  Future<void> adicionarVeiculo({
    required String modelo,
    required String marca,
    required String placa,
    required String ano,
    required String tipoCombustivel,
  }) async {
    await _colecao.add({
      "modelo": modelo,
      "marca": marca,
      "placa": placa,
      "ano": ano,
      "tipoCombustivel": tipoCombustivel,
      "createdAt": Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> listarVeiculos() {
    return _colecao.orderBy("createdAt", descending: true).snapshots();
  }

  Future<void> atualizarVeiculo(String id, Map<String, dynamic> dados) async {
    await _colecao.doc(id).update(dados);
  }

  Future<void> deletarVeiculo(String id) async {
    await _colecao.doc(id).delete();
  }
}
