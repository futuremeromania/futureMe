/// Geometry for the spatial block of the aptitude test, as data.
///
/// The figures are described here rather than shipped as images: a picture
/// of a shape cannot be tapped, scales badly on a phone, and would freeze
/// the test's look to whatever tool drew it. Described this way, each
/// answer is a real option card the person selects, drawn crisply at any
/// size in the app's own colours.
///
/// The geometry is the item. Changing a coordinate here can change which
/// answer is correct, so nothing in this file is adjusted without checking
/// the key in `aptitude_test.dart` again.
library;

sealed class SpatialFigure {
  const SpatialFigure();
}

class Cell {
  const Cell(this.x, this.y);

  final int x;
  final int y;
}

/// A shape made of unit squares on a small grid, optionally with the black
/// dot that marks its orientation.
class GridShapeFigure extends SpatialFigure {
  const GridShapeFigure({required this.cells, required this.cols, required this.rows, this.dot});

  final List<Cell> cells;
  final int cols;
  final int rows;
  final Cell? dot;
}

enum FigureCorner { topLeft, topRight, bottomLeft, bottomRight }

/// One square holding a triangle in one corner and a circle in another.
class QuadCellFigure extends SpatialFigure {
  const QuadCellFigure({this.triangle, this.circle});

  final FigureCorner? triangle;
  final FigureCorner? circle;
}

/// The 2×2 pattern. A null quadrant is the one being asked about and is
/// drawn as a question mark.
class QuadPatternFigure extends SpatialFigure {
  const QuadPatternFigure(this.quadrants);

  /// Four entries, reading left-to-right then top-to-bottom.
  final List<QuadCellFigure?> quadrants;
}

/// The three-step fold-and-punch diagram.
class FoldStepsFigure extends SpatialFigure {
  const FoldStepsFigure();
}

/// A sheet with holes at fractional positions, 0-1 across and down.
class PunchedSheetFigure extends SpatialFigure {
  const PunchedSheetFigure(this.holes);

  final List<Hole> holes;
}

class Hole {
  const Hole(this.x, this.y);

  final double x;
  final double y;
}

enum FaceSymbol { diamond, star, square, circle, triangle, plus }

class NetFace {
  const NetFace(this.x, this.y, this.symbol);

  final int x;
  final int y;
  final FaceSymbol symbol;
}

/// The unfolded cube.
class CubeNetFigure extends SpatialFigure {
  const CubeNetFigure({required this.faces, required this.cols, required this.rows});

  final List<NetFace> faces;
  final int cols;
  final int rows;
}

/// A cube seen from a corner, showing three faces.
class CubeViewFigure extends SpatialFigure {
  const CubeViewFigure({required this.top, required this.left, required this.right});

  final FaceSymbol top;
  final FaceSymbol left;
  final FaceSymbol right;
}

class FigurePoint {
  const FigurePoint(this.x, this.y);

  final double x;
  final double y;
}

/// An outline: the bar, or one of the pieces offered to complete it.
class PolygonFigure extends SpatialFigure {
  const PolygonFigure(this.points);

  final List<FigurePoint> points;
}

class Voxel {
  const Voxel(this.x, this.y, this.z);

  final int x;
  final int y;
  final int z;
}

/// A stack of unit cubes drawn isometrically.
class VoxelFigure extends SpatialFigure {
  const VoxelFigure(this.cubes);

  final List<Voxel> cubes;
}

// ---------------------------------------------------------------------------
// Item 19 — rotation. The shape is an L of five cells with the dot at the
// far end of its long arm. The key is D, which is the shape turned a
// quarter-turn clockwise: A is the mirror image, B and C keep a correct
// outline but move the dot, which is exactly what the dot is there to
// catch.
// ---------------------------------------------------------------------------

const GridShapeFigure rotationPrompt = GridShapeFigure(
  cols: 3,
  rows: 3,
  cells: [Cell(0, 0), Cell(0, 1), Cell(0, 2), Cell(1, 2), Cell(2, 2)],
  dot: Cell(0, 0),
);

const List<GridShapeFigure> rotationOptions = [
  // A — mirrored, not rotated.
  GridShapeFigure(
    cols: 3,
    rows: 3,
    cells: [Cell(2, 0), Cell(2, 1), Cell(0, 2), Cell(1, 2), Cell(2, 2)],
    dot: Cell(2, 0),
  ),
  // B — right outline, dot at the wrong end.
  GridShapeFigure(
    cols: 3,
    rows: 3,
    cells: [Cell(0, 0), Cell(1, 0), Cell(2, 0), Cell(2, 1), Cell(2, 2)],
    dot: Cell(0, 0),
  ),
  // C — not rotated at all, dot moved.
  GridShapeFigure(
    cols: 3,
    rows: 3,
    cells: [Cell(0, 0), Cell(0, 1), Cell(0, 2), Cell(1, 2), Cell(2, 2)],
    dot: Cell(0, 2),
  ),
  // D — a quarter-turn clockwise, dot carried along. Correct.
  GridShapeFigure(
    cols: 3,
    rows: 3,
    cells: [Cell(0, 0), Cell(1, 0), Cell(2, 0), Cell(0, 1), Cell(0, 2)],
    dot: Cell(2, 0),
  ),
];

// ---------------------------------------------------------------------------
// Item 20 — the missing piece. Across the pattern the triangle walks
// left→right along the top, then top→bottom down the right; the circle
// always sits in the opposite corner. The empty quadrant therefore needs
// the triangle bottom-right and the circle top-left, which is D.
// ---------------------------------------------------------------------------

const QuadPatternFigure missingPiecePrompt = QuadPatternFigure([
  QuadCellFigure(triangle: FigureCorner.topLeft, circle: FigureCorner.bottomRight),
  QuadCellFigure(triangle: FigureCorner.topRight, circle: FigureCorner.bottomLeft),
  QuadCellFigure(triangle: FigureCorner.bottomLeft, circle: FigureCorner.topRight),
  null,
]);

const List<QuadCellFigure> missingPieceOptions = [
  QuadCellFigure(triangle: FigureCorner.topLeft, circle: FigureCorner.bottomRight),
  QuadCellFigure(triangle: FigureCorner.topRight, circle: FigureCorner.bottomLeft),
  QuadCellFigure(triangle: FigureCorner.bottomLeft, circle: FigureCorner.topRight),
  QuadCellFigure(triangle: FigureCorner.bottomRight, circle: FigureCorner.topLeft), // correct
];

// ---------------------------------------------------------------------------
// Item 21 — fold, punch, unfold. Two folds quarter the sheet, so the one
// hole reflects back into four, symmetric about both centre lines: B. A
// unfolds only one of the two folds; C and D break the symmetry.
// ---------------------------------------------------------------------------

const FoldStepsFigure foldPrompt = FoldStepsFigure();

const List<PunchedSheetFigure> foldOptions = [
  PunchedSheetFigure([Hole(0.22, 0.18), Hole(0.78, 0.18)]),
  PunchedSheetFigure([Hole(0.22, 0.18), Hole(0.78, 0.18), Hole(0.22, 0.82), Hole(0.78, 0.82)]), // correct
  PunchedSheetFigure([Hole(0.22, 0.18), Hole(0.78, 0.18), Hole(0.50, 0.48), Hole(0.50, 0.80)]),
  PunchedSheetFigure([Hole(0.18, 0.16), Hole(0.86, 0.46), Hole(0.20, 0.80), Hole(0.46, 0.80)]),
];

// ---------------------------------------------------------------------------
// Item 22 — the folded cube. In this net the star is opposite the circle,
// the triangle opposite the square and the diamond opposite the plus. A, B
// and C each show two opposite faces meeting at one corner, which folding
// cannot produce; only D shows three faces that are pairwise adjacent.
// ---------------------------------------------------------------------------

const CubeNetFigure cubeNetPrompt = CubeNetFigure(
  cols: 4,
  rows: 3,
  faces: [
    NetFace(1, 0, FaceSymbol.diamond),
    NetFace(0, 1, FaceSymbol.triangle),
    NetFace(1, 1, FaceSymbol.star),
    NetFace(2, 1, FaceSymbol.square),
    NetFace(3, 1, FaceSymbol.circle),
    NetFace(1, 2, FaceSymbol.plus),
  ],
);

const List<CubeViewFigure> cubeOptions = [
  CubeViewFigure(top: FaceSymbol.diamond, left: FaceSymbol.star, right: FaceSymbol.circle),
  CubeViewFigure(top: FaceSymbol.star, left: FaceSymbol.triangle, right: FaceSymbol.square),
  CubeViewFigure(top: FaceSymbol.circle, left: FaceSymbol.diamond, right: FaceSymbol.plus),
  CubeViewFigure(top: FaceSymbol.diamond, left: FaceSymbol.star, right: FaceSymbol.triangle), // correct
];

// ---------------------------------------------------------------------------
// Item 23 — counting the cubes. Built as a solid 5 × 4 × 5 block, which
// would be 100 cubes, with three bites taken out of the top layers: 4 × 3
// from the top, 3 × 2 from the next and 2 from the one below. 100 − 20 =
// 80, which is the key and also exactly the arithmetic the explanation
// walks through.
// ---------------------------------------------------------------------------

/// Heights of the 5 × 4 footprint, read as [x][y]. Summing them gives the
/// number of cubes — asserted in the test below.
const List<List<int>> cubeStructureHeights = [
  [5, 5, 5, 5],
  [5, 4, 4, 4],
  [5, 4, 3, 3],
  [5, 4, 3, 2],
  [5, 4, 3, 2],
];

/// The structure itself, built from those heights. It has to be a `const`
/// so it can sit inside the const item list, which is why it is a getter
/// over a literal rather than a loop.
final VoxelFigure cubeStructureFigure = VoxelFigure([
  for (int x = 0; x < cubeStructureHeights.length; x++)
    for (int y = 0; y < cubeStructureHeights[x].length; y++)
      for (int z = 0; z < cubeStructureHeights[x][y]; z++) Voxel(x, y, z),
]);

/// How many cubes the structure holds. Must stay 80 — that is the key.
int get cubeStructureCount =>
    cubeStructureHeights.fold(0, (sum, column) => sum + column.fold(0, (s, h) => s + h));

// ---------------------------------------------------------------------------
// Item 24 — completing the bar. The bar is a rectangle with one piece
// missing from its right end, and the gap has a V-shaped tongue reaching
// back into it.
//
// All four pieces have the same body and the same area, so the answer
// cannot be found by counting or by eye-balling size: only the outline
// decides. A has the tongue slid down into the corner, B has it too high,
// and D is C's mirror image — which is why the question says the piece may
// be turned but not flipped. C matches the gap vertex for vertex.
// ---------------------------------------------------------------------------

const PolygonFigure barPrompt = PolygonFigure([
  FigurePoint(0, 0),
  FigurePoint(13, 0),
  FigurePoint(13, 3),
  FigurePoint(11, 4),
  FigurePoint(13, 5),
  FigurePoint(0, 5),
]);

const List<PolygonFigure> barPieceOptions = [
  // A — the tongue sits in the bottom corner instead of above it.
  PolygonFigure([
    FigurePoint(2, 0),
    FigurePoint(5, 0),
    FigurePoint(5, 5),
    FigurePoint(2, 5),
    FigurePoint(0, 5),
    FigurePoint(2, 3),
  ]),
  // B — the tongue is too high up the edge.
  PolygonFigure([
    FigurePoint(2, 0),
    FigurePoint(5, 0),
    FigurePoint(5, 5),
    FigurePoint(2, 5),
    FigurePoint(2, 3),
    FigurePoint(0, 2),
    FigurePoint(2, 1),
  ]),
  // C — fills the gap exactly. Correct.
  PolygonFigure([
    FigurePoint(2, 0),
    FigurePoint(5, 0),
    FigurePoint(5, 5),
    FigurePoint(2, 5),
    FigurePoint(0, 4),
    FigurePoint(2, 3),
  ]),
  // D — C seen in a mirror. Turning it will never make it fit.
  PolygonFigure([
    FigurePoint(2, 2),
    FigurePoint(0, 1),
    FigurePoint(2, 0),
    FigurePoint(5, 0),
    FigurePoint(5, 5),
    FigurePoint(2, 5),
  ]),
];
