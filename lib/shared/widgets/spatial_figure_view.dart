import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:futureme/core/data/spatial_figures.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';

const Color _fill = Color(0xFFDCD2F5);
const Color _fillSoft = Color(0xFFEFEAFB);
const Color _fillStrong = Color(0xFFC3B3EE);
const Color _accent = Color(0xFF8E7BD4);
const Color _ink = AppColors.uiHeading;
const Color _hole = Color(0xFFD9636B);

/// Draws any of the spatial figures. One widget rather than a set of
/// images, so the same geometry serves the question, the option card and
/// the review screen at whatever size each of them has.
class SpatialFigureView extends StatelessWidget {
  const SpatialFigureView({super.key, required this.figure, this.height = 140});

  final SpatialFigure figure;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _FigurePainter(figure)),
    );
  }
}

class _FigurePainter extends CustomPainter {
  _FigurePainter(this.figure);

  final SpatialFigure figure;

  @override
  void paint(Canvas canvas, Size size) {
    switch (figure) {
      case GridShapeFigure f:
        _paintGridShape(canvas, size, f);
      case QuadCellFigure f:
        _paintQuadCell(canvas, size, f);
      case QuadPatternFigure f:
        _paintQuadPattern(canvas, size, f);
      case FoldStepsFigure _:
        _paintFoldSteps(canvas, size);
      case PunchedSheetFigure f:
        _paintPunchedSheet(canvas, size, f);
      case CubeNetFigure f:
        _paintCubeNet(canvas, size, f);
      case CubeViewFigure f:
        _paintCubeView(canvas, size, f);
      case VoxelFigure f:
        _paintVoxels(canvas, size, f);
      case PolygonFigure f:
        _paintPolygon(canvas, size, f);
    }
  }

  @override
  bool shouldRepaint(covariant _FigurePainter old) => old.figure != figure;
}

Paint get _fillPaint => Paint()..color = _fill;
Paint get _strokePaint => Paint()
  ..color = _ink
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2
  ..strokeJoin = StrokeJoin.round;

// ---------------------------------------------------------------------------

void _paintGridShape(Canvas canvas, Size size, GridShapeFigure f) {
  final cell = math.min(size.width / (f.cols + 0.6), size.height / (f.rows + 0.6));
  final originX = (size.width - cell * f.cols) / 2;
  final originY = (size.height - cell * f.rows) / 2;

  for (final c in f.cells) {
    final rect = Rect.fromLTWH(originX + c.x * cell, originY + c.y * cell, cell, cell);
    canvas.drawRect(rect, _fillPaint);
    canvas.drawRect(rect, _strokePaint);
  }

  final dot = f.dot;
  if (dot != null) {
    final centre = Offset(originX + (dot.x + 0.5) * cell, originY + (dot.y + 0.5) * cell);
    canvas.drawCircle(centre, cell * 0.2, Paint()..color = _ink);
  }
}

// ---------------------------------------------------------------------------

void _paintQuadCell(Canvas canvas, Size size, QuadCellFigure f) {
  final side = math.min(size.width, size.height) * 0.86;
  final rect = Rect.fromCenter(center: size.center(Offset.zero), width: side, height: side);
  canvas.drawRect(rect, Paint()..color = Colors.white);
  canvas.drawRect(rect, _strokePaint);
  _paintQuadContents(canvas, rect, f);
}

void _paintQuadContents(Canvas canvas, Rect rect, QuadCellFigure f) {
  final t = f.triangle;
  if (t != null) {
    final leg = rect.width * 0.36;
    final path = Path();
    switch (t) {
      case FigureCorner.topLeft:
        path
          ..moveTo(rect.left, rect.top)
          ..lineTo(rect.left + leg, rect.top)
          ..lineTo(rect.left, rect.top + leg);
      case FigureCorner.topRight:
        path
          ..moveTo(rect.right, rect.top)
          ..lineTo(rect.right - leg, rect.top)
          ..lineTo(rect.right, rect.top + leg);
      case FigureCorner.bottomLeft:
        path
          ..moveTo(rect.left, rect.bottom)
          ..lineTo(rect.left + leg, rect.bottom)
          ..lineTo(rect.left, rect.bottom - leg);
      case FigureCorner.bottomRight:
        path
          ..moveTo(rect.right, rect.bottom)
          ..lineTo(rect.right - leg, rect.bottom)
          ..lineTo(rect.right, rect.bottom - leg);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = _fillStrong);
  }

  final c = f.circle;
  if (c != null) {
    final r = rect.width * 0.11;
    final inset = rect.width * 0.26;
    final centre = switch (c) {
      FigureCorner.topLeft => Offset(rect.left + inset, rect.top + inset),
      FigureCorner.topRight => Offset(rect.right - inset, rect.top + inset),
      FigureCorner.bottomLeft => Offset(rect.left + inset, rect.bottom - inset),
      FigureCorner.bottomRight => Offset(rect.right - inset, rect.bottom - inset),
    };
    canvas.drawCircle(centre, r, Paint()..color = _accent);
    canvas.drawCircle(centre, r, Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);
  }
}

void _paintQuadPattern(Canvas canvas, Size size, QuadPatternFigure f) {
  final side = math.min(size.width, size.height) * 0.9;
  final outer = Rect.fromCenter(center: size.center(Offset.zero), width: side, height: side);
  final half = side / 2;

  canvas.drawRect(outer, Paint()..color = Colors.white);
  for (int i = 0; i < 4; i++) {
    final quadrant = Rect.fromLTWH(outer.left + (i % 2) * half, outer.top + (i ~/ 2) * half, half, half);
    final content = f.quadrants[i];
    if (content != null) {
      _paintQuadContents(canvas, quadrant.deflate(half * 0.06), content);
    } else {
      _drawText(canvas, "?", quadrant.center, half * 0.34, _accent, bold: true);
    }
    canvas.drawRect(quadrant, _strokePaint);
  }
}

// ---------------------------------------------------------------------------

void _paintFoldSteps(Canvas canvas, Size size) {
  // Three panels with an arrow between them: fold right over left, fold
  // bottom over top, then punch one hole.
  final unit = math.min(size.height * 0.62, size.width / 5.2);
  final top = (size.height - unit) / 2 - size.height * 0.06;
  final gap = unit * 0.55;
  final totalWidth = unit + gap + unit / 2 + gap + unit / 2;
  var x = (size.width - totalWidth) / 2;

  // 1. the whole sheet, folded right half onto the left.
  final sheet = Rect.fromLTWH(x, top, unit, unit);
  canvas.drawRect(sheet, Paint()..color = _fillSoft);
  canvas.drawRect(sheet, _strokePaint);
  canvas.drawLine(sheet.topCenter, sheet.bottomCenter, Paint()
    ..color = _accent
    ..strokeWidth = 1.5);
  _arrow(canvas, sheet.center + Offset(unit * 0.22, 0), sheet.center - Offset(unit * 0.02, 0));
  _drawText(canvas, "1. Dreapta peste stânga", Offset(sheet.center.dx, sheet.bottom + unit * 0.2), 9, AppColors.uiHeadingSmall);
  x += unit + gap;
  _chevron(canvas, Offset(x - gap / 2, sheet.center.dy));

  // 2. the half-width sheet, folded bottom onto top.
  final folded = Rect.fromLTWH(x, top, unit / 2, unit);
  canvas.drawRect(folded, Paint()..color = _fill);
  canvas.drawRect(folded, _strokePaint);
  canvas.drawLine(folded.centerLeft, folded.centerRight, Paint()
    ..color = _accent
    ..strokeWidth = 1.5);
  _arrow(canvas, folded.center + Offset(0, unit * 0.3), folded.center + Offset(0, unit * 0.04));
  _drawText(canvas, "2. Jos peste sus", Offset(folded.center.dx, folded.bottom + unit * 0.2), 9, AppColors.uiHeadingSmall);
  x += unit / 2 + gap;
  _chevron(canvas, Offset(x - gap / 2, sheet.center.dy));

  // 3. a quarter sheet with a single hole punched near its top-left.
  final quarter = Rect.fromLTWH(x, top + unit / 4, unit / 2, unit / 2);
  canvas.drawRect(quarter, Paint()..color = _fill);
  canvas.drawRect(quarter, _strokePaint);
  final punch = Offset(quarter.left + quarter.width * 0.28, quarter.top + quarter.height * 0.28);
  canvas.drawCircle(punch, unit * 0.055, Paint()..color = _hole);
  canvas.drawCircle(punch, unit * 0.055, Paint()
    ..color = _ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.2);
  _drawText(canvas, "3. Perforează", Offset(quarter.center.dx, quarter.bottom + unit * 0.2), 9, AppColors.uiHeadingSmall);
}

void _arrow(Canvas canvas, Offset from, Offset to) {
  final paint = Paint()
    ..color = _ink
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(from, to, paint);
  final direction = (to - from);
  final length = direction.distance;
  if (length == 0) return;
  final unit = direction / length;
  final normal = Offset(-unit.dy, unit.dx);
  final head = length * 0.35;
  canvas.drawLine(to, to - unit * head + normal * head * 0.6, paint);
  canvas.drawLine(to, to - unit * head - normal * head * 0.6, paint);
}

void _chevron(Canvas canvas, Offset centre) {
  final paint = Paint()
    ..color = _ink
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(centre - const Offset(7, 0), centre + const Offset(7, 0), paint);
  canvas.drawLine(centre + const Offset(7, 0), centre + const Offset(1, -5), paint);
  canvas.drawLine(centre + const Offset(7, 0), centre + const Offset(1, 5), paint);
}

void _paintPunchedSheet(Canvas canvas, Size size, PunchedSheetFigure f) {
  final side = math.min(size.width, size.height) * 0.84;
  final rect = Rect.fromCenter(center: size.center(Offset.zero), width: side, height: side);
  canvas.drawRect(rect, Paint()..color = _fillSoft);
  canvas.drawRect(rect, _strokePaint);

  for (final h in f.holes) {
    final centre = Offset(rect.left + rect.width * h.x, rect.top + rect.height * h.y);
    canvas.drawCircle(centre, side * 0.045, Paint()..color = _hole);
    canvas.drawCircle(centre, side * 0.045, Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2);
  }
}

// ---------------------------------------------------------------------------

void _paintCubeNet(Canvas canvas, Size size, CubeNetFigure f) {
  final cell = math.min(size.width / (f.cols + 0.4), size.height / (f.rows + 0.4));
  final originX = (size.width - cell * f.cols) / 2;
  final originY = (size.height - cell * f.rows) / 2;

  for (final face in f.faces) {
    final rect = Rect.fromLTWH(originX + face.x * cell, originY + face.y * cell, cell, cell);
    canvas.drawRect(rect, Paint()..color = Colors.white);
    canvas.drawRect(rect, _strokePaint);
    _drawSymbol(canvas, face.symbol, rect.center, cell * 0.44);
  }
}

void _paintCubeView(Canvas canvas, Size size, CubeViewFigure f) {
  final s = math.min(size.width, size.height) * 0.82;
  final w = s / 2;
  final e = w / 2;
  final c = size.center(Offset.zero);

  Offset p(double dx, double dy) => c + Offset(dx, dy);

  final top = Path()
    ..moveTo(p(0, -2 * e).dx, p(0, -2 * e).dy)
    ..lineTo(p(w, -e).dx, p(w, -e).dy)
    ..lineTo(p(0, 0).dx, p(0, 0).dy)
    ..lineTo(p(-w, -e).dx, p(-w, -e).dy)
    ..close();
  final left = Path()
    ..moveTo(p(-w, -e).dx, p(-w, -e).dy)
    ..lineTo(p(0, 0).dx, p(0, 0).dy)
    ..lineTo(p(0, 2 * e).dx, p(0, 2 * e).dy)
    ..lineTo(p(-w, e).dx, p(-w, e).dy)
    ..close();
  final right = Path()
    ..moveTo(p(w, -e).dx, p(w, -e).dy)
    ..lineTo(p(0, 0).dx, p(0, 0).dy)
    ..lineTo(p(0, 2 * e).dx, p(0, 2 * e).dy)
    ..lineTo(p(w, e).dx, p(w, e).dy)
    ..close();

  canvas.drawPath(top, Paint()..color = _fillSoft);
  canvas.drawPath(left, Paint()..color = _fill);
  canvas.drawPath(right, Paint()..color = _fillStrong);
  for (final path in [top, left, right]) {
    canvas.drawPath(path, _strokePaint);
  }

  _drawSymbol(canvas, f.top, p(0, -e), s * 0.26);
  _drawSymbol(canvas, f.left, p(-w / 2, e * 0.75), s * 0.26);
  _drawSymbol(canvas, f.right, p(w / 2, e * 0.75), s * 0.26);
}

void _drawSymbol(Canvas canvas, FaceSymbol symbol, Offset centre, double size) {
  final paint = Paint()
    ..color = _ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.8
    ..strokeJoin = StrokeJoin.round;
  final r = size / 2;

  switch (symbol) {
    case FaceSymbol.circle:
      canvas.drawCircle(centre, r * 0.86, paint);
    case FaceSymbol.square:
      canvas.drawRect(Rect.fromCenter(center: centre, width: size * 0.82, height: size * 0.82), paint);
    case FaceSymbol.diamond:
      canvas.drawPath(
        Path()
          ..moveTo(centre.dx, centre.dy - r)
          ..lineTo(centre.dx + r * 0.78, centre.dy)
          ..lineTo(centre.dx, centre.dy + r)
          ..lineTo(centre.dx - r * 0.78, centre.dy)
          ..close(),
        paint,
      );
    case FaceSymbol.triangle:
      canvas.drawPath(
        Path()
          ..moveTo(centre.dx, centre.dy - r)
          ..lineTo(centre.dx + r * 0.9, centre.dy + r * 0.75)
          ..lineTo(centre.dx - r * 0.9, centre.dy + r * 0.75)
          ..close(),
        paint,
      );
    case FaceSymbol.plus:
      canvas.drawLine(Offset(centre.dx, centre.dy - r), Offset(centre.dx, centre.dy + r), paint);
      canvas.drawLine(Offset(centre.dx - r, centre.dy), Offset(centre.dx + r, centre.dy), paint);
    case FaceSymbol.star:
      final path = Path();
      for (int i = 0; i < 10; i++) {
        final radius = i.isEven ? r : r * 0.42;
        final angle = -math.pi / 2 + i * math.pi / 5;
        final point = centre + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
        i == 0 ? path.moveTo(point.dx, point.dy) : path.lineTo(point.dx, point.dy);
      }
      path.close();
      canvas.drawPath(path, paint);
  }
}

// ---------------------------------------------------------------------------

/// Isometric stack of unit cubes. Painted back to front — a cube further
/// along x + y + z is nearer the viewer, so drawing in that order lets the
/// near ones cover what they hide.
void _paintVoxels(Canvas canvas, Size size, VoxelFigure f) {
  if (f.cubes.isEmpty) return;

  final maxX = f.cubes.map((c) => c.x).reduce(math.max) + 1;
  final maxY = f.cubes.map((c) => c.y).reduce(math.max) + 1;
  final maxZ = f.cubes.map((c) => c.z).reduce(math.max) + 1;

  // Unprojected extents, in units of the cube edge.
  final spanX = (maxX + maxY) * 0.866;
  final spanY = (maxX + maxY) * 0.5 + maxZ;
  final edge = math.min(size.width * 0.94 / spanX, size.height * 0.94 / spanY);

  final w = edge * 0.866;
  final h = edge * 0.5;

  final left = maxY * w;
  final originX = (size.width - spanX * edge) / 2 + left;
  final originY = (size.height - spanY * edge) / 2 + maxZ * edge;

  Offset project(double x, double y, double z) =>
      Offset(originX + (x - y) * w, originY + (x + y) * h - z * edge);

  final cubes = [...f.cubes]..sort((a, b) => (a.x + a.y + a.z).compareTo(b.x + b.y + b.z));

  final topPaint = Paint()..color = _fillSoft;
  final leftPaint = Paint()..color = _fill;
  final rightPaint = Paint()..color = _fillStrong;
  final edgePaint = Paint()
    ..color = _ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.1
    ..strokeJoin = StrokeJoin.round;

  for (final cube in cubes) {
    final x = cube.x.toDouble();
    final y = cube.y.toDouble();
    final z = cube.z.toDouble();

    Path face(List<List<double>> points) {
      final path = Path();
      for (int i = 0; i < points.length; i++) {
        final p = project(points[i][0], points[i][1], points[i][2]);
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      return path..close();
    }

    final top = face([
      [x, y, z + 1],
      [x + 1, y, z + 1],
      [x + 1, y + 1, z + 1],
      [x, y + 1, z + 1],
    ]);
    final rightFace = face([
      [x + 1, y, z],
      [x + 1, y + 1, z],
      [x + 1, y + 1, z + 1],
      [x + 1, y, z + 1],
    ]);
    final frontFace = face([
      [x, y + 1, z],
      [x + 1, y + 1, z],
      [x + 1, y + 1, z + 1],
      [x, y + 1, z + 1],
    ]);

    canvas.drawPath(frontFace, leftPaint);
    canvas.drawPath(rightFace, rightPaint);
    canvas.drawPath(top, topPaint);
    canvas.drawPath(frontFace, edgePaint);
    canvas.drawPath(rightFace, edgePaint);
    canvas.drawPath(top, edgePaint);
  }
}

// ---------------------------------------------------------------------------

/// An outline, scaled to fill the space it is given while keeping its
/// proportions — the angles and edge lengths are what the item is about,
/// so they must survive whatever size the card happens to be.
void _paintPolygon(Canvas canvas, Size size, PolygonFigure f) {
  if (f.points.isEmpty) return;

  final minX = f.points.map((p) => p.x).reduce(math.min);
  final maxX = f.points.map((p) => p.x).reduce(math.max);
  final minY = f.points.map((p) => p.y).reduce(math.min);
  final maxY = f.points.map((p) => p.y).reduce(math.max);

  final scale = math.min(size.width * 0.9 / (maxX - minX), size.height * 0.9 / (maxY - minY));
  final originX = (size.width - (maxX - minX) * scale) / 2 - minX * scale;
  final originY = (size.height - (maxY - minY) * scale) / 2 - minY * scale;

  final path = Path();
  for (int i = 0; i < f.points.length; i++) {
    final point = Offset(originX + f.points[i].x * scale, originY + f.points[i].y * scale);
    i == 0 ? path.moveTo(point.dx, point.dy) : path.lineTo(point.dx, point.dy);
  }
  path.close();

  canvas.drawPath(path, _fillPaint);
  canvas.drawPath(path, _strokePaint);
}

void _drawText(Canvas canvas, String text, Offset centre, double fontSize, Color color, {bool bold = false}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: AppFonts.body,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  )..layout();
  painter.paint(canvas, centre - Offset(painter.width / 2, painter.height / 2));
}
