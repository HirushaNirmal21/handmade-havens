import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:url_launcher/url_launcher.dart';

class QRViewerScreen extends StatelessWidget {
  final dynamic cart;
  final String customerName;
  final String customerPhone;
  final String customerAddress;

  const QRViewerScreen({
    super.key,
    required this.cart,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
  });

  Future<void> _downloadOrPrintPDF(String qrData, double totalAmount) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Container(
            color: PdfColors.white,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // 🌈 1. Top Header Gradient Section
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 24,
                  ),
                  decoration: const pw.BoxDecoration(
                    gradient: pw.LinearGradient(
                      colors: [
                        PdfColor.fromInt(0xFFFF1493), // Deep Pink
                        PdfColor.fromInt(0xFF1A1A2E), // Dark Blue
                      ],
                      begin: pw.Alignment.topLeft,
                      end: pw.Alignment.bottomRight,
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "INVOICE / ORDER SUMMARY",
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        "Generated automatically via System Scan",
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.Padding(
                  padding: const pw.EdgeInsets.all(24),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // 👤 Customer Details Card
                      pw.Container(
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey100,
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(8),
                          ),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "CUSTOMER DETAILS",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromInt(0xFF1A1A2E),
                              ),
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              "Name     : $customerName",
                              style: const pw.TextStyle(fontSize: 11),
                            ),
                            pw.Text(
                              "Phone    : $customerPhone",
                              style: const pw.TextStyle(fontSize: 11),
                            ),
                            pw.Text(
                              "Address  : $customerAddress",
                              style: const pw.TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),

                      pw.SizedBox(height: 25),

                      pw.Text(
                        "ORDERED ITEMS",
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromInt(0xFF1A1A2E),
                        ),
                      ),
                      pw.SizedBox(height: 8),

                      pw.Table(
                        border: pw.TableBorder.symmetric(
                          inside: pw.BorderSide(
                            color: PdfColors.grey300,
                            width: 0.5,
                          ),
                          outside: pw.BorderSide(
                            color: PdfColors.grey400,
                            width: 1,
                          ),
                        ),
                        children: [
                          // Table Header
                          pw.TableRow(
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.grey200,
                            ),
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  "Item Name",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  "Qty",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Text(
                                  "Total (Rs.)",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          // Table Rows
                          ...cart.cartItems.map<pw.TableRow>((item) {
                            return pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    item.product.name,
                                    style: const pw.TextStyle(fontSize: 11),
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    item.quantity.toString(),
                                    style: const pw.TextStyle(fontSize: 11),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    (item.product.price * item.quantity)
                                        .toStringAsFixed(2),
                                    style: const pw.TextStyle(fontSize: 11),
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),

                      pw.SizedBox(height: 20),

                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            "TOTAL BILL :  ",
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            "Rs. ${totalAmount.toStringAsFixed(2)}",
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFFFF1493),
                            ),
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 40),
                      pw.Divider(color: PdfColors.grey300, thickness: 0.5),
                      pw.SizedBox(height: 15),

                      pw.Center(
                        child: pw.Column(
                          children: [
                            pw.BarcodeWidget(
                              barcode: pw.Barcode.qrCode(),
                              data: qrData,
                              width: 120,
                              height: 120,
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              "Scan this QR code to verify order details",
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: PdfColors.grey600,
                                fontStyle: pw.FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final String fileName = 'Invoice_${customerName.replaceAll(' ', '_')}.pdf';
    final Uint8List pdfBytes = await pdf.save();

    if (kIsWeb) {
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: fileName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double finalTotalAmount = cart.totalAmount;

    final List<Map<String, dynamic>> itemsList = cart.cartItems
        .map<Map<String, dynamic>>(
          (item) => {
            'name': item.product.name,
            'qty': item.quantity,
            'price': item.product.price,
          },
        )
        .toList();

    final Map<String, dynamic> orderJson = {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'totalAmount': finalTotalAmount,
      'items': itemsList,
    };

    final String qrData = jsonEncode(orderJson);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text(
          "Your Order QR Code 🔲",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Click \"Download / Print PDF Invoice\" below to save the official invoice. Stock will update automatically!",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 250.0,
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await _downloadOrPrintPDF(qrData, finalTotalAmount);

                          String shopNumber = "94757209765";
                          String itemsText = cart.cartItems
                              .map(
                                (item) =>
                                    "- ${item.product.name} (Qty: ${item.quantity})",
                              )
                              .join("\n");

                          String whatsappMessage =
                              "🔔 *NEW ORDER RECEIVED* 🔔\n\n"
                              "👤 *Customer:* $customerName\n"
                              "📞 *Phone:* $customerPhone\n"
                              "📍 *Address:* $customerAddress\n\n"
                              "📦 *Items:* \n$itemsText\n\n"
                              "💰 *Total Bill:* Rs. ${finalTotalAmount.toStringAsFixed(2)}\n\n"
                              "📄 _PDF Invoice has been downloaded by customer._";

                          String encodedMessage = Uri.encodeComponent(
                            whatsappMessage,
                          );
                          String whatsappUrl =
                              "https://wa.me/$shopNumber?text=$encodedMessage";

                          if (kIsWeb) {
                            html.window.open(whatsappUrl, '_blank');
                          } else {
                            final Uri url = Uri.parse(whatsappUrl);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          }

                          await cart.checkoutOrPlaceOrder();

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "🎉 Invoice Saved & Order Sent via WhatsApp!",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: ${e.toString()}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text(
                        "Download PDF Invoice",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF1493),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
