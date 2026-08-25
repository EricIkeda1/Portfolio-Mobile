import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_flutter_material_expressive/app.dart';

void main() {
  testWidgets('abre o portfolio', (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.textContaining('Eric'), findsWidgets);
  });
}
