import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '/models/item.dart';

class PdfService {
  static Future<void> generatePdf(List<Item> items) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Relatório de Compras', style: pw.TextStyle(fontSize: 24)),
            pw.ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return pw.Text('${item.nome} - Quantidade: ${item.quantidade}');
              },
            ),
          ],
        );
      },
    ));

    // Permite imprimir ou salvar o PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
