import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/main.dart';

void main() {
  testWidgets('Mini Katalog açılıyor', (tester) async {
    await tester.pumpWidget(const MiniCatalogApp());

    expect(find.text('Mini Katalog'), findsOneWidget);
  });
}