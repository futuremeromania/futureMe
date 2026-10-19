import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const _heading = PdfColor.fromInt(0xFF2A0E5D);
const _accent = PdfColor.fromInt(0xFF4F4A9E);
const _body = PdfColor.fromInt(0xFF211431);
const _muted = PdfColor.fromInt(0xFF6D5D78);
const _border = PdfColor.fromInt(0xFFE9DCD7);
const _cream = PdfColor.fromInt(0xFFFEF6F2);
const _soft = PdfColor.fromInt(0xFFF2ECFF);
const _gradient = pw.LinearGradient(
  colors: [PdfColor.fromInt(0xFF2B0B78), PdfColor.fromInt(0xFF7F378E), PdfColor.fromInt(0xFFD35771)],
);

const _months = [
  'ianuarie', 'februarie', 'martie', 'aprilie', 'mai', 'iunie',
  'iulie', 'august', 'septembrie', 'octombrie', 'noiembrie', 'decembrie',
];

String _romanianDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

/// Renders the final FutureMe report as a PDF: a cover (app name, subtitle,
/// the user's name, the generation date and a short message), then the
/// numbered sections of the report structure with their subsections.
///
/// Reports generated before the structured version have no `blocks`; their
/// flat `{title, body}` sections are rendered as plain numbered sections.
Future<Uint8List> buildReportPdf({required String userName, required GeneratedReport report}) async {
  final regular = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
  final bold = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
  final theme = pw.ThemeData.withFont(base: regular, bold: bold);

  final blocks = report.blocks.isNotEmpty
      ? report.blocks
      : [
          for (final s in report.sections)
            GeneratedReportBlock(title: s.title, items: [GeneratedReportItem(text: s.body)]),
        ];
  final date = _romanianDate(report.generatedAt ?? DateTime.now());

  final doc = pw.Document(title: 'Raport FutureMe', author: 'FutureMe');

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      theme: theme,
      margin: pw.EdgeInsets.zero,
      build: (context) => _cover(userName: userName, date: date),
    ),
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: theme,
      margin: const pw.EdgeInsets.fromLTRB(48, 44, 48, 40),
      footer: (context) => pw.Container(
        margin: const pw.EdgeInsets.only(top: 16),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('FutureMe · Raport personalizat de claritate profesională', style: const pw.TextStyle(fontSize: 8.5, color: _muted)),
            pw.Text('${context.pageNumber - 1} / ${context.pagesCount - 1}', style: const pw.TextStyle(fontSize: 8.5, color: _muted)),
          ],
        ),
      ),
      build: (context) => [
        if (report.summary != null && report.summary!.trim().isNotEmpty) ...[
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(color: _soft, borderRadius: pw.BorderRadius.circular(10)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Pe scurt', style: pw.TextStyle(font: bold, fontSize: 10, color: _accent)),
                pw.SizedBox(height: 4),
                pw.Text(report.summary!.trim(), style: const pw.TextStyle(fontSize: 11, color: _body, lineSpacing: 2.5)),
              ],
            ),
          ),
          pw.SizedBox(height: 22),
        ],
        for (var i = 0; i < blocks.length; i++) ..._block(i + 1, blocks[i], bold, isLast: i == blocks.length - 1),
      ],
    ),
  );

  return doc.save();
}

pw.Widget _cover({required String userName, required String date}) {
  return pw.Container(
    color: _cream,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(height: 10, decoration: const pw.BoxDecoration(gradient: _gradient)),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(56, 56, 56, 0),
          child: pw.Text('FutureMe', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 22, color: _heading)),
        ),
        pw.Spacer(),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 56),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Raport personalizat de claritate profesională',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 32, color: _heading, lineSpacing: 4),
              ),
              pw.SizedBox(height: 18),
              pw.Container(width: 72, height: 4, decoration: pw.BoxDecoration(gradient: _gradient, borderRadius: pw.BorderRadius.circular(2))),
              pw.SizedBox(height: 28),
              pw.Text(userName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18, color: _body)),
              pw.SizedBox(height: 6),
              pw.Text('Generat pe $date', style: const pw.TextStyle(fontSize: 12, color: _muted)),
            ],
          ),
        ),
        pw.Spacer(),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(56, 0, 56, 56),
          child: pw.Text('Acest raport este despre tine și direcția ta.', style: const pw.TextStyle(fontSize: 14, color: _accent)),
        ),
        pw.Container(height: 10, decoration: const pw.BoxDecoration(gradient: _gradient)),
      ],
    ),
  );
}

List<pw.Widget> _block(int number, GeneratedReportBlock block, pw.Font bold, {required bool isLast}) {
  const bodyStyle = pw.TextStyle(fontSize: 11, color: _body, lineSpacing: 2.5);
  return [
    pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          width: 24,
          height: 24,
          alignment: pw.Alignment.center,
          decoration: const pw.BoxDecoration(gradient: _gradient, shape: pw.BoxShape.circle),
          child: pw.Text('$number', style: pw.TextStyle(font: bold, fontSize: 11, color: PdfColors.white)),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(child: pw.Text(block.title, style: pw.TextStyle(font: bold, fontSize: 17, color: _heading))),
      ],
    ),
    pw.SizedBox(height: 6),
    pw.Divider(color: _border, thickness: 1),
    pw.SizedBox(height: 8),
    for (final item in block.items) ...[
      if (item.heading != null) ...[
        pw.Text(item.heading!, style: pw.TextStyle(font: bold, fontSize: item.points.isNotEmpty ? 13 : 11.5, color: item.points.isNotEmpty ? _heading : _accent)),
        pw.SizedBox(height: 4),
      ],
      if (item.text.trim().isNotEmpty) pw.Text(item.text.trim(), style: isLast ? const pw.TextStyle(fontSize: 9.5, color: _muted, lineSpacing: 2) : bodyStyle),
      for (final point in item.points) ...[
        pw.SizedBox(height: 4),
        pw.RichText(
          text: pw.TextSpan(
            style: bodyStyle,
            children: [
              pw.TextSpan(text: '${point.label}: ', style: pw.TextStyle(font: bold, color: _accent)),
              pw.TextSpan(text: point.text.trim()),
            ],
          ),
        ),
      ],
      pw.SizedBox(height: item.points.isNotEmpty ? 14 : 10),
    ],
    pw.SizedBox(height: 16),
  ];
}
