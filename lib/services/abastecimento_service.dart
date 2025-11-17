import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbastecimentoService {
  final user = FirebaseAuth.instance.currentUser;

  CollectionReference get _colecaoUsuarios =>
      FirebaseFirestore.instance.collection("usuarios");

  CollectionReference get _colecaoAbastecimentos =>
      _colecaoUsuarios.doc(user!.uid).collection("abastecimentos");

  Future<void> adicionarAbastecimento(Map<String, dynamic> data) async {
    await _colecaoAbastecimentos.add(data);
  }

  Stream<QuerySnapshot> listarAbastecimentos() {
    return _colecaoAbastecimentos.orderBy("data", descending: true).snapshots();
  }

  Future<void> excluirAbastecimento(String id) async {
    await _colecaoAbastecimentos.doc(id).delete();
  }

  Future<void> editarAbastecimento(String id, Map<String, dynamic> data) async {
    await _colecaoAbastecimentos.doc(id).update(data);
  }
}
