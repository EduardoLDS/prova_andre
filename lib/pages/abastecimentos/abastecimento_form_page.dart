import 'package:flutter/material.dart';
import '../../services/abastecimento_service.dart';

class AbastecimentoFormPage extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? data;

  const AbastecimentoFormPage({super.key, this.id, this.data});

  @override
  State<AbastecimentoFormPage> createState() => _AbastecimentoFormPageState();
}

class _AbastecimentoFormPageState extends State<AbastecimentoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final service = AbastecimentoService();

  final dataController = TextEditingController();
  final litrosController = TextEditingController();
  final valorController = TextEditingController();
  final kmController = TextEditingController();
  final tipoCombustivelController = TextEditingController();
  final veiculoIdController = TextEditingController();
  final consumoController = TextEditingController();
  final obsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      dataController.text = widget.data!["data"] ?? "";
      litrosController.text = widget.data!["quantidadeLitros"].toString();
      valorController.text = widget.data!["valorPago"].toString();
      kmController.text = widget.data!["quilometragem"].toString();
      tipoCombustivelController.text = widget.data!["tipoCombustivel"] ?? "";
      veiculoIdController.text = widget.data!["veiculoId"] ?? "";
      consumoController.text = widget.data!["consumo"].toString();
      obsController.text = widget.data!["observacao"] ?? "";
    }
  }

  void calcularConsumo() {
    double litros = double.tryParse(litrosController.text) ?? 0;
    double km = double.tryParse(kmController.text) ?? 0;

    if (litros > 0) {
      consumoController.text = (km / litros).toStringAsFixed(2);
    }
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final dados = {
      "data": dataController.text,
      "quantidadeLitros": double.parse(litrosController.text),
      "valorPago": double.parse(valorController.text),
      "quilometragem": double.parse(kmController.text),
      "tipoCombustivel": tipoCombustivelController.text,
      "veiculoId": veiculoIdController.text,
      "consumo": double.parse(consumoController.text),
      "observacao": obsController.text,
    };

    if (widget.id != null) {
      await service.editarAbastecimento(widget.id!, dados);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Atualizado com sucesso!")));
    }
    /// CRIAR
    else {
      await service.adicionarAbastecimento(dados);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Abastecimento salvo!")));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.id != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? "Editar Abastecimento" : "Novo Abastecimento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: dataController,
                decoration: const InputDecoration(labelText: "Data"),
                validator: (v) => v!.isEmpty ? "Informe a data" : null,
              ),
              TextFormField(
                controller: litrosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantidade de Litros",
                ),
                onChanged: (_) => calcularConsumo(),
              ),
              TextFormField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Valor Pago"),
              ),
              TextFormField(
                controller: kmController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quilometragem"),
                onChanged: (_) => calcularConsumo(),
              ),
              TextFormField(
                controller: tipoCombustivelController,
                decoration: const InputDecoration(
                  labelText: "Tipo de Combustível",
                ),
              ),
              TextFormField(
                controller: veiculoIdController,
                decoration: const InputDecoration(labelText: "ID do Veículo"),
              ),
              TextFormField(
                controller: consumoController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Consumo (km/L)"),
              ),
              TextFormField(
                controller: obsController,
                decoration: const InputDecoration(labelText: "Observações"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: salvar,
                child: Text(editando ? "Atualizar" : "Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
