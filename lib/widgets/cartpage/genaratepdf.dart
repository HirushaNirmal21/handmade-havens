import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateAndShareInvoicePDF({
  required String name,
  required String phone,
  required String address,
  required double totalAmount,
  required List<dynamic> cartItems,
}) async {
  final pdf = pw.Document();
  List<pw.TableRow> itemRows = [];

  itemRows.add(
    pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            "Photo",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            "Item Name",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            "Qty",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            "Price (Rs.)",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    ),
  );

  for (var item in cartItems) {
    final String itemName = item.product.name;
    final int qty = item.quantity;
    final double price = item.product.price * qty;
    final String imageUrl = item.product.imageUrl;
    pw.Widget imageWidget;

    try {
      final imageBytes = await networkImage(imageUrl);
      imageWidget = pw.Image(
        pw.MemoryImage(imageBytes as Uint8List),
        width: 40,
        height: 40,
        fit: pw.BoxFit.cover,
      );
    } catch (e) {
      imageWidget = pw.Container(
        width: 40,
        height: 40,
        color: PdfColors.grey300,
      );
    }

    itemRows.add(
      pw.TableRow(
        verticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [
          pw.Padding(padding: const pw.EdgeInsets.all(6), child: imageWidget),
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(itemName),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(qty.toString()),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(price.toStringAsFixed(2)),
          ),
        ],
      ),
    );
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  "DIGITAL INVOICE",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.pink,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),

              pw.Text(
                "CUSTOMER DETAILS",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text("Name: $name"),
              pw.Text("Phone: $phone"),
              pw.Text("Address: $address"),

              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),

              pw.Text(
                "ORDERED ITEMS",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: itemRows,
              ),

              pw.SizedBox(height: 20),
              pw.Divider(),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "TOTAL BILL:",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    "Rs. ${totalAmount.toStringAsFixed(2)}",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.pink,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 40),
              pw.Center(
                child: pw.Text(
                  "Thank you for your business! ✨",
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'Invoice_${name.replaceAll(' ', '_')}.pdf',
  );
}
