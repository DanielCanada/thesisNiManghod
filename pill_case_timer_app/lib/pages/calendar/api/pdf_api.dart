import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pill_case_timer_app/models/schedule.dart';
import 'package:pill_case_timer_app/models/user_profile.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

class PdfApi {
  static Future<File> generatePDF({
    required List<Schedule> pastSchedules,
    required UserProfile user,
    required ByteData? imageSignature,
  }) async {
    final document = PdfDocument();
    final page = document.pages.add();

    drawGrid(page, pastSchedules);
    drawSignature(user, page, imageSignature!);

    return saveFile(document);
  }

  static void drawGrid(PdfPage page, List<Schedule> pastSchedules) {
    final grid = PdfGrid();
    grid.columns.add(count: 4);

    final headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = "Medicine";
    headerRow.cells[1].value = "Scheduled Date";
    headerRow.cells[2].value = "Scheduled Time";
    headerRow.cells[3].value = "Doctor";

    // styles
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(91, 110, 219));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    pastSchedules.forEach((element) {
      DateTime now = DateTime.now();
      DateTime time = DateTime(now.year, now.month, now.day,
          element.alarmTime.hour, element.alarmTime.minute);
      final row = grid.rows.add();
      row.cells[0].value = element.schedName;
      row.cells[1].value = DateFormat.yMMMd().format(element.createdAt);
      row.cells[2].value = DateFormat.jm().format(time);
      row.cells[3].value = element.doctorName;
    });

    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, top: 5, right: 5);
    }

    for (int i = 0; i < grid.rows.count; i++) {
      final row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final cell = row.cells[j];

        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, top: 5, right: 5);
      }
    }

    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 169, 0, 0));
  }

  static void drawSignature(
      UserProfile user, PdfPage page, ByteData imageSignature) {
    final pageSize = page.getClientSize();
    final PdfBitmap image = PdfBitmap(imageSignature.buffer.asUint8List());

    final now = "Date: ${DateFormat.yMMMEd().format(DateTime.now())}";
    const pdfTitle = 'Pill Case Timer';
    final signatureName = "${user.firstName}\n    Patient";
    final patientInfoName = "Name: ${user.firstName} ${user.lastName}";
    final patientInfoAddress = "Email: ${user.email}";
    final patientInfo01 = "Age: ${user.age}   Gender: ${user.gender}";
    final doctorName = "";

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
