import 'package:flutter/material.dart';
import '../services/veiculos_service.dart';

class VeiculoFormPage extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? dados;

  VeiculoFormPage({this.id, this.dados});

  @override
  State<VeiculoFormPage> createState() => _VeiculoFormPageState();
}

class _VeiculoFormPageState extends State<VeiculoFormPage> {
  final modelo = TextEditingController();
  final marca = TextEditingController();
  final placa = TextEditingController();
  final ano = TextEditingController();
  final tipo = TextEditingController();

  final service = VeiculosService();

  @override
  void initState() {
    super.initState();
    if (widget.dados != null) {
      modelo.text = widget.dados!["modelo"];
      marca.text = widget.dados!["marca"];
      placa.text = widget.dados!["placa"];
      ano.text = widget.dados!["ano"];
      tipo.text = widget.dados!["tipoCombustivel"];
    }
  }

  Future<void> salvar() async {
    if (widget.id == null) {
      await service.adicionarVeiculo(
        modelo: modelo.text,
        marca: marca.text,
        placa: placa.text,
        ano: ano.text,
        tipoCombustivel: tipo.text,
      );
    } else {
      await service.atualizarVeiculo(widget.id!, {
        "modelo": modelo.text,
        "marca": marca.text,
        "placa": placa.text,
        "ano": ano.text,
        "tipoCombustivel": tipo.text,
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? "Novo Veículo" : "Editar Veículo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: modelo,
              decoration: InputDecoration(labelText: "Modelo"),
            ),
            TextField(
              controller: marca,
              decoration: InputDecoration(labelText: "Marca"),
            ),
            TextField(
              controller: placa,
              decoration: InputDecoration(labelText: "Placa"),
            ),
            TextField(
              controller: ano,
              decoration: InputDecoration(labelText: "Ano"),
            ),
            TextField(
              controller: tipo,
              decoration: InputDecoration(labelText: "Tipo de Combustível"),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvar,
              child: Text(
                widget.id == null ? "Cadastrar" : "Salvar alterações",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
