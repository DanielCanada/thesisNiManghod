import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

class PdfApi {
  static Future<File> generatePDF({
    required String patientName,
    required String content,
    required ByteData? imageSignature,
  }) async {
    final document = PdfDocument();
    final page = document.pages.add();

    drawSignature(patientName, content, page, imageSignature!);

    return saveFile(document);
  }

  static void drawSignature(String patientName, String content, PdfPage page,
      ByteData imageSignature) {
    final pageSize = page.getClientSize();
    final PdfBitmap image = PdfBitmap(imageSignature.buffer.asUint8List());

    final now = "Date: ${DateFormat.yMMMEd().format(DateTime.now())}";
    final pdfTitle = 'Pill Case Timer';
    final signatureName = "$patientName\n    Patient";
    final patientInfoName = "Name: $patientName";
    final patientInfoAddress =
        "Address: Bacolod City, Negros Occidental, Philippines, 6100";
    final patientInfo01 = "Age: 22   Gender: M   Weight: 00  Height: 00  ";

    page.graphics.drawString(
        pdfTitle, PdfStandardFont(PdfFontFamily.helvetica, 36),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        bounds: Rect.fromLTRB(
            pageSize.width / 2, 3, pageSize.width / 2, pageSize.width - 200));

    page.graphics.drawString(
        'Monthly Intake Report', PdfStandardFont(PdfFontFamily.helvetica, 22),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        bounds: Rect.fromLTRB(
            pageSize.width / 2, 38, pageSize.width / 2, pageSize.width - 200));

    // patient details and doctor name
    page.graphics.drawString(
        patientInfoName, PdfStandardFont(PdfFontFamily.helvetica, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTRB(20, 90, 400, pageSize.width - 200));

    page.graphics.drawString(
        patientInfo01, PdfStandardFont(PdfFontFamily.helvetica, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTRB(20, 114, 0, pageSize.width - 200));

    page.graphics.drawString(now, PdfStandardFont(PdfFontFamily.helvetica, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds:
            Rect.fromLTRB(pageSize.width - 150, 90, 0, pageSize.width - 200));

    page.graphics.drawString(
        patientInfoAddress, PdfStandardFont(PdfFontFamily.helvetica, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTRB(20, 138, 400, pageSize.width - 200));

    // patient name
    page.graphics.drawString(
        signatureName, PdfStandardFont(PdfFontFamily.helvetica, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(
            pageSize.width - 105, pageSize.height - 120, 100, 40));

    page.graphics.drawImage(image,
        Rect.fromLTWH(pageSize.width - 120, pageSize.height - 160, 100, 40));

    page.graphics.drawString("___________________________",
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(
            pageSize.width - 116, pageSize.height - 146, 200, 40));
  }

  static Future<File> saveFile(PdfDocument document) async {
    final path = await getApplicationDocumentsDirectory();
    final fileName =
        '${path.path}/Report${DateTime.now().toIso8601String()}.pdf';
    final file = File(fileName);

    file.writeAsBytes(await document.save());
    document.dispose();

    return file;
  }
}
