import 'package:flutter/material.dart';
import '/view_models/item_view_model.dart';
import 'package:provider/provider.dart';
import '/models/item.dart';
import '/services/pdf_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Compras')),
      body: Column(
        children: [
          // Lista de itens
          Expanded(
            child: Consumer<ItemViewModel>(
              builder: (context, viewModel, child) {
                return ListView.builder(
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.items[index];
                    return ListTile(
                      title: Text('${item.nome} (${item.quantidade})'),
                      trailing: IconButton(
                        icon: Icon(
                          item.comprado ? Icons.check_box : Icons.check_box_outline_blank,
                          color: item.comprado ? Colors.green : Colors.grey,
                        ),
                        onPressed: () {
                          // Alterna o status do item
                          viewModel.toggleItemStatus(item.id!);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Botão para adicionar item
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _showAddItemDialog(context),
              child: Text('Adicionar Item'),
            ),
          ),
          // Botão para gerar relatório PDF
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                // Gera o relatório em PDF com os itens
                await PdfService.generatePdf(
                    Provider.of<ItemViewModel>(context, listen: false).items);
              },
              child: Text('Gerar Relatório'),
            ),
          ),
        ],
      ),
    );
  }

  // Função para mostrar o diálogo de adicionar item
  void _showAddItemDialog(BuildContext context) {
    final nomeController = TextEditingController();
    final quantidadeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Item'),
          content: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nome = nomeController.text;
                final quantidade = int.tryParse(quantidadeController.text) ?? 0;
                if (nome.isNotEmpty && quantidade > 0) {
                  final item = Item(nome: nome, quantidade: quantidade);
                  Provider.of<ItemViewModel>(context, listen: false).addItem(item);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
}
