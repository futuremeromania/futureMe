import 'package:futureme/core/data/ai_content_repository.dart';
import 'package:printing/printing.dart';

import 'report_pdf_builder.dart';

const _reportPdfFilename = 'Raport-FutureMe.pdf';

/// Opens the native print/save-as-PDF dialog for the final report.
Future<void> downloadReportPdf({required String userName, required GeneratedReport report}) async {
  final bytes = await buildReportPdf(userName: report.userName ?? userName, report: report);
  await Printing.layoutPdf(onLayout: (_) async => bytes, name: _reportPdfFilename);
}

/// Opens the native share sheet with the final report as a PDF attachment.
Future<void> shareReportPdf({required String userName, required GeneratedReport report}) async {
  final bytes = await buildReportPdf(userName: report.userName ?? userName, report: report);
  await Printing.sharePdf(bytes: bytes, filename: _reportPdfFilename);
}
