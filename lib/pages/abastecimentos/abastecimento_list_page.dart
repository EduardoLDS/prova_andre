import 'package:flutter/material.dart';
import '../../services/abastecimento_service.dart';
import 'abastecimento_form_page.dart';

class AbastecimentoListPage extends StatelessWidget {
  const AbastecimentoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AbastecimentoService();

    return Scaffold(
      appBar: AppBar(title: const Text("Abastecimentos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AbastecimentoFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: service.listarAbastecimentos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Nenhum abastecimento cadastrado"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                    "Veículo: ${data['veiculoId']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Data: ${data['data']}\n"
                    "Litros: ${data['quantidadeLitros']} L\n"
                    "Valor Pago: R\$ ${data['valorPago']}\n"
                    "Km: ${data['quilometragem']}\n"
                    "Consumo: ${data['consumo']} km/L",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AbastecimentoFormPage(id: doc.id, data: data),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await service.excluirAbastecimento(doc.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
